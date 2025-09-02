import 'package:flutter/material.dart';
import '../../core/constants/k_sizes.dart';
import '../../core/constants/k_fonts.dart';

enum KButtonVariant { primary, secondary, text }

class KButton extends StatelessWidget {
  const KButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = KButtonVariant.primary,
    this.isLoading = false,
    this.width,
    this.height = KSize.buttonHeightDefault,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final KButtonVariant variant;
  final bool isLoading;
  final double? width;
  final double height;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Color getBackgroundColor() {
      switch (variant) {
        case KButtonVariant.primary:
          return theme.colorScheme.primary;
        case KButtonVariant.secondary:
          return theme.colorScheme.surface;
        case KButtonVariant.text:
          return Colors.transparent;
      }
    }

    Color getTextColor() {
      switch (variant) {
        case KButtonVariant.primary:
          return theme.colorScheme.onPrimary;
        case KButtonVariant.secondary:
          return theme.colorScheme.onSurface;
        case KButtonVariant.text:
          return theme.colorScheme.onSurface.withOpacity(0.7);
      }
    }

    BorderSide? getBorder() {
      switch (variant) {
        case KButtonVariant.primary:
          return null;
        case KButtonVariant.secondary:
          return BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          );
        case KButtonVariant.text:
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
          elevation: variant == KButtonVariant.primary ? 2 : 0,
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