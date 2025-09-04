import 'package:flutter/material.dart';
import '../../core/constants/k_sizes.dart';
import '../../core/constants/k_fonts.dart';

/// Generic pill widget for displaying status, roles, or categories
class KPillWidget extends StatelessWidget {
  const KPillWidget({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.onTap,
    this.size = KPillSize.medium,
    this.variant = KPillVariant.filled,
  });

  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final KPillSize size;
  final KPillVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Size configuration
    final EdgeInsets padding;
    final TextStyle textStyle;
    final double borderRadius;
    
    switch (size) {
      case KPillSize.small:
        padding = const EdgeInsets.symmetric(
          horizontal: KSize.xxs,
          vertical: KSize.xxxs,
        );
        textStyle = KFonts.bodySmall;
        borderRadius = KSize.radiusSmall;
        break;
      case KPillSize.medium:
        padding = const EdgeInsets.symmetric(
          horizontal: KSize.xs,
          vertical: KSize.xxs,
        );
        textStyle = KFonts.labelSmall;
        borderRadius = KSize.radiusDefault;
        break;
      case KPillSize.large:
        padding = const EdgeInsets.symmetric(
          horizontal: KSize.sm,
          vertical: KSize.xs,
        );
        textStyle = KFonts.labelMedium;
        borderRadius = KSize.radiusMedium;
        break;
    }

    // Color and style configuration
    Color finalBackgroundColor;
    Color finalTextColor;
    Color? finalBorderColor;
    
    switch (variant) {
      case KPillVariant.filled:
        finalBackgroundColor = backgroundColor ?? theme.colorScheme.primary;
        finalTextColor = textColor ?? theme.colorScheme.onPrimary;
        finalBorderColor = null;
        break;
      case KPillVariant.outlined:
        finalBackgroundColor = Colors.transparent;
        finalTextColor = textColor ?? (backgroundColor ?? theme.colorScheme.primary);
        finalBorderColor = borderColor ?? (backgroundColor ?? theme.colorScheme.primary);
        break;
      case KPillVariant.soft:
        final baseColor = backgroundColor ?? theme.colorScheme.primary;
        finalBackgroundColor = baseColor.withOpacity(0.1);
        finalTextColor = textColor ?? baseColor;
        finalBorderColor = null;
        break;
    }

    final widget = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: finalBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: finalBorderColor != null
            ? Border.all(color: finalBorderColor, width: 1.0)
            : null,
      ),
      child: Text(
        text,
        style: textStyle.copyWith(
          color: finalTextColor,
          fontWeight: KFonts.medium,
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: widget,
      );
    }

    return widget;
  }
}

/// Predefined pill variants for common use cases
enum KPillVariant {
  filled,   // Solid background
  outlined, // Border only
  soft,     // Light background with matching text color
}

/// Predefined pill sizes
enum KPillSize {
  small,
  medium,
  large,
}

/// Predefined pill colors for common statuses
class KPillColors {
  const KPillColors._();
  
  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // Role colors
  static const Color owner = Color(0xFF8B5CF6);
  static const Color admin = Color(0xFF06B6D4);
  static const Color member = Color(0xFF6B7280);
  static const Color viewer = Color(0xFF9CA3AF);
  
  // Project status colors
  static const Color current = Color(0xFF10B981);
  static const Color active = Color(0xFF3B82F6);
  static const Color inactive = Color(0xFF6B7280);
  static const Color archived = Color(0xFF9CA3AF);
}

/// Predefined pill widgets for common use cases
class KStatusPill extends StatelessWidget {
  const KStatusPill.success({
    super.key,
    required this.text,
    this.size = KPillSize.medium,
    this.variant = KPillVariant.soft,
  }) : color = KPillColors.success;

  const KStatusPill.warning({
    super.key,
    required this.text,
    this.size = KPillSize.medium,
    this.variant = KPillVariant.soft,
  }) : color = KPillColors.warning;

  const KStatusPill.error({
    super.key,
    required this.text,
    this.size = KPillSize.medium,
    this.variant = KPillVariant.soft,
  }) : color = KPillColors.error;

  const KStatusPill.info({
    super.key,
    required this.text,
    this.size = KPillSize.medium,
    this.variant = KPillVariant.soft,
  }) : color = KPillColors.info;

  final String text;
  final Color color;
  final KPillSize size;
  final KPillVariant variant;

  @override
  Widget build(BuildContext context) {
    return KPillWidget(
      text: text,
      backgroundColor: color,
      size: size,
      variant: variant,
    );
  }
}

/// Role pill for displaying user roles
class KRolePill extends StatelessWidget {
  const KRolePill({
    super.key,
    required this.role,
    this.size = KPillSize.small,
  });

  final String role;
  final KPillSize size;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (role.toLowerCase()) {
      case 'owner':
        color = KPillColors.owner;
        break;
      case 'admin':
        color = KPillColors.admin;
        break;
      case 'member':
        color = KPillColors.member;
        break;
      case 'viewer':
        color = KPillColors.viewer;
        break;
      default:
        color = KPillColors.member;
    }

    return KPillWidget(
      text: role,
      backgroundColor: color,
      size: size,
      variant: KPillVariant.soft,
    );
  }
}

/// Current project indicator pill
class KCurrentProjectPill extends StatelessWidget {
  const KCurrentProjectPill({
    super.key,
    this.size = KPillSize.small,
  });

  final KPillSize size;

  @override
  Widget build(BuildContext context) {
    return KPillWidget(
      text: 'Current',
      backgroundColor: KPillColors.current,
      size: size,
      variant: KPillVariant.soft,
    );
  }
}