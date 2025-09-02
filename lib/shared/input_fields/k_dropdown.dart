import 'package:flutter/material.dart';
import '../../core/constants/k_sizes.dart';
import '../../core/constants/k_fonts.dart';

class KDropdown<T> extends StatelessWidget {
  const KDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.hint,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: KFonts.labelMedium.copyWith(
              color: theme.textTheme.labelLarge?.color,
            ),
          ),
          const SizedBox(height: KSize.xxs),
        ],
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(KSize.radiusDefault),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: DropdownButtonFormField<T>(
            value: value,
            items: items,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: KFonts.bodyMedium.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
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
            style: KFonts.bodyMedium.copyWith(
              color: theme.textTheme.bodyMedium?.color,
            ),
            dropdownColor: theme.colorScheme.surface,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}