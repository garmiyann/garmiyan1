import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

/// Service for managing app theme mode (light/dark)
class ThemeService extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.dark;
  late LocalStorageService _storageService;

  ThemeService._();

  static ThemeService? _instance;

  /// Singleton instance
  static Future<ThemeService> getInstance() async {
    _instance ??= ThemeService._();
    await _instance!._initialize();
    return _instance!;
  }

  /// Current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Check if current theme is dark
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Check if current theme is light
  bool get isLightMode => _themeMode == ThemeMode.light;

  /// Check if current theme is system
  bool get isSystemMode => _themeMode == ThemeMode.system;

  /// Initialize theme service
  Future<void> _initialize() async {
    _storageService = await LocalStorageService.getInstance();
    await _loadThemeMode();
  }

  /// Load saved theme mode
  Future<void> _loadThemeMode() async {
    final savedMode = _storageService.getThemeMode();
    _themeMode = _themeModeFromString(savedMode);
    notifyListeners();
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      await _storageService.setThemeMode(_themeModeToString(mode));
      notifyListeners();
    }
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final newMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }

  /// Set to light mode
  Future<void> setLightMode() async {
    await setThemeMode(ThemeMode.light);
  }

  /// Set to dark mode
  Future<void> setDarkMode() async {
    await setThemeMode(ThemeMode.dark);
  }

  /// Set to system mode
  Future<void> setSystemMode() async {
    await setThemeMode(ThemeMode.system);
  }

  /// Convert ThemeMode to string
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Convert string to ThemeMode
  ThemeMode _themeModeFromString(String mode) {
    switch (mode.toLowerCase()) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.dark; // Default to dark mode
    }
  }
}
