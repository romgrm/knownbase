import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knownbase/core/router/app_router.dart';
import 'package:knownbase/core/theme/app_theme.dart';
import 'package:knownbase/features/project_creation/presentation/new_project_modal.dart';
import 'package:knownbase/shared/buttons/k_button.dart';
import 'package:knownbase/shared/cards/k_card.dart';
import '../../../core/constants/k_sizes.dart';
import '../../../shared/app_bar/app_bar.dart';
import '../../../shared/loader/k_loader.dart';
import '../../../shared/error/k_error_widget.dart';
import '../application/project_selection_cubit.dart';
import '../application/project_selection_state.dart';
import '../domain/project_model.dart';
import 'widgets/project_card_widget.dart';
import 'widgets/empty_project_card_widget.dart';

class ProjectSelectionScreen extends StatelessWidget {
  const ProjectSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectSelectionCubit()..initialize(),
      child: const _ProjectSelectionView(),
    );
  }
}

class _ProjectSelectionView extends StatelessWidget {
  const _ProjectSelectionView();

  Future<void> _showNewProjectModal(BuildContext context) async {
    final cubit = context.read<ProjectSelectionCubit>();
    final result = await showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const NewProjectModal(),
    );

    if (result != null) {
      // Handle the project creation result
      final projectName = result['name'];
      final slug = result['slug'];

      cubit.createProject(
        name: projectName ?? '',
        slug: slug,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KnownBaseAppBar(
        projectName: 'Select Project',
        userName: 'John Doe',
        userEmail: 'john@company.com',
      ),
      body: Column(
        children: [
          const Divider(),
          const HeaderWidget(),
          BlocBuilder<ProjectSelectionCubit, ProjectSelectionState>(
            builder: (context, state) {
              if (state.isLoadingProjects) {
                return const KCenteredLoader(
                  message: 'Loading your projects...',
                );
              }

              if (state.hasProjectsError) {
                return KNetworkErrorWidget(
                  onRetry: () =>
                      context.read<ProjectSelectionCubit>().retryLoadProjects(),
                );
              }

              if (!state.hasProjects) {
                return EmptyProjectsStateWidget(
                  onCreateProject: () => _showNewProjectModal(context),
                );
              }
              return Expanded(
                child: Container(
                    color: context.colorScheme.surface,
                    padding: EdgeInsets.zero,
                    child: ProjectListBuilder(
                        projects: state.projects,
                        selectedProject: state.projects.first,
                        onProjectTap: (project) {
                          AppRouter.navigateToDashboard(context);
                        })),
              );
            },
          ),
        ],
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return KCard(
      backgroundColor: context.colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Projects', style: context.textTheme.subheading),
              const SizedBox(height: KSize.xxxs),
              Text('Select a project or create a new one',
                  style: context.textTheme.description),
            ],
          ),
          Row(
            children: [
              KButton(
                text: "Join Project",
                onPressed: () => {},
                variant: KButtonVariant.primary,
                icon: Icons.people,
              ),
              const SizedBox(width: KSize.xs),
              KButton(
                text: "Create New Project",
                onPressed: () => {},
                variant: KButtonVariant.primary,
                icon: Icons.add,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ProjectListBuilder extends StatelessWidget {
  final List<ProjectModel> projects;
  final ProjectModel? selectedProject;
  final void Function(ProjectModel) onProjectTap;

  const ProjectListBuilder({
    super.key,
    required this.projects,
    required this.selectedProject,
    required this.onProjectTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: projects.length,
      padding: const EdgeInsets.all(KSize.md),
      itemBuilder: (context, index) {
        final project = projects[index];
        final isSelected = selectedProject?.id == project.id;

        return ProjectCardWidget(
          project: project,
          isSelected: isSelected,
          onTap: () {
            onProjectTap(project);
          },
        );
      },
    );
  }
}
