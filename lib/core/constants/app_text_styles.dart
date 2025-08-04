import 'package:flutter/material.dart';

/// App text styles following Material Design 3 typography
class AppTextStyles {
  AppTextStyles._();

  // Base font family
  static const String fontFamily = 'Poppins';

  // Display Styles (Large titles)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  // Headline Styles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // Title Styles
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  // Label Styles
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // Button Styles
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  // Special Styles
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.3,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.6,
  );
}
