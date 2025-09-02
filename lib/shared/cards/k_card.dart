import 'package:flutter/material.dart';
import '../../core/constants/k_sizes.dart';

class KCard extends StatelessWidget {
  const KCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(KSize.md),
    this.margin,
    this.elevation = 0,
    this.shadowColor,
    this.borderRadius = KSize.radiusDefault,
    this.backgroundColor,
    this.border,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double elevation;
  final Color? shadowColor;
  final double borderRadius;
  final Color? backgroundColor;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: shadowColor ?? theme.shadowColor.withOpacity(0.1),
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}