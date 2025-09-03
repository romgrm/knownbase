import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knownbase/features/project_creation/presentation/new_project_modal.dart';
import '../../../core/constants/k_sizes.dart';
import '../../../core/constants/k_fonts.dart';
import '../../../shared/app_bar/app_bar.dart';
import '../../../shared/loader/k_loader.dart';
import '../../../shared/error/k_error_widget.dart';
import '../application/project_selection_cubit.dart';
import '../application/project_selection_state.dart';
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
      body: BlocBuilder<ProjectSelectionCubit, ProjectSelectionState>(
        builder: (context, state) {
          if (state.isLoadingProjects) {
            return const KCenteredLoader(
              message: 'Loading your projects...',
            );
          }
          
          if (state.hasProjectsError) {
            return KNetworkErrorWidget(
              onRetry: () => context.read<ProjectSelectionCubit>().retryLoadProjects(),
            );
          }
          
          if (!state.hasProjects) {
            return EmptyProjectsStateWidget(
              onCreateProject: () => _showNewProjectModal(context),
            );
          }
          
          return Padding(
            padding: const EdgeInsets.all(KSize.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: KSize.lg),
                Expanded(
                  child: _buildProjectsList(context, state),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Projects',
              style: KFonts.headlineSmall.copyWith(
                fontWeight: KFonts.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: KSize.xxxs),
            Text(
              'Select a project to continue',
              style: KFonts.bodyMedium.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        FloatingActionButton(
          onPressed: () => _showNewProjectModal(context),
          mini: true,
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildProjectsList(BuildContext context, ProjectSelectionState state) {
    return ListView.builder(
      itemCount: state.projects.length + 1, // +1 for create new project card
      itemBuilder: (context, index) {
        if (index == 0) {
          return EmptyProjectCardWidget(
            onTap: () => _showNewProjectModal(context),
          );
        }
        
        final project = state.projects[index - 1];
        final isSelected = state.selectedProject?.id == project.id;
        
        return ProjectCardWidget(
          project: project,
          isSelected: isSelected,
          onTap: () {
            context.read<ProjectSelectionCubit>().selectProject(project);
            // TODO: Navigate to dashboard
          },
        );
      },
    );
  }
}