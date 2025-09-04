import 'package:flutter/material.dart';
import 'package:knownbase/core/theme/app_theme.dart';
import '../../../../core/constants/k_sizes.dart';
import '../../../../core/constants/k_fonts.dart';
import '../../../../shared/pills/k_pill_widget.dart';
import '../../../../shared/avatars/k_avatar_widget.dart';
import '../../../../shared/date_time/k_relative_time_widget.dart';
import '../utils/initials_generator.dart';
import '../../domain/project_model.dart';

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
    final initials = InitialsGenerator.generate(project.name);

    return Container(
      margin: const EdgeInsets.only(bottom: KSize.sm),
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: BorderRadius.circular(KSize.radiusMedium),
        border: Border.all(
          color: isSelected
              ? Theme.of(context).primaryColor
              : context.colorScheme.onSurface.withOpacity(0.2),
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
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
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project Icon with Initials
                    Container(
                      width: KSize.iconSizeXLarge,
                      height: KSize.iconSizeXLarge,
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFF3B82F6), // Blue color from design
                        borderRadius:
                            BorderRadius.circular(KSize.radiusDefault),
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: KFonts.titleSmall.copyWith(
                            color: Colors.white,
                            fontWeight: KFonts.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: KSize.md),

                    // Project Title and Current Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  project.name,
                                  style: context.textTheme.subheading,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (project.isCurrent) ...[
                                const SizedBox(width: KSize.xs),
                                const KCurrentProjectPill(),
                              ],
                            ],
                          ),

                          // Description
                          // if (project.description.isNotEmpty) ...[
                          const SizedBox(height: KSize.xxs),
                          Text(
                            // project.description,
                            "Projet de creation d'une app mobile a visée éducative",
                            style: context.textTheme.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        // ],
                      ),
                    ),

                    // Role Pill (top right)
                    KRolePill(role: project.userRole),
                  ],
                ),

                const SizedBox(height: KSize.md),

                // Stats Row (Members and Cards count)
                Row(
                  children: [
                    // Members Count
                    _StatItem(
                      icon: Icons.people,
                      count: project.members.length,
                      label: 'member',
                    ),

                    const SizedBox(width: KSize.lg),

                    // Cards Count
                    _StatItem(
                      icon: Icons.article,
                      count: project.cardsCount,
                      label: 'card',
                    ),

                    const Spacer(),

                    // Last Updated
                    if (project.lastUpdated != null)
                      KLastUpdatedWidget(
                        lastUpdated: project.lastUpdated!,
                        showLabel: false,
                      ),
                  ],
                ),

                const SizedBox(height: KSize.md),

                // Team Members Row
                Row(
                  children: [
                    // Member Avatars
                    if (project.members.isNotEmpty)
                      KAvatarStack(
                        avatars: project.members.take(4).map((member) {
                          // For demo purposes, generate initials from member ID or use placeholder
                          final memberInitials =
                              InitialsGenerator.generate(member.userId);
                          return KAvatarData(initials: memberInitials);
                        }).toList(),
                        size: KAvatarSize.small,
                        maxVisible: 3,
                      ),

                    const SizedBox(width: KSize.sm),

                    // Active Team Label
                    Text(
                      'Active team',
                      style: KFonts.bodySmall.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Internal widget for displaying stat items (members, cards count)
class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.count,
    required this.label,
  });

  final IconData icon;
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: KSize.sm,
        ),
        const SizedBox(width: KSize.xxxs),
        Text('$count $label${count != 1 ? 's' : ''}',
            style: context.textTheme.description),
      ],
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
          color:
              isSelected ? Theme.of(context).primaryColor : Colors.grey[200]!,
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
