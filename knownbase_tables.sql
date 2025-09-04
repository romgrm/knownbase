-- =====================================================
-- PARTIE 1 : CREATION DES TABLES
-- =====================================================

-- USERS
CREATE TABLE public.users (
  id uuid NOT NULL,
  name text NOT NULL DEFAULT ''::text,
  initials text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT users_pkey PRIMARY KEY (id),
  CONSTRAINT users_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id)
);

-- PROJECTS
CREATE TABLE public.projects (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL DEFAULT ''::text,
  slug text UNIQUE,
  created_by uuid NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT projects_pkey PRIMARY KEY (id),
  CONSTRAINT projects_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id)
);
CREATE INDEX projects_created_by_idx ON public.projects(created_by);

-- PROJECT MEMBERS
CREATE TABLE public.project_members (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  project_id uuid NOT NULL,
  user_id uuid NOT NULL,
  role text NOT NULL DEFAULT 'member'::text
    CHECK (role = ANY (ARRAY['owner','admin','member','viewer'])),
  joined_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT project_members_pkey PRIMARY KEY (id),
  CONSTRAINT project_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id),
  CONSTRAINT project_members_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id)
);
CREATE INDEX project_members_project_id_idx ON public.project_members(project_id);
CREATE INDEX project_members_user_id_idx ON public.project_members(user_id);

-- ITEMS TYPES
CREATE TABLE public.items_types (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT items_types_pkey PRIMARY KEY (id)
);

-- ITEMS
CREATE TABLE public.items (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  project_id uuid NOT NULL,
  item_type_id uuid NOT NULL,
  created_by uuid NOT NULL,
  title text NOT NULL,
  description text,
  solution text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT items_pkey PRIMARY KEY (id),
  CONSTRAINT items_item_type_id_fkey FOREIGN KEY (item_type_id) REFERENCES public.items_types(id),
  CONSTRAINT items_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id),
  CONSTRAINT items_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id)
);
CREATE INDEX items_project_id_idx ON public.items(project_id);
CREATE INDEX items_created_by_idx ON public.items(created_by);

-- ITEM TAGS
CREATE TABLE public.item_tags (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  item_id uuid NOT NULL,
  name text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT item_tags_pkey PRIMARY KEY (id),
  CONSTRAINT item_tags_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.items(id)
);
CREATE INDEX item_tags_item_id_idx ON public.item_tags(item_id);

-- =====================================================
-- PARTIE 2 : TRIGGERS
-- =====================================================

-- Trigger pour updated_at dans items
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_set_updated_at
BEFORE UPDATE ON public.items
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- =====================================================
-- PARTIE 3 : RLS + POLICIES
-- =====================================================

-- USERS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view themselves"
  ON public.users FOR SELECT
  USING (id = auth.uid());

CREATE POLICY "Users can update themselves"
  ON public.users FOR UPDATE
  USING (id = auth.uid());

CREATE POLICY "Users can insert themselves"
  ON public.users FOR INSERT
  WITH CHECK (id = auth.uid());

-- PROJECTS
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Project members can view"
  ON public.projects FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM public.project_members m
    WHERE m.project_id = projects.id
      AND m.user_id = auth.uid()
  ));

CREATE POLICY "Project creators can insert"
  ON public.projects FOR INSERT
  WITH CHECK (created_by = auth.uid());

CREATE POLICY "Project owners/admins can update"
  ON public.projects FOR UPDATE
  USING (EXISTS (
    SELECT 1 FROM public.project_members m
    WHERE m.project_id = projects.id
      AND m.user_id = auth.uid()
      AND m.role IN ('owner','admin')
  ));

-- PROJECT MEMBERS
ALTER TABLE public.project_members ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Members can view project membership"
  ON public.project_members FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM public.project_members m
    WHERE m.project_id = project_members.project_id
      AND m.user_id = auth.uid()
  ));

CREATE POLICY "Owners/admins can add members"
  ON public.project_members FOR INSERT
  WITH CHECK (EXISTS (
    SELECT 1 FROM public.project_members m
    WHERE m.project_id = project_members.project_id
      AND m.user_id = auth.uid()
      AND m.role IN ('owner','admin')
  ));

CREATE POLICY "Owners/admins can update members"
  ON public.project_members FOR UPDATE
  USING (EXISTS (
    SELECT 1 FROM public.project_members m
    WHERE m.project_id = project_members.project_id
      AND m.user_id = auth.uid()
      AND m.role IN ('owner','admin')
  ));

-- ITEMS TYPES
ALTER TABLE public.items_types ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view item types"
  ON public.items_types FOR SELECT
  USING (true);

-- ITEMS
ALTER TABLE public.items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Project members can view items"
  ON public.items FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM public.project_members m
    WHERE m.project_id = items.project_id
      AND m.user_id = auth.uid()
  ));

CREATE POLICY "Project members can insert items"
  ON public.items FOR INSERT
  WITH CHECK (EXISTS (
    SELECT 1 FROM public.project_members m
    WHERE m.project_id = items.project_id
      AND m.user_id = auth.uid()
  ));

CREATE POLICY "Creators and admins can update items"
  ON public.items FOR UPDATE
  USING (
    created_by = auth.uid() OR EXISTS (
      SELECT 1 FROM public.project_members m
      WHERE m.project_id = items.project_id
        AND m.user_id = auth.uid()
        AND m.role IN ('owner','admin')
    )
  );

-- ITEM TAGS
ALTER TABLE public.item_tags ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Project members can view tags"
  ON public.item_tags FOR SELECT
  USING (EXISTS (
    SELECT 1
    FROM public.items i
    JOIN public.project_members m ON m.project_id = i.project_id
    WHERE i.id = item_tags.item_id
      AND m.user_id = auth.uid()
  ));

CREATE POLICY "Project members can insert tags"
  ON public.item_tags FOR INSERT
  WITH CHECK (EXISTS (
    SELECT 1
    FROM public.items i
    JOIN public.project_members m ON m.project_id = i.project_id
    WHERE i.id = item_tags.item_id
      AND m.user_id = auth.uid()
  ));

CREATE POLICY "Creators/admins can update tags"
  ON public.item_tags FOR UPDATE
  USING (EXISTS (
    SELECT 1
    FROM public.items i
    JOIN public.project_members m ON m.project_id = i.project_id
    WHERE i.id = item_tags.item_id
      AND m.user_id = auth.uid()
      AND (m.role IN ('owner','admin') OR i.created_by = auth.uid())
  ));