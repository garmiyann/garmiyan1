import 'package:shared_preferences/shared_preferences.dart';

/// Service for handling local storage operations
/// Uses SharedPreferences for persistent storage
class LocalStorageService {
  static const String _rememberMeKey = 'remember_me';
  static const String _rememberedEmailKey = 'remembered_email';
  static const String _rememberedPasswordKey = 'remembered_password';
  static const String _themeModeKey = 'theme_mode';

  static LocalStorageService? _instance;
  static SharedPreferences? _preferences;

  LocalStorageService._();

  /// Singleton instance
  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  /// Save remember me preference
  Future<bool> setRememberMe(bool remember) async {
    return await _preferences!.setBool(_rememberMeKey, remember);
  }

  /// Get remember me preference
  bool getRememberMe() {
    return _preferences!.getBool(_rememberMeKey) ?? false;
  }

  /// Save remembered email
  Future<bool> setRememberedEmail(String email) async {
    return await _preferences!.setString(_rememberedEmailKey, email);
  }

  /// Get remembered email
  String getRememberedEmail() {
    return _preferences!.getString(_rememberedEmailKey) ?? '';
  }

  /// Save remembered password
  Future<bool> setRememberedPassword(String password) async {
    return await _preferences!.setString(_rememberedPasswordKey, password);
  }

  /// Get remembered password
  String getRememberedPassword() {
    return _preferences!.getString(_rememberedPasswordKey) ?? '';
  }

  /// Save login credentials
  Future<bool> saveCredentials({
    required String email,
    required String password,
    required bool remember,
  }) async {
    if (remember) {
      final results = await Future.wait([
        setRememberMe(true),
        setRememberedEmail(email),
        setRememberedPassword(password),
      ]);
      return results.every((result) => result == true);
    } else {
      return await clearCredentials();
    }
  }

  /// Get saved credentials
  Map<String, dynamic> getCredentials() {
    return {
      'remember': getRememberMe(),
      'email': getRememberedEmail(),
      'password': getRememberedPassword(),
    };
  }

  /// Clear saved credentials
  Future<bool> clearCredentials() async {
    final results = await Future.wait([
      _preferences!.setBool(_rememberMeKey, false),
      _preferences!.remove(_rememberedEmailKey),
      _preferences!.remove(_rememberedPasswordKey),
    ]);
    return results.every((result) => result == true);
  }

  /// Clear all stored data
  Future<bool> clearAll() async {
    return await _preferences!.clear();
  }

  /// Save theme mode preference
  Future<bool> setThemeMode(String themeMode) async {
    return await _preferences!.setString(_themeModeKey, themeMode);
  }

  /// Get theme mode preference
  String getThemeMode() {
    return _preferences!.getString(_themeModeKey) ?? 'dark';
  }
}
