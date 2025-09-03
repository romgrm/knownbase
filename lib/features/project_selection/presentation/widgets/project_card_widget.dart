import 'package:flutter/material.dart';
import '../../../../core/constants/k_sizes.dart';
import '../../../../core/constants/k_fonts.dart';
import '../../domain/project_model.dart';

/// Card widget for displaying individual project information
class ProjectCardWidget extends StatelessWidget {
  const ProjectCardWidget({
    super.key,
    required this.project,
    this.onTap,
    this.isSelected = false,
  });

  final ProjectModel project;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: KSize.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(KSize.radiusMedium),
        border: Border.all(
          color: isSelected 
              ? Theme.of(context).primaryColor 
              : Colors.grey[200]!,
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
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
                // Project Icon
                Container(
                  width: KSize.iconSizeXLarge,
                  height: KSize.iconSizeXLarge,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.8),
                        Theme.of(context).primaryColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(KSize.radiusDefault),
                  ),
                  child: const Icon(
                    Icons.folder,
                    color: Colors.white,
                    size: KSize.iconSizeDefault,
                  ),
                ),
                
                const SizedBox(width: KSize.md),
                
                // Project Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        style: KFonts.titleMedium.copyWith(
                          fontWeight: KFonts.semiBold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      if (project.slug.isNotEmpty) ...[
                        const SizedBox(height: KSize.xxxs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: KSize.xxs,
                            vertical: KSize.xxxs,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(KSize.radiusSmall),
                          ),
                          child: Text(
                            '/${project.slug}',
                            style: KFonts.bodySmall.copyWith(
                              fontFamily: 'monospace',
                              color: Colors.black54,
                              fontSize: KSize.fontSizeXS,
                            ),
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: KSize.xxs),
                      
                      // Members count
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            size: KSize.sm,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: KSize.xxxs),
                          Text(
                            '${project.members.length} member${project.members.length != 1 ? 's' : ''}',
                            style: KFonts.bodySmall.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: KSize.sm,
                  color: isSelected 
                      ? Theme.of(context).primaryColor
                      : Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Grid version of project card for compact display
class ProjectCardGridWidget extends StatelessWidget {
  const ProjectCardGridWidget({
    super.key,
    required this.project,
    this.onTap,
    this.isSelected = false,
  });

  final ProjectModel project;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(KSize.radiusMedium),
        border: Border.all(
          color: isSelected 
              ? Theme.of(context).primaryColor 
              : Colors.grey[200]!,
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
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
                        Theme.of(context).primaryColor.withOpacity(0.8),
                        Theme.of(context).primaryColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(KSize.radiusDefault),
                  ),
                  child: const Icon(
                    Icons.folder,
                    color: Colors.white,
                    size: KSize.iconSizeDefault,
                  ),
                ),
                
                const SizedBox(height: KSize.sm),
                
                Text(
                  project.name,
                  style: KFonts.titleSmall.copyWith(
                    fontWeight: KFonts.semiBold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: KSize.xxxs),
                
                Text(
                  '${project.members.length} member${project.members.length != 1 ? 's' : ''}',
                  style: KFonts.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}