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

  // Common colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
  static const Color red = Color(0xFFFFE2E2);
  static const Color purple = Color(0xFFAAA3FA);
  static const Color green = Color(0xFF619084);

  /// Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: KFonts.fontFamily,
      colorScheme: const ColorScheme.light(
        primary: lightPrimaryColor,
        secondary: lightSecondaryColor,
        surface: lightPrimaryColor,
        onPrimary: white,
        onSecondary: purple,
        onSurface: black,
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
          borderSide:  BorderSide(color: lightPrimaryColor.withOpacity(0.1), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:  BorderSide(color: lightPrimaryColor.withOpacity(0.1), width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:  BorderSide(color: red.withOpacity(0.5), width: 2),
        ),
        labelStyle: const TextStyle(color: white),
        hintStyle: TextStyle(color: white.withOpacity(0.7)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: white,
          foregroundColor: lightSecondaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
        displayMedium: KFonts.displayMedium.copyWith(color: lightPrimaryColor),
        headlineLarge: KFonts.headlineLarge.copyWith(color: lightPrimaryColor),
        headlineMedium: KFonts.headlineMedium.copyWith(color: lightPrimaryColor),
        headlineSmall: KFonts.headlineSmall.copyWith(color: lightPrimaryColor),
        titleLarge: KFonts.titleLarge.copyWith(color: lightPrimaryColor),
        titleMedium: KFonts.titleMedium.copyWith(color: lightPrimaryColor),
        titleSmall: KFonts.titleSmall.copyWith(color: lightPrimaryColor),
        bodyLarge: KFonts.bodyLarge.copyWith(color: lightPrimaryColor),
        bodyMedium: KFonts.bodyMedium.copyWith(color: lightPrimaryColor),
        bodySmall: KFonts.bodySmall.copyWith(color: lightPrimaryColor),
        labelLarge: KFonts.labelLarge.copyWith(color: lightSecondaryColor),
        labelMedium: KFonts.labelMedium.copyWith(color: lightSecondaryColor),
        labelSmall: KFonts.labelSmall.copyWith(color: lightSecondaryColor),
      ),
    );
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
        surface: darkPrimaryColor,
        onPrimary: white,
        onSecondary: white,
        onSurface: white,
        error: red,
        onError: black,
      ),
      scaffoldBackgroundColor: darkPrimaryColor,
      cardTheme: CardTheme(
        color: darkSecondaryColor,
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
        displayLarge: KFonts.displayLarge.copyWith(color: white),
        displayMedium: KFonts.displayMedium.copyWith(color: white),
        headlineLarge: KFonts.headlineLarge.copyWith(color: white),
        headlineMedium: KFonts.headlineMedium.copyWith(color: white),
        headlineSmall: KFonts.headlineSmall.copyWith(color: white),
        titleLarge: KFonts.titleLarge.copyWith(color: white),
        titleMedium: KFonts.titleMedium.copyWith(color: white),
        titleSmall: KFonts.titleSmall.copyWith(color: white),
        bodyLarge: KFonts.bodyLarge.copyWith(color: white),
        bodyMedium: KFonts.bodyMedium.copyWith(color: white),
        bodySmall: KFonts.bodySmall.copyWith(color: white),
        labelLarge: KFonts.labelLarge.copyWith(color: darkSecondaryColor),
        labelMedium: KFonts.labelMedium.copyWith(color: white),
        labelSmall: KFonts.labelSmall.copyWith(color: white),
      ),
    );
  }
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