import 'package:flutter/material.dart';
import 'package:knownbase/core/theme/app_theme.dart';
import '../../core/constants/k_sizes.dart';
import '../../core/constants/k_fonts.dart';

enum KElevatedButtonVariant { primary, secondary, tertiary }

class KElevatedButton extends StatelessWidget {
  const KElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = KElevatedButtonVariant.primary,
    this.isLoading = false,
    this.width,
    this.height = KSize.buttonHeightDefault,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final KElevatedButtonVariant variant;
  final bool isLoading;
  final double? width;
  final double height;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color getBackgroundColor() {
      switch (variant) {
        case KElevatedButtonVariant.primary:
          return context.colorScheme.primary;
        case KElevatedButtonVariant.secondary:
          return context.colorScheme.secondary;
        case KElevatedButtonVariant.tertiary:
          return context.colorScheme.tertiary;
      }
    }

    Color getTextColor() {
      switch (variant) {
        case KElevatedButtonVariant.primary:
          return context.colorScheme.tertiary;
        case KElevatedButtonVariant.secondary:
          return context.colorScheme.secondary;
        case KElevatedButtonVariant.tertiary:
          return context.colorScheme.tertiary;
      }
    }

    BorderSide? getBorder() {
      switch (variant) {
        case KElevatedButtonVariant.primary:
          return null;
        case KElevatedButtonVariant.secondary:
          return BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          );
        case KElevatedButtonVariant.tertiary:
          return null;
      }
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: getBackgroundColor(),
          foregroundColor: getTextColor(),
          elevation: variant == KElevatedButtonVariant.primary ? 2 : 0,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KSize.radiusDefault),
            side: getBorder() ?? BorderSide.none,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: KSize.md,
                height: KSize.md,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(getTextColor()),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: KSize.md),
                    const SizedBox(width: KSize.xxs),
                  ],
                  Text(
                    text,
                    style: KFonts.buttonMedium.copyWith(
                      color: getTextColor(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
