import '../../../core/utils/data_state.dart';
import '../domain/project_model.dart';

/// State for project selection operations
class ProjectSelectionState {
  const ProjectSelectionState({
    required this.projectsState,
    required this.selectedProject,
    required this.createProjectState,
  });

  final DataState<List<ProjectModel>> projectsState;
  final ProjectModel? selectedProject;
  final DataState<ProjectModel> createProjectState;

  // Helper getters for derived states
  bool get isLoadingProjects => projectsState.isLoading;
  bool get hasProjectsError => projectsState.hasError;
  bool get isProjectsSuccess => projectsState.isSuccess;
  bool get isProjectsIdle => projectsState.isIdle;

  bool get isCreatingProject => createProjectState.isLoading;
  bool get hasCreateProjectError => createProjectState.hasError;
  bool get isCreateProjectSuccess => createProjectState.isSuccess;
  bool get isCreateProjectIdle => createProjectState.isIdle;

  /// Get user projects if available
  List<ProjectModel> get projects => projectsState.data ?? [];

  /// Check if user has projects
  bool get hasProjects => projects.isNotEmpty;

  /// Get projects error message
  String? get projectsErrorMessage => projectsState.errorMessage;

  /// Get create project error message
  String? get createProjectErrorMessage => createProjectState.errorMessage;

  /// Create a copy of this state with updated values
  ProjectSelectionState copyWith({
    DataState<List<ProjectModel>>? projectsState,
    ProjectModel? selectedProject,
    DataState<ProjectModel>? createProjectState,
  }) {
    return ProjectSelectionState(
      projectsState: projectsState ?? this.projectsState,
      selectedProject: selectedProject ?? this.selectedProject,
      createProjectState: createProjectState ?? this.createProjectState,
    );
  }

  /// Clear selected project
  ProjectSelectionState clearSelectedProject() {
    return ProjectSelectionState(
      projectsState: projectsState,
      selectedProject: null,
      createProjectState: createProjectState,
    );
  }

  /// Initial state
  factory ProjectSelectionState.initial() => const ProjectSelectionState(
    projectsState: DataState.idle(),
    selectedProject: null,
    createProjectState: DataState.idle(),
  );
}