import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/utils/result.dart';
import '../../../core/services/app_logger.dart';
import '../domain/i_project_service.dart';
import '../domain/project_model.dart';
import '../domain/project_error.dart';
import 'project_dto.dart';

/// Supabase implementation of the project service
class SupabaseProjectService implements IProjectService {
  final SupabaseClient _supabase;

  SupabaseProjectService({
    SupabaseClient? supabase,
  }) : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<Result<List<ProjectModel>, ProjectError>> getUserProjects() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        AppLogger.error('PROJECT_FETCH: User not authenticated');
        return const Result.failure(ProjectError.authenticationError);
      }

      AppLogger.info('PROJECT_FETCH: Fetching projects for user ${user.id}');

      // Ensure user exists in public.users table
      // await _ensureUserExists(user);

      // Get project IDs where user is a member
      final memberProjectIds = await _getUserProjectIds(user.id);

      // Build query based on whether user has member projects
      final query = _supabase.from('projects').select('''
            id, name, slug, created_by, created_at,
            project_members(
              id, project_id, user_id, role, joined_at
            )
          ''');

      final response = memberProjectIds.isNotEmpty
          ? await query.or(
              'created_by.eq.${user.id},id.in.(${memberProjectIds.join(',')})')
          : await query.eq('created_by', user.id);

      final List<ProjectModel> projects = [];
      for (final projectData in response as List) {
        final project =
            ProjectDto.fromJson(projectData).toDomain(currentUserId: user.id);
        projects.add(project);
      }

      AppLogger.info(
          'PROJECT_FETCH: Successfully fetched ${projects.length} projects');
      return Result.success(projects);
    } on PostgrestException catch (e) {
      AppLogger.error('PROJECT_FETCH: Supabase error: ${e.message}');
      return Result.failure(_mapPostgrestExceptionToError(e));
    } catch (e) {
      AppLogger.error('PROJECT_FETCH: Unexpected error', e);
      return const Result.failure(ProjectError.unknown);
    }
  }

  /// Helper method to get project IDs where user is a member
  Future<List<String>> _getUserProjectIds(String userId) async {
    try {
      final memberResponse = await _supabase
          .from('project_members')
          .select('project_id')
          .eq('user_id', userId);

      return (memberResponse as List)
          .map((row) => row['project_id'].toString())
          .toList();
    } catch (e) {
      AppLogger.warning('Failed to fetch user project memberships: $e');
      return [];
    }
  }

  @override
  Future<Result<ProjectModel, ProjectError>> getProjectById(
      String projectId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        return const Result.failure(ProjectError.authenticationError);
      }

      AppLogger.info('PROJECT_GET_BY_ID: Fetching project $projectId');

      final response = await _supabase.from('projects').select('''
            id, name, slug, created_by, created_at,
            project_members(
              id, project_id, user_id, role, joined_at
            )
          ''').eq('id', projectId).single();

      final project =
          ProjectDto.fromJson(response).toDomain(currentUserId: user.id);

      AppLogger.info(
          'PROJECT_GET_BY_ID: Successfully fetched project ${project.name}');
      return Result.success(project);
    } on PostgrestException catch (e) {
      AppLogger.error('PROJECT_GET_BY_ID: Supabase error: ${e.message}');
      if (e.code == 'PGRST116') {
        return const Result.failure(ProjectError.projectNotFound);
      }
      return Result.failure(_mapPostgrestExceptionToError(e));
    } catch (e) {
      AppLogger.error('PROJECT_GET_BY_ID: Unexpected error', e);
      return const Result.failure(ProjectError.unknown);
    }
  }

  @override
  Future<Result<ProjectModel, ProjectError>> createProject({
    required String name,
    String? slug,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        AppLogger.error('PROJECT_CREATE: No authenticated user');
        return const Result.failure(ProjectError.authenticationError);
      }

      AppLogger.info(
          'PROJECT_CREATE: Creating project: $name for user: ${user.id}');

      // Step 1: Ensure user exists in public.users table (critical for foreign key)
      try {
        await _ensureUserExists(user);
        AppLogger.info('PROJECT_CREATE: User profile confirmed for ${user.id}');
      } catch (e) {
        AppLogger.error('PROJECT_CREATE: Failed to ensure user exists: $e');
        return const Result.failure(ProjectError.databaseError);
      }

      final generatedSlug = slug ?? _generateSlugFromName(name);

      // Step 2: Prepare project data
      final projectData = {
        'name': name.trim(),
        'slug': generatedSlug,
        'created_by': user.id,
      };

      AppLogger.info(
          'PROJECT_CREATE: Attempting to insert project: $projectData');

      // Step 3: Create project with minimal select to avoid complex joins during creation
      final response = await _supabase
          .from('projects')
          .insert(projectData)
          .select('id, name, slug, created_by, created_at')
          .single();

      AppLogger.info(
          'PROJECT_CREATE: Project created successfully: ${response['id']}');

      // Step 4: Add creator as owner member
      await _supabase.from('project_members').insert({
        'project_id': response['id'],
        'user_id': user.id,
        'role': 'owner',
      });

      AppLogger.info('PROJECT_CREATE: Owner membership created');

      // Step 5: Fetch complete project data with members
      final completeProject = await _supabase.from('projects').select('''
            id, name, slug, created_by, created_at,
            project_members(
              id, project_id, user_id, role, joined_at
            )
          ''').eq('id', response['id']).single();

      final createdProject =
          ProjectDto.fromJson(completeProject).toDomain(currentUserId: user.id);

      AppLogger.info(
          'PROJECT_CREATE: Successfully created project ${createdProject.name}');
      return Result.success(createdProject);
    } on PostgrestException catch (e) {
      AppLogger.error(
          'PROJECT_CREATE: PostgrestException: ${e.message}, Code: ${e.code}');
      AppLogger.error('PROJECT_CREATE: Full error details: $e');
      return Result.failure(_mapPostgrestExceptionToError(e));
    } catch (e) {
      AppLogger.error('PROJECT_CREATE: Unexpected error: $e');
      return const Result.failure(ProjectError.unknown);
    }
  }

  /// Ensure user exists in public.users table
  Future<void> _ensureUserExists(User user) async {
    try {
      // Check if user already exists
      final existingUser = await _supabase
          .from('users')
          .select('id')
          .eq('id', user.id)
          .maybeSingle();

      // If user doesn't exist, create them
      if (existingUser == null) {
        AppLogger.info('Creating user record for ${user.email}');
        final emailName = (user.email?.split('@').first ?? '');
        final displayName = emailName.isNotEmpty ? emailName : 'User';
        final initials = _generateInitials(displayName);

        await _supabase.from('users').insert({
          'id': user.id,
          'name': displayName,
          'initials': initials,
          'created_at': user.createdAt,
        });

        AppLogger.info('Successfully created user record for ${user.email}');
      } else {
        AppLogger.info('User record already exists for ${user.email}');
      }
    } catch (e) {
      AppLogger.error('Failed to ensure user exists: $e');
      // This is critical for project creation, so we should throw
      throw Exception('Failed to create user profile: $e');
    }
  }

  @override
  Future<Result<ProjectModel, ProjectError>> updateProject(
      ProjectModel project) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        return const Result.failure(ProjectError.authenticationError);
      }

      AppLogger.info('PROJECT_UPDATE: Updating project ${project.id}');

      final projectDto = ProjectDto.fromDomain(project);

      final response = await _supabase
          .from('projects')
          .update(projectDto.toJson())
          .eq('id', project.id)
          .select()
          .single();

      final updatedProject =
          ProjectDto.fromJson(response).toDomain(currentUserId: user.id);

      AppLogger.info(
          'PROJECT_UPDATE: Successfully updated project ${updatedProject.name}');
      return Result.success(updatedProject);
    } on PostgrestException catch (e) {
      AppLogger.error('PROJECT_UPDATE: Supabase error: ${e.message}');
      return Result.failure(_mapPostgrestExceptionToError(e));
    } catch (e) {
      AppLogger.error('PROJECT_UPDATE: Unexpected error', e);
      return const Result.failure(ProjectError.unknown);
    }
  }

  @override
  Future<Result<void, ProjectError>> deleteProject(String projectId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        return const Result.failure(ProjectError.authenticationError);
      }

      AppLogger.info('PROJECT_DELETE: Deleting project $projectId');

      await _supabase.from('projects').delete().eq('id', projectId);

      AppLogger.info('PROJECT_DELETE: Successfully deleted project $projectId');
      return const Result.success(null);
    } on PostgrestException catch (e) {
      AppLogger.error('PROJECT_DELETE: Supabase error: ${e.message}');
      return Result.failure(_mapPostgrestExceptionToError(e));
    } catch (e) {
      AppLogger.error('PROJECT_DELETE: Unexpected error', e);
      return const Result.failure(ProjectError.unknown);
    }
  }

  /// Helper method to generate slug from name
  String _generateSlugFromName(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  /// Helper method to generate initials from a name
  String _generateInitials(String name) {
    if (name.isEmpty) return '';

    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';

    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    } else {
      return (words.first.substring(0, 1) + words.last.substring(0, 1))
          .toUpperCase();
    }
  }

  /// Maps PostgrestException to our domain ProjectError
  ProjectError _mapPostgrestExceptionToError(PostgrestException e) {
    switch (e.code) {
      case 'PGRST116':
        return ProjectError.projectNotFound;
      case 'PGRST301':
        return ProjectError.permissionDenied;
      case '23505':
        return ProjectError.invalidProjectData;
      default:
        if (e.message.toLowerCase().contains('network')) {
          return ProjectError.networkError;
        }
        if (e.message.toLowerCase().contains('database')) {
          return ProjectError.databaseError;
        }
        return ProjectError.serverError;
    }
  }
}
