import 'package:flutter/material.dart';
import '../../core/constants/k_sizes.dart';

/// Generic loader widget used throughout the application
class KLoader extends StatelessWidget {
  const KLoader({
    super.key,
    this.size = KSize.iconSizeDefault,
    this.color,
    this.strokeWidth = 3.0,
    this.message,
  });

  final double size;
  final Color? color;
  final double strokeWidth;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final loaderColor = color ?? Theme.of(context).primaryColor;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: KSize.sm),
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Centered loader for full screen loading states
class KCenteredLoader extends StatelessWidget {
  const KCenteredLoader({
    super.key,
    this.size = KSize.iconSizeDefault,
    this.color,
    this.strokeWidth = 3.0,
    this.message,
  });

  final double size;
  final Color? color;
  final double strokeWidth;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: KLoader(
        size: size,
        color: color,
        strokeWidth: strokeWidth,
        message: message,
      ),
    );
  }
}