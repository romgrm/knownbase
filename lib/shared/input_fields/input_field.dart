import 'package:flutter/material.dart';
import '../../core/constants/k_sizes.dart';
import '../../core/constants/k_fonts.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType; 
  final String hintText;
  final bool enabled;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final String? label;
  final int maxLines;

  const InputField({
    super.key, 
    required this.controller, 
    this.keyboardType, 
    required this.hintText, 
    this.enabled = true, 
    this.validator, 
    this.prefixIcon, 
    this.obscureText = false, 
    this.suffixIcon,
    this.label,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: KFonts.labelMedium.copyWith(
              color: isDark ? Colors.white : theme.textTheme.labelLarge?.color,
            ),
          ),
          const SizedBox(height: KSize.xxs),
        ],
        Container(
          constraints: maxLines > 1 
              ? BoxConstraints(minHeight: KSize.buttonHeightDefault * maxLines * 0.6)
              : const BoxConstraints(minHeight: KSize.buttonHeightDefault),
          decoration: BoxDecoration(
            color: isDark 
                ? Colors.white.withOpacity(0.05)
                : const Color(0xFFF5F5F7),
            borderRadius: BorderRadius.circular(KSize.radiusDefault),
            border: Border.all(
              color: isDark 
                  ? Colors.white.withOpacity(0.1)
                  : const Color(0xFFE5E5E7),
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            enabled: enabled,
            validator: validator,
            maxLines: maxLines,
            style: KFonts.bodyMedium.copyWith(
              color: isDark ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              hintText: hintText,
              hintStyle: KFonts.bodyMedium.copyWith(
                color: isDark 
                    ? Colors.white.withOpacity(0.5)
                    : Colors.black54,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: KSize.sm,
                vertical: KSize.sm,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
