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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: KFonts.labelMedium.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: KSize.xxs),
        ],
        Container(
          height: KSize.buttonHeightDefault,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6.75),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            enabled: enabled,
            validator: validator,
            style: KFonts.bodyMedium.copyWith(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              hintText: hintText,
              hintStyle: KFonts.bodySmall.copyWith(
                color: Colors.white.withOpacity(0.5),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: KSize.xs,
                vertical: KSize.sm,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
