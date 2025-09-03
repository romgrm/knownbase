import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/get_dep.dart';
import '../../../core/services/app_logger.dart';
import '../domain/i_project_service.dart';
import '../domain/project_model.dart';
import '../domain/project_error.dart';
import '../../../core/utils/data_state.dart';
import 'project_selection_state.dart';

/// Cubit for managing project selection state and operations
class ProjectSelectionCubit extends Cubit<ProjectSelectionState> {
  final IProjectService _projectService;

  ProjectSelectionCubit({
    IProjectService? service,
  })  : _projectService = service ?? getdep<IProjectService>(),
        super(ProjectSelectionState.initial());

  /// Initialize the cubit and load user projects
  Future<void> initialize() async {
    await loadUserProjects();
  }

  /// Load user projects from the service
  Future<void> loadUserProjects() async {
    emit(state.copyWith(
      projectsState: const DataState.loading(),
    ));

    try {
      final result = await _projectService.getUserProjects();
      if (result.isSuccess) {
        final projects = result.data!;
        emit(state.copyWith(
          projectsState: DataState.success(projects),
        ));
        AppLogger.info('PROJECT_SELECTION: Successfully loaded ${projects.length} projects');
      } else {
        final errorMessage = result.error?.message ?? 'Failed to load projects';
        emit(state.copyWith(
          projectsState: DataState.error(errorMessage),
        ));
        AppLogger.error('PROJECT_SELECTION: Failed to load projects', result.error);
      }
    } catch (e) {
      const errorMessage = 'Failed to load projects';
      emit(state.copyWith(
        projectsState: const DataState.error(errorMessage),
      ));
      AppLogger.error('PROJECT_SELECTION: Unexpected error loading projects', e);
    }
  }

  /// Select a project
  void selectProject(ProjectModel project) {
    emit(state.copyWith(selectedProject: project));
    AppLogger.info('PROJECT_SELECTION: Selected project ${project.name}');
  }

  /// Clear selected project
  void clearSelectedProject() {
    emit(state.clearSelectedProject());
    AppLogger.info('PROJECT_SELECTION: Cleared selected project');
  }

  /// Create a new project
  Future<void> createProject({
    required String name,
    String? slug,
  }) async {
    if (name.trim().isEmpty) {
      emit(state.copyWith(
        createProjectState: const DataState.error('Project name is required'),
      ));
      return;
    }

    emit(state.copyWith(
      createProjectState: const DataState.loading(),
    ));

    try {
      final result = await _projectService.createProject(
        name: name.trim(),
        slug: slug?.trim(),
      );

      if (result.isSuccess) {
        final createdProject = result.data!;
        emit(state.copyWith(
          createProjectState: DataState.success(createdProject),
        ));
        
        // Refresh the projects list to include the new project
        await loadUserProjects();
        
        // Auto-select the newly created project
        selectProject(createdProject);
        
        AppLogger.info('PROJECT_SELECTION: Successfully created project ${createdProject.name}');
      } else {
        final errorMessage = result.error?.message ?? 'Failed to create project';
        emit(state.copyWith(
          createProjectState: DataState.error(errorMessage),
        ));
        AppLogger.error('PROJECT_SELECTION: Failed to create project', result.error);
      }
    } catch (e) {
      const errorMessage = 'Failed to create project';
      emit(state.copyWith(
        createProjectState: const DataState.error(errorMessage),
      ));
      AppLogger.error('PROJECT_SELECTION: Unexpected error creating project', e);
    }
  }

  /// Retry loading projects
  Future<void> retryLoadProjects() async {
    await loadUserProjects();
  }

  /// Retry creating project
  Future<void> retryCreateProject({
    required String name,
    String? slug,
  }) async {
    await createProject(
      name: name,
      slug: slug,
    );
  }

  /// Clear create project state
  void clearCreateProjectState() {
    emit(state.copyWith(
      createProjectState: const DataState.idle(),
    ));
  }

  /// Get project by ID
  Future<ProjectModel?> getProjectById(String projectId) async {
    try {
      final result = await _projectService.getProjectById(projectId);
      if (result.isSuccess) {
        AppLogger.info('PROJECT_SELECTION: Successfully fetched project $projectId');
        return result.data!;
      } else {
        AppLogger.error('PROJECT_SELECTION: Failed to fetch project $projectId', result.error);
        return null;
      }
    } catch (e) {
      AppLogger.error('PROJECT_SELECTION: Unexpected error fetching project $projectId', e);
      return null;
    }
  }
}