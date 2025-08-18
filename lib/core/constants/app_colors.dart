import 'package:flutter/material.dart';

/// App color constants following Material Design 3 principles
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF7D00B8);
  static const Color primaryVariant = Color(0xFFB700FF);
  static const Color secondary = Color(0xFF00BFFF);
  static const Color secondaryVariant = Color(0xFF0080FF);

  // Dark Theme Colors
  static const Color darkSurface = Color(0xFF121212);
  static const Color darkSurfaceVariant = Color(0xFF2A2A2A);
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkOutline = Color(0xFF3D3D3D);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkTextTertiary = Color(0xFF8A8A8A);

  // Light Theme Colors
  static const Color lightSurface = Color(0xFFFFFBFF);
  static const Color lightSurfaceVariant = Color(0xFFF5F0F7);
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFCF8FC);
  static const Color lightOutline = Color(0xFFE0E0E0);
  static const Color lightTextPrimary = Color(0xFF1C1B1F);
  static const Color lightTextSecondary = Color(0xFF49454F);
  static const Color lightTextTertiary = Color(0xFF79747E);

  // Dynamic colors based on theme
  static Color surface = darkSurface;
  static Color surfaceVariant = darkSurfaceVariant;
  static Color background = darkBackground;
  static Color card = darkCard;
  static Color outline = darkOutline;
  static Color textPrimary = darkTextPrimary;
  static Color textSecondary = darkTextSecondary;
  static Color textTertiary = darkTextTertiary;

  // Status Colors (same for both themes)
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFf44336);
  static const Color info = Color(0xFF2196F3);

  // Action Colors
  static const Color accent = Color(0xFFFF8C00);
  static const Color highlight = Color(0xFFE91E63);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFFFFFFFF);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get backgroundGradient => LinearGradient(
        colors: [primary, background],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // Opacity Colors
  static Color get surfaceOpacity => textPrimary.withOpacity(0.1);
  static Color get cardOpacity => textPrimary.withOpacity(0.05);
  static Color get borderOpacity => textPrimary.withOpacity(0.2);

  /// Update colors for light theme
  static void setLightTheme() {
    surface = lightSurface;
    surfaceVariant = lightSurfaceVariant;
    background = lightBackground;
    card = lightCard;
    outline = lightOutline;
    textPrimary = lightTextPrimary;
    textSecondary = lightTextSecondary;
    textTertiary = lightTextTertiary;
  }

  /// Update colors for dark theme
  static void setDarkTheme() {
    surface = darkSurface;
    surfaceVariant = darkSurfaceVariant;
    background = darkBackground;
    card = darkCard;
    outline = darkOutline;
    textPrimary = darkTextPrimary;
    textSecondary = darkTextSecondary;
    textTertiary = darkTextTertiary;
  }
}
