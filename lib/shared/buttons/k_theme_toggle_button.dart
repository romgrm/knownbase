import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/k_sizes.dart';
import '../../core/theme/theme_provider.dart';

/// Theme toggle button that switches between light and dark modes
class KThemeToggleButton extends StatelessWidget {
  const KThemeToggleButton({
    super.key,
    this.size = KSize.iconSizeDefault,
    this.padding = const EdgeInsets.all(KSize.xxs),
  });

  final double size;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDarkMode = themeMode == ThemeMode.dark;

        return InkWell(
          onTap: () => context.read<ThemeCubit>().toggleTheme(),
          borderRadius: BorderRadius.circular(KSize.radiusDefault),
          child: Padding(
            padding: padding,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  key: ValueKey(isDarkMode), size: size),
            ),
          ),
        );
      },
    );
  }
}

/// Compact theme toggle button for use in app bars
class KCompactThemeToggleButton extends StatelessWidget {
  const KCompactThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDarkMode = themeMode == ThemeMode.dark;

        return InkWell(
          onTap: () => context.read<ThemeCubit>().toggleTheme(),
          borderRadius: BorderRadius.circular(6.75),
          child: Padding(
            padding: const EdgeInsets.all(KSize.xxs - 2),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                  isDarkMode
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                  size: KSize.iconSizeDefault - KSize.xxs),
            ),
          ),
        );
      },
    );
  }
}
