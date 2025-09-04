import 'package:flutter/material.dart';
import '../constants/k_fonts.dart';

/// App theme configuration with light and dark themes
class AppTheme {
  // Light theme colors
  static const Color lightPrimaryColor = Color(0xFFFFFFFF);
  static const Color lightSecondaryColor = Color(0xFFA199FA);

  // Dark theme colors
  static const Color darkPrimaryColor = Color(0xFF101828);
  static const Color darkSecondaryColor = Color(0xFFA199FA);
  static const Color darkSurfaceColor = Color(0xFF1E293B);
  static const Color darkCardColor = Color(0xFF334155);

  // Common colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
  static const Color red = Color(0xFFFFE2E2);
  static const Color purple = Color(0xFFAAA3FA);
  static const Color green = Color(0xFF619084);
  static const Color gray = Color(0xFFF9FAFB);

  /// Light theme
  static ThemeData get lightTheme {
    return ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: KFonts.fontFamily,
        colorScheme: const ColorScheme.light(
          primary: lightPrimaryColor,
          secondary: lightSecondaryColor,
          tertiary: darkPrimaryColor,
          surface: lightPrimaryColor,
          onPrimary: darkPrimaryColor,
          onSecondary: lightPrimaryColor,
          onTertiary: lightPrimaryColor,
          onSurface: Colors.grey,
          primaryContainer: gray,
          error: red,
          onError: black,
        ),
        scaffoldBackgroundColor: lightPrimaryColor,
        cardTheme: CardTheme(
          color: lightSecondaryColor,
          elevation: 8,
          shadowColor: black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: lightPrimaryColor.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: lightPrimaryColor.withOpacity(0.1), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: lightPrimaryColor.withOpacity(0.1), width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: red.withOpacity(0.5), width: 2),
          ),
          labelStyle: const TextStyle(color: white),
          hintStyle: TextStyle(color: white.withOpacity(0.7)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: white,
              foregroundColor: darkSecondaryColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: gray, width: 2),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              textStyle: const TextStyle(
                fontFamily: KFonts.fontFamily,
                fontSize: KFonts.sm,
                fontWeight: KFonts.semiBold,
              )),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: darkPrimaryColor,
            foregroundColor: lightPrimaryColor,
          ),
        ),
        textTheme: TextTheme(
          displayLarge: KFonts.displayLarge.copyWith(color: darkPrimaryColor),
          displayMedium: KFonts.displayMedium.copyWith(color: darkPrimaryColor),
          headlineLarge: KFonts.headlineLarge.copyWith(color: darkPrimaryColor),
          headlineMedium:
              KFonts.headlineMedium.copyWith(color: darkPrimaryColor),
          headlineSmall: KFonts.headlineSmall.copyWith(color: darkPrimaryColor),
          titleLarge: KFonts.titleLarge.copyWith(color: darkPrimaryColor),
          titleMedium: KFonts.titleMedium.copyWith(color: darkPrimaryColor),
          titleSmall: KFonts.titleSmall.copyWith(color: darkPrimaryColor),
          bodyLarge: KFonts.bodyLarge.copyWith(color: darkPrimaryColor),
          bodyMedium: KFonts.bodyMedium.copyWith(color: darkPrimaryColor),
          bodySmall: KFonts.bodySmall.copyWith(color: darkPrimaryColor),
          labelLarge: KFonts.labelLarge.copyWith(color: darkPrimaryColor),
          labelMedium: KFonts.labelMedium.copyWith(color: darkPrimaryColor),
          labelSmall: KFonts.labelSmall.copyWith(color: darkPrimaryColor),
        ),
        iconTheme: const IconThemeData(
          color: darkPrimaryColor,
        ),
        dividerTheme: const DividerThemeData(color: gray, thickness: 2));
  }

  /// Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: KFonts.fontFamily,
        colorScheme: const ColorScheme.dark(
          primary: darkPrimaryColor,
          secondary: darkSecondaryColor,
          tertiary: lightPrimaryColor,
          surface: darkSurfaceColor,
          onPrimary: lightPrimaryColor,
          onSecondary: lightPrimaryColor,
          onTertiary: lightPrimaryColor,
          onSurface: Colors.grey,
          error: red,
          onError: black,
        ),
        scaffoldBackgroundColor: darkPrimaryColor,
        cardTheme: CardTheme(
          color: darkCardColor,
          elevation: 8,
          shadowColor: black.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: darkSecondaryColor.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: white, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: white, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: white, width: 2),
          ),
          labelStyle: const TextStyle(color: white),
          hintStyle: TextStyle(color: white.withOpacity(0.7)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: white,
            foregroundColor: darkSecondaryColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: lightPrimaryColor,
            foregroundColor: darkPrimaryColor,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: purple,
            textStyle: const TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        textTheme: TextTheme(
          displayLarge: KFonts.displayLarge.copyWith(color: lightPrimaryColor),
          displayMedium:
              KFonts.displayMedium.copyWith(color: lightPrimaryColor),
          headlineLarge:
              KFonts.headlineLarge.copyWith(color: lightPrimaryColor),
          headlineMedium:
              KFonts.headlineMedium.copyWith(color: lightPrimaryColor),
          headlineSmall:
              KFonts.headlineSmall.copyWith(color: lightPrimaryColor),
          titleLarge: KFonts.titleLarge.copyWith(color: lightPrimaryColor),
          titleMedium: KFonts.titleMedium.copyWith(color: lightPrimaryColor),
          titleSmall: KFonts.titleSmall.copyWith(color: lightPrimaryColor),
          bodyLarge: KFonts.bodyLarge.copyWith(color: lightPrimaryColor),
          bodyMedium: KFonts.bodyMedium.copyWith(color: lightPrimaryColor),
          bodySmall: KFonts.bodySmall.copyWith(color: lightPrimaryColor),
          labelLarge: KFonts.labelLarge.copyWith(color: lightPrimaryColor),
          labelMedium: KFonts.labelMedium.copyWith(color: lightPrimaryColor),
          labelSmall: KFonts.labelSmall.copyWith(color: lightPrimaryColor),
        ),
        iconTheme: const IconThemeData(
          color: lightPrimaryColor,
        ),
        dividerTheme:
            const DividerThemeData(color: darkCardColor, thickness: 1));
  }
}

extension AppTextThemeExtension on TextTheme {
  TextStyle? get heading => headlineLarge;
  TextStyle? get subheading => headlineSmall;
  TextStyle? get text => bodyMedium;
  TextStyle? get description => bodySmall;
  TextStyle? get button => labelLarge;
  TextStyle? get caption => labelMedium;
}

/// SugarSyntax to get access quickly to [ThemeData],[TextTheme] and [FlexAppColorScheme] from context
extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Size get deviceSize => MediaQuery.sizeOf(this);
  double get screenWidth => deviceSize.width;
  double get screenHeight => deviceSize.height;
  EdgeInsets get padding => MediaQuery.paddingOf(this);
  bool get isDarkMode =>
      MediaQuery.platformBrightnessOf(this) == Brightness.dark;
  bool get isKeyboardVisible => MediaQuery.viewInsetsOf(this).bottom > 0;
}
