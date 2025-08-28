import 'package:flutter/material.dart';

/// Font constants for the app
class KFonts {
  const KFonts._();

  // Font Family
  static const String fontFamily = 'Urbanist';

  // Font Weights
  static const FontWeight regular = FontWeight.w400;    // Urbanist-Regular.ttf
  static const FontWeight medium = FontWeight.w500;     // Urbanist-Medium.ttf
  static const FontWeight semiBold = FontWeight.w600;   // Urbanist-SemiBold.ttf
  static const FontWeight bold = FontWeight.w700;       // Urbanist-Bold.ttf

  // Font Sizes
  static const double xs = 12.0;
  static const double sm = 14.0;
  static const double md = 16.0;
  static const double lg = 18.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  // Text Styles
  static TextStyle get displayLarge => const TextStyle(
    fontFamily: fontFamily,
    fontSize: xxxl,
    fontWeight: bold,
  );

  static TextStyle get displayMedium => const TextStyle(
    fontFamily: fontFamily,
    fontSize: xxl,
    fontWeight: bold,
  );

  static TextStyle get headlineLarge => const TextStyle(
    fontFamily: fontFamily,
    fontSize: xxxl,
    fontWeight: bold,
  );

  static TextStyle get headlineMedium => const TextStyle(
    fontFamily: fontFamily,
    fontSize: xxl,
    fontWeight: semiBold,
  );

  static TextStyle get headlineSmall => const TextStyle(
    fontFamily: fontFamily,
    fontSize: xl,
    fontWeight: semiBold,
  );

  static TextStyle get titleLarge => const TextStyle(
    fontFamily: fontFamily,
    fontSize: xl,
    fontWeight: semiBold,
  );

  static TextStyle get titleMedium => const TextStyle(
    fontFamily: fontFamily,
    fontSize: lg,
    fontWeight: medium,
  );

  static TextStyle get titleSmall => const TextStyle(
    fontFamily: fontFamily,
    fontSize: md,
    fontWeight: medium,
  );

  static TextStyle get bodyLarge => const TextStyle(
    fontFamily: fontFamily,
    fontSize: md,
    fontWeight: medium,
  );

  static TextStyle get bodyMedium => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sm,
    fontWeight: regular,
  );

  static TextStyle get bodySmall => const TextStyle(
    fontFamily: fontFamily,
    fontSize: xs,
    fontWeight: regular,
  );

  static TextStyle get labelLarge => const TextStyle(
    fontFamily: fontFamily,
    fontSize: md,
    fontWeight: semiBold,
  );

  static TextStyle get labelMedium => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sm,
    fontWeight: medium,
  );

  static TextStyle get labelSmall => const TextStyle(
    fontFamily: fontFamily,
    fontSize: xs,
    fontWeight: medium,
  );

  // Button Text Styles
  static TextStyle get buttonLarge => const TextStyle(
    fontFamily: fontFamily,
    fontSize: md,
    fontWeight: semiBold,
  );

  static TextStyle get buttonMedium => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sm,
    fontWeight: medium,
  );

  static TextStyle get buttonSmall => const TextStyle(
    fontFamily: fontFamily,
    fontSize: xs,
    fontWeight: medium,
  );
}
