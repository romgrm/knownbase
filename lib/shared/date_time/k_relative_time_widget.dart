import 'package:flutter/material.dart';
import '../../core/constants/k_fonts.dart';
import '../../core/constants/k_sizes.dart';

/// Widget for displaying relative time information (e.g., "2 hours ago")
class KRelativeTimeWidget extends StatelessWidget {
  const KRelativeTimeWidget({
    super.key,
    required this.dateTime,
    this.style,
    this.color,
    this.prefix = '',
    this.showIcon = false,
    this.icon = Icons.schedule,
  });

  final DateTime dateTime;
  final TextStyle? style;
  final Color? color;
  final String prefix;
  final bool showIcon;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final relativeTime = KRelativeTimeFormatter.format(dateTime);
    final displayText = prefix.isNotEmpty ? '$prefix $relativeTime' : relativeTime;
    
    final textStyle = style ?? KFonts.bodySmall.copyWith(
      color: color ?? Colors.grey[600],
    );

    if (showIcon) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: KSize.sm,
            color: color ?? Colors.grey[600],
          ),
          const SizedBox(width: KSize.xxxs),
          Text(displayText, style: textStyle),
        ],
      );
    }

    return Text(displayText, style: textStyle);
  }
}

/// Utility class for formatting relative time
class KRelativeTimeFormatter {
  const KRelativeTimeFormatter._();

  /// Format a DateTime as relative time (e.g., "2 hours ago", "just now")
  static String format(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.isNegative) {
      return 'in the future';
    }

    // Less than a minute
    if (difference.inSeconds < 60) {
      return 'just now';
    }

    // Minutes
    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes minute${minutes == 1 ? '' : 's'} ago';
    }

    // Hours
    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours hour${hours == 1 ? '' : 's'} ago';
    }

    // Days
    if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days day${days == 1 ? '' : 's'} ago';
    }

    // Weeks
    if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    }

    // Months
    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    }

    // Years
    final years = (difference.inDays / 365).floor();
    return '$years year${years == 1 ? '' : 's'} ago';
  }

  /// Format as short relative time (e.g., "2h", "3d")
  static String formatShort(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.isNegative) {
      return 'future';
    }

    // Less than a minute
    if (difference.inSeconds < 60) {
      return 'now';
    }

    // Minutes
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    }

    // Hours
    if (difference.inHours < 24) {
      return '${difference.inHours}h';
    }

    // Days
    if (difference.inDays < 7) {
      return '${difference.inDays}d';
    }

    // Weeks
    if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w';
    }

    // Months
    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo';
    }

    // Years
    final years = (difference.inDays / 365).floor();
    return '${years}y';
  }
}

/// Widget specifically for showing "Last updated" information
class KLastUpdatedWidget extends StatelessWidget {
  const KLastUpdatedWidget({
    super.key,
    required this.lastUpdated,
    this.showLabel = true,
    this.style,
    this.color,
    this.alignment = MainAxisAlignment.end,
  });

  final DateTime lastUpdated;
  final bool showLabel;
  final TextStyle? style;
  final Color? color;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final textStyle = style ?? KFonts.bodySmall.copyWith(
      color: color ?? Colors.grey[500],
    );

    if (showLabel) {
      return Row(
        mainAxisAlignment: alignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == MainAxisAlignment.start) ...[
            Icon(
              Icons.schedule,
              size: KSize.xs,
              color: color ?? Colors.grey[500],
            ),
            const SizedBox(width: KSize.xxxs),
          ],
          Text(
            'Last updated ${KRelativeTimeFormatter.format(lastUpdated)}',
            style: textStyle,
          ),
          if (alignment == MainAxisAlignment.end) ...[
            const SizedBox(width: KSize.xxxs),
            Icon(
              Icons.schedule,
              size: KSize.xs,
              color: color ?? Colors.grey[500],
            ),
          ],
        ],
      );
    }

    return KRelativeTimeWidget(
      dateTime: lastUpdated,
      style: textStyle,
      color: color,
    );
  }
}