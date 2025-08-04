import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_dimensions.dart';

/// App theme configuration following Material Design 3
class AppTheme {
  AppTheme._();

  /// Dark theme configuration
  static ThemeData get darkTheme {
    // Set dark theme colors
    AppColors.setDarkTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppTextStyles.fontFamily,

      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
        onPrimary: AppColors.onPrimary,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
        onError: AppColors.textPrimary,
        outline: AppColors.outline,
        surfaceVariant: AppColors.surfaceVariant,
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: AppDimensions.appBarElevation,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headlineMedium,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.darkBackground,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: AppDimensions.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          minimumSize:
              const Size(double.infinity, AppDimensions.buttonHeightMedium),
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          minimumSize:
              const Size(double.infinity, AppDimensions.buttonHeightMedium),
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceOpacity,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
          vertical: AppDimensions.paddingMedium,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        labelStyle: AppTextStyles.labelMedium,
        errorStyle: AppTextStyles.caption.copyWith(
          color: AppColors.error,
        ),
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColors.textPrimary,
        size: AppDimensions.iconMedium,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        titleTextStyle: AppTextStyles.headlineSmall,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return Colors.transparent;
          },
        ),
        checkColor: WidgetStateProperty.all(AppColors.textPrimary),
        side: BorderSide(
          color: AppColors.textSecondary,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall / 2),
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.textPrimary.withOpacity(0.2),
        thickness: AppDimensions.dividerThickness,
        indent: AppDimensions.dividerIndent,
        endIndent: AppDimensions.dividerIndent,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),

      // Scaffold Background Color
      scaffoldBackgroundColor: AppColors.background,
    );
  }

  /// Light theme configuration
  static ThemeData get lightTheme {
    // Set light theme colors
    AppColors.setLightTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppTextStyles.fontFamily,

      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
        onPrimary: AppColors.onPrimary,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
        onError: Colors.white,
        outline: AppColors.outline,
        surfaceVariant: AppColors.surfaceVariant,
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: AppDimensions.appBarElevation,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.lightBackground,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: AppDimensions.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          minimumSize:
              const Size(double.infinity, AppDimensions.buttonHeightMedium),
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          minimumSize:
              const Size(double.infinity, AppDimensions.buttonHeightMedium),
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceOpacity,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
          vertical: AppDimensions.paddingMedium,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        errorStyle: AppTextStyles.caption.copyWith(
          color: AppColors.error,
        ),
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColors.textPrimary,
        size: AppDimensions.iconMedium,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textPrimary,
        ),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return Colors.transparent;
          },
        ),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: BorderSide(
          color: AppColors.textSecondary,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall / 2),
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.textPrimary.withOpacity(0.2),
        thickness: AppDimensions.dividerThickness,
        indent: AppDimensions.dividerIndent,
        endIndent: AppDimensions.dividerIndent,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge:
            AppTextStyles.displayLarge.copyWith(color: AppColors.textPrimary),
        displayMedium:
            AppTextStyles.displayMedium.copyWith(color: AppColors.textPrimary),
        displaySmall:
            AppTextStyles.displaySmall.copyWith(color: AppColors.textPrimary),
        headlineLarge:
            AppTextStyles.headlineLarge.copyWith(color: AppColors.textPrimary),
        headlineMedium:
            AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimary),
        headlineSmall:
            AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
        titleLarge:
            AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimary),
        titleMedium:
            AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary),
        titleSmall:
            AppTextStyles.titleSmall.copyWith(color: AppColors.textPrimary),
        bodyLarge:
            AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
        bodyMedium:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
        bodySmall:
            AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
        labelLarge:
            AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimary),
        labelMedium:
            AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary),
        labelSmall:
            AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary),
      ),

      // Scaffold Background Color
      scaffoldBackgroundColor: AppColors.background,
    );
  }
}
