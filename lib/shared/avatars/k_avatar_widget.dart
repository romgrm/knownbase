import 'package:flutter/material.dart';
import '../../core/constants/k_sizes.dart';
import '../../core/constants/k_fonts.dart';

/// Generic avatar widget for displaying user profile images or initials
class KAvatarWidget extends StatelessWidget {
  const KAvatarWidget({
    super.key,
    this.initials,
    this.imageUrl,
    this.backgroundColor,
    this.textColor,
    this.size = KAvatarSize.medium,
    this.borderColor,
    this.borderWidth = 0.0,
    this.onTap,
  });

  final String? initials;
  final String? imageUrl;
  final Color? backgroundColor;
  final Color? textColor;
  final KAvatarSize size;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // Size configuration
    final double avatarSize;
    final TextStyle textStyle;

    switch (size) {
      case KAvatarSize.small:
        avatarSize = KSize.iconSizeDefault;
        textStyle = KFonts.bodySmall;
        break;
      case KAvatarSize.medium:
        avatarSize = KSize.iconSizeLarge;
        textStyle = KFonts.labelMedium;
        break;
      case KAvatarSize.large:
        avatarSize = KSize.iconSizeXLarge;
        textStyle = KFonts.titleSmall;
        break;
      case KAvatarSize.extraLarge:
        avatarSize = KSize.iconSizeXLarge * 1.5;
        textStyle = KFonts.titleMedium;
        break;
    }

    final theme = Theme.of(context);
    final finalBackgroundColor =
        backgroundColor ?? _generateAvatarColor(initials ?? '', theme);
    final finalTextColor = textColor ?? Colors.white;

    Widget avatarContent;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      // Display network image
      avatarContent = CircleAvatar(
        radius: avatarSize / 2,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: finalBackgroundColor,
        onBackgroundImageError: (_, __) {
          // Fallback to initials if image fails to load
        },
        child: imageUrl!.isEmpty && initials != null
            ? Text(
                initials!,
                style: textStyle.copyWith(
                  color: finalTextColor,
                  fontWeight: KFonts.semiBold,
                ),
              )
            : null,
      );
    } else {
      // Display initials
      avatarContent = CircleAvatar(
        radius: avatarSize / 2,
        backgroundColor: finalBackgroundColor,
        child: Text(
          initials ?? '?',
          style: textStyle.copyWith(
            color: finalTextColor,
            fontWeight: KFonts.semiBold,
          ),
        ),
      );
    }

    // Add border if specified
    Widget finalAvatar = avatarContent;
    if (borderWidth > 0 && borderColor != null) {
      finalAvatar = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor!,
            width: borderWidth,
          ),
        ),
        child: avatarContent,
      );
    }

    // Make it tappable if onTap is provided
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(avatarSize / 2),
        child: finalAvatar,
      );
    }

    return finalAvatar;
  }

  /// Generate a consistent color based on the initials
  Color _generateAvatarColor(String initials, ThemeData theme) {
    if (initials.isEmpty) return theme.colorScheme.primary;

    final colors = [
      const Color(0xFF3B82F6), // Blue
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFF10B981), // Green
      const Color(0xFFF59E0B), // Orange
      const Color(0xFFEF4444), // Red
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFF84CC16), // Lime
      const Color(0xFFF97316), // Orange-red
      const Color(0xFF6366F1), // Indigo
      const Color(0xFFEC4899), // Pink
    ];

    int hash = 0;
    for (int i = 0; i < initials.length; i++) {
      hash = ((hash << 5) - hash + initials.codeUnitAt(i)) & 0xffffffff;
    }

    return colors[hash.abs() % colors.length];
  }
}

/// Predefined avatar sizes
enum KAvatarSize {
  small,
  medium,
  large,
  extraLarge,
}

/// Stack of avatars for showing multiple users
class KAvatarStack extends StatelessWidget {
  const KAvatarStack({
    super.key,
    required this.avatars,
    this.maxVisible = 4,
    this.size = KAvatarSize.small,
    this.overlapFactor = 0.7,
    this.showCount = true,
  });

  final List<KAvatarData> avatars;
  final int maxVisible;
  final KAvatarSize size;
  final double overlapFactor;
  final bool showCount;

  @override
  Widget build(BuildContext context) {
    if (avatars.isEmpty) return const SizedBox.shrink();

    final double avatarSize;
    switch (size) {
      case KAvatarSize.small:
        avatarSize = KSize.iconSizeDefault;
        break;
      case KAvatarSize.medium:
        avatarSize = KSize.iconSizeLarge;
        break;
      case KAvatarSize.large:
        avatarSize = KSize.iconSizeXLarge;
        break;
      case KAvatarSize.extraLarge:
        avatarSize = KSize.iconSizeXLarge * 1.5;
        break;
    }

    final visibleAvatars = avatars.take(maxVisible).toList();
    final remainingCount = avatars.length - maxVisible;
    final overlapOffset = avatarSize * overlapFactor;

    return SizedBox(
      width: (visibleAvatars.length - 1) * overlapOffset +
          avatarSize +
          (remainingCount > 0 && showCount ? overlapOffset + avatarSize : 0),
      height: avatarSize,
      child: Stack(
        children: [
          // Render visible avatars
          ...visibleAvatars.asMap().entries.map((entry) {
            final index = entry.key;
            final avatar = entry.value;

            return Positioned(
              left: index * overlapOffset,
              child: KAvatarWidget(
                initials: avatar.initials,
                imageUrl: avatar.imageUrl,
                backgroundColor: avatar.backgroundColor,
                size: size,
                borderColor: Colors.white,
                borderWidth: 2.0,
                onTap: avatar.onTap,
              ),
            );
          }),

          // Show count if there are more avatars
          if (remainingCount > 0 && showCount)
            Positioned(
              left: visibleAvatars.length * overlapOffset,
              child: CircleAvatar(
                radius: avatarSize / 2,
                backgroundColor: Colors.grey[300],
                child: Text(
                  '+$remainingCount',
                  style: KFonts.bodySmall.copyWith(
                    color: Colors.grey[700],
                    fontWeight: KFonts.medium,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Data model for avatar information
class KAvatarData {
  const KAvatarData({
    required this.initials,
    this.imageUrl,
    this.backgroundColor,
    this.onTap,
  });

  final String initials;
  final String? imageUrl;
  final Color? backgroundColor;
  final VoidCallback? onTap;
}
