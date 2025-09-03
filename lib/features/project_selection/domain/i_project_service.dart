import '../../../core/utils/result.dart';
import 'project_model.dart';
import 'project_error.dart';

/// Interface for project operations
abstract class IProjectService {
  /// Gets all projects for the current authenticated user
  /// 
  /// Returns [Result.success] with list of user projects on successful fetch.
  /// Returns [Result.failure] with [ProjectError] if fetch fails.
  Future<Result<List<ProjectModel>, ProjectError>> getUserProjects();

  /// Gets a specific project by ID
  /// 
  /// Returns [Result.success] with project data on successful fetch.
  /// Returns [Result.failure] with [ProjectError] if project not found or fetch fails.
  Future<Result<ProjectModel, ProjectError>> getProjectById(String projectId);

  /// Creates a new project
  /// 
  /// Returns [Result.success] with created project data on successful creation.
  /// Returns [Result.failure] with [ProjectError] if creation fails.
  Future<Result<ProjectModel, ProjectError>> createProject({
    required String name,
    String? slug,
  });

  /// Updates an existing project
  /// 
  /// Returns [Result.success] with updated project data on successful update.
  /// Returns [Result.failure] with [ProjectError] if update fails.
  Future<Result<ProjectModel, ProjectError>> updateProject(ProjectModel project);

  /// Deletes a project by ID
  /// 
  /// Returns [Result.success] on successful deletion.
  /// Returns [Result.failure] with [ProjectError] if deletion fails.
  Future<Result<void, ProjectError>> deleteProject(String projectId);
}