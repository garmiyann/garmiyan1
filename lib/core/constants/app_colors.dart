import 'package:flutter/material.dart';

/// App color constants following Material Design 3 principles
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF7D00B8);
  static const Color primaryVariant = Color(0xFFB700FF);
  static const Color secondary = Color(0xFF00BFFF);
  static const Color secondaryVariant = Color(0xFF0080FF);

  // Surface Colors
  static const Color surface = Color(0xFF121212);
  static const Color surfaceVariant = Color(0xFF2A2A2A);
  static const Color background = Color(0xFF000000);
  static const Color card = Color(0xFF1E1E1E);
  static const Color outline = Color(0xFF3D3D3D);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textTertiary = Color(0xFF8A8A8A);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFf44336);
  static const Color info = Color(0xFF2196F3);

  // Action Colors
  static const Color accent = Color(0xFFFF8C00);
  static const Color highlight = Color(0xFFE91E63);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [primary, background],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Opacity Colors
  static Color get surfaceOpacity => textPrimary.withOpacity(0.1);
  static Color get cardOpacity => textPrimary.withOpacity(0.05);
  static Color get borderOpacity => textPrimary.withOpacity(0.2);
}
