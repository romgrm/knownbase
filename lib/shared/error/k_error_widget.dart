import 'package:flutter/material.dart';
import '../../core/constants/k_sizes.dart';
import '../../core/constants/k_fonts.dart';

/// Generic error widget used throughout the application
class KErrorWidget extends StatelessWidget {
  const KErrorWidget({
    super.key,
    this.title = 'Something went wrong',
    this.description = 'An unexpected error occurred. Please try again.',
    this.onRetry,
    this.retryButtonText = 'Retry',
    this.showLogo = true,
    this.icon,
    this.iconColor,
    this.iconSize = KSize.iconSizeLarge,
  });

  final String title;
  final String description;
  final VoidCallback? onRetry;
  final String retryButtonText;
  final bool showLogo;
  final IconData? icon;
  final Color? iconColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(KSize.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLogo) ...[
              Container(
                width: iconSize * 2,
                height: iconSize * 2,
                decoration: BoxDecoration(
                  color: (iconColor ?? Colors.red).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(KSize.radiusLarge),
                ),
                child: Icon(
                  icon ?? Icons.error_outline,
                  size: iconSize,
                  color: iconColor ?? Colors.red,
                ),
              ),
              const SizedBox(height: KSize.lg),
            ],
            
            Text(
              title,
              style: KFonts.titleLarge.copyWith(
                color: Colors.black87,
                fontWeight: KFonts.semiBold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: KSize.sm),
            
            Text(
              description,
              style: KFonts.bodyMedium.copyWith(
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (onRetry != null) ...[
              const SizedBox(height: KSize.lg),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: KSize.lg,
                    vertical: KSize.sm,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(KSize.radiusDefault),
                  ),
                ),
                child: Text(
                  retryButtonText,
                  style: KFonts.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: KFonts.medium,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Specific error widget for network/API failures
class KNetworkErrorWidget extends StatelessWidget {
  const KNetworkErrorWidget({
    super.key,
    this.onRetry,
    this.retryButtonText = 'Try Again',
  });

  final VoidCallback? onRetry;
  final String retryButtonText;

  @override
  Widget build(BuildContext context) {
    return KErrorWidget(
      title: 'Connection Error',
      description: 'Unable to connect to our servers.\nPlease check your internet connection and try again.',
      icon: Icons.wifi_off,
      iconColor: Colors.orange,
      onRetry: onRetry,
      retryButtonText: retryButtonText,
    );
  }
}

/// Specific error widget for empty states
class KEmptyStateWidget extends StatelessWidget {
  const KEmptyStateWidget({
    super.key,
    required this.title,
    required this.description,
    this.actionText,
    this.onAction,
    this.icon = Icons.inbox,
  });

  final String title;
  final String description;
  final String? actionText;
  final VoidCallback? onAction;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return KErrorWidget(
      title: title,
      description: description,
      icon: icon,
      iconColor: Colors.grey[400],
      onRetry: onAction,
      retryButtonText: actionText ?? 'Get Started',
    );
  }
}