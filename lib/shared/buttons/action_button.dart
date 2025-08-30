import 'package:flutter/material.dart';
import 'package:knownbase/core/constants/k_sizes.dart';
import 'package:knownbase/core/constants/k_fonts.dart';
import 'package:knownbase/core/theme/theme_provider.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isTransparent;
  final bool isLoading;
  final double? width;
  final double height;

  const ActionButton({
    super.key, 
    required this.label, 
    required this.onPressed, 
    this.icon, 
    this.isTransparent = false,
    this.isLoading = false,
    this.width,
    this.height = KSize.xxxl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: isTransparent 
            ? Colors.transparent 
            : context.colorScheme.secondary,
        borderRadius: BorderRadius.circular(KSize.radiusDefault),
        border: Border.all(
          color: context.colorScheme.onPrimary.withOpacity(0.1),
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(KSize.radiusDefault),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: KSize.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: KSize.md,
                    height: KSize.md,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else ...[
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: KSize.sm),
                  ],
                ],
                Text(
                  label,
                  style: KFonts.buttonLarge.copyWith(
                    color: Colors.white,
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