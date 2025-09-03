import 'package:flutter/material.dart';
import '../../../../core/constants/k_sizes.dart';
import '../../../../core/constants/k_fonts.dart';

/// Card widget for creating new projects (empty state action card)
class EmptyProjectCardWidget extends StatelessWidget {
  const EmptyProjectCardWidget({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: KSize.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(KSize.radiusMedium),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          width: 2.0,
          style: BorderStyle.solid,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(KSize.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(KSize.lg),
            child: Row(
              children: [
                // Create Icon with animated background
                Container(
                  width: KSize.iconSizeXLarge,
                  height: KSize.iconSizeXLarge,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.1),
                        Theme.of(context).primaryColor.withOpacity(0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(KSize.radiusDefault),
                  ),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Theme.of(context).primaryColor,
                    size: KSize.iconSizeDefault,
                  ),
                ),
                
                const SizedBox(width: KSize.md),
                
                // Create Project Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create New Project',
                        style: KFonts.titleMedium.copyWith(
                          fontWeight: KFonts.semiBold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      
                      const SizedBox(height: KSize.xxxs),
                      
                      Text(
                        'Start organizing your knowledge base',
                        style: KFonts.bodyMedium.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Plus Icon
                Icon(
                  Icons.add,
                  size: KSize.iconSizeDefault,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Grid version of empty project card
class EmptyProjectCardGridWidget extends StatelessWidget {
  const EmptyProjectCardGridWidget({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(KSize.radiusMedium),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          width: 2.0,
          style: BorderStyle.solid,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(KSize.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(KSize.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: KSize.iconSizeXLarge,
                  height: KSize.iconSizeXLarge,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.1),
                        Theme.of(context).primaryColor.withOpacity(0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(KSize.radiusDefault),
                  ),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Theme.of(context).primaryColor,
                    size: KSize.iconSizeDefault,
                  ),
                ),
                
                const SizedBox(height: KSize.sm),
                
                Text(
                  'Create Project',
                  style: KFonts.titleSmall.copyWith(
                    fontWeight: KFonts.semiBold,
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: KSize.xxxs),
                
                Text(
                  'Get started',
                  style: KFonts.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Full-screen empty state widget for when user has no projects
class EmptyProjectsStateWidget extends StatelessWidget {
  const EmptyProjectsStateWidget({
    super.key,
    this.onCreateProject,
  });

  final VoidCallback? onCreateProject;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(KSize.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration
            Container(
              width: KSize.iconSizeXLarge * 3,
              height: KSize.iconSizeXLarge * 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    Theme.of(context).primaryColor.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(KSize.radiusLarge),
              ),
              child: Icon(
                Icons.folder_open,
                size: KSize.iconSizeXLarge * 1.5,
                color: Theme.of(context).primaryColor.withOpacity(0.7),
              ),
            ),
            
            const SizedBox(height: KSize.lg),
            
            Text(
              'No Projects Yet',
              style: KFonts.headlineSmall.copyWith(
                fontWeight: KFonts.semiBold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: KSize.sm),
            
            Text(
              'Create your first project to start\norganizing your knowledge base',
              style: KFonts.bodyLarge.copyWith(
                color: Colors.grey[600],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: KSize.xl),
            
            ElevatedButton.icon(
              onPressed: onCreateProject,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: KSize.xl,
                  vertical: KSize.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(KSize.radiusMedium),
                ),
                elevation: 4,
              ),
              icon: const Icon(Icons.add, size: KSize.iconSizeDefault),
              label: Text(
                'Create Your First Project',
                style: KFonts.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: KFonts.semiBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}