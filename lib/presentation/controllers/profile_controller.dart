import 'base_controller.dart';

/// Profile Controller
///
/// Manages user profile data, settings, and preferences.
class ProfileController extends BaseController {
  // Profile data
  UserProfile? _userProfile;
  List<ProfileSetting> _settings = [];
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'en';

  // Getters
  UserProfile? get userProfile => _userProfile;
  List<ProfileSetting> get settings => _settings;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get darkModeEnabled => _darkModeEnabled;
  String get selectedLanguage => _selectedLanguage;

  /// Initialize profile data
  void init() {
    loadProfileData();
  }

  /// Load user profile data
  Future<void> loadProfileData() async {
    await executeWithLoading(() async {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _userProfile = UserProfile(
        id: '1',
        name: 'John Doe',
        email: 'john.doe@example.com',
        phone: '+1234567890',
        avatarUrl: null,
        joinDate: DateTime.now().subtract(const Duration(days: 365)),
        isVerified: true,
        role: 'Premium User',
      );

      _settings = [
        ProfileSetting(
          id: 'notifications',
          title: 'Push Notifications',
          description: 'Receive notifications for important updates',
          type: SettingType.toggle,
          value: _notificationsEnabled,
        ),
        ProfileSetting(
          id: 'dark_mode',
          title: 'Dark Mode',
          description: 'Switch between light and dark theme',
          type: SettingType.toggle,
          value: _darkModeEnabled,
        ),
        ProfileSetting(
          id: 'language',
          title: 'Language',
          description: 'Select your preferred language',
          type: SettingType.selection,
          value: _selectedLanguage,
          options: ['en', 'es', 'fr', 'de'],
        ),
        ProfileSetting(
          id: 'privacy',
          title: 'Privacy Settings',
          description: 'Manage your privacy preferences',
          type: SettingType.navigation,
        ),
        ProfileSetting(
          id: 'security',
          title: 'Security',
          description: 'Two-factor authentication and security settings',
          type: SettingType.navigation,
        ),
      ];

      clearError();
      safeNotifyListeners();
    });
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
  }) async {
    final result = await executeWithLoading(() async {
      if (_userProfile == null) {
        setError('Profile not loaded');
        return false;
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      _userProfile = _userProfile!.copyWith(
        name: name ?? _userProfile!.name,
        email: email ?? _userProfile!.email,
        phone: phone ?? _userProfile!.phone,
        avatarUrl: avatarUrl ?? _userProfile!.avatarUrl,
      );

      clearError();
      safeNotifyListeners();
      return true;
    });

    return result ?? false;
  }

  /// Toggle notifications
  Future<void> toggleNotifications(bool enabled) async {
    await executeWithLoading(() async {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      _notificationsEnabled = enabled;

      // Update setting
      final settingIndex = _settings.indexWhere((s) => s.id == 'notifications');
      if (settingIndex != -1) {
        _settings[settingIndex] =
            _settings[settingIndex].copyWith(value: enabled);
      }

      clearError();
      safeNotifyListeners();
    });
  }

  /// Toggle dark mode
  Future<void> toggleDarkMode(bool enabled) async {
    await executeWithLoading(() async {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      _darkModeEnabled = enabled;

      // Update setting
      final settingIndex = _settings.indexWhere((s) => s.id == 'dark_mode');
      if (settingIndex != -1) {
        _settings[settingIndex] =
            _settings[settingIndex].copyWith(value: enabled);
      }

      clearError();
      safeNotifyListeners();
    });
  }

  /// Change language
  Future<void> changeLanguage(String languageCode) async {
    await executeWithLoading(() async {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      _selectedLanguage = languageCode;

      // Update setting
      final settingIndex = _settings.indexWhere((s) => s.id == 'language');
      if (settingIndex != -1) {
        _settings[settingIndex] =
            _settings[settingIndex].copyWith(value: languageCode);
      }

      clearError();
      safeNotifyListeners();
    });
  }

  /// Change password
  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    final result = await executeWithLoading(() async {
      // Validate inputs
      if (currentPassword.isEmpty) {
        setError('Current password is required');
        return false;
      }

      if (newPassword.isEmpty || newPassword.length < 6) {
        setError('New password must be at least 6 characters');
        return false;
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      clearError();
      return true;
    });

    return result ?? false;
  }

  /// Delete account
  Future<bool> deleteAccount(String password) async {
    final result = await executeWithLoading(() async {
      if (password.isEmpty) {
        setError('Password is required to delete account');
        return false;
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 3));

      clearError();
      return true;
    });

    return result ?? false;
  }

  /// Get setting by ID
  ProfileSetting? getSetting(String id) {
    try {
      return _settings.firstWhere((setting) => setting.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Update setting value
  void updateSetting(String id, dynamic value) {
    final settingIndex = _settings.indexWhere((s) => s.id == id);
    if (settingIndex != -1) {
      _settings[settingIndex] = _settings[settingIndex].copyWith(value: value);
      safeNotifyListeners();
    }
  }
}

/// User Profile Model
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final DateTime joinDate;
  final bool isVerified;
  final String role;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    required this.joinDate,
    required this.isVerified,
    required this.role,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    DateTime? joinDate,
    bool? isVerified,
    String? role,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      joinDate: joinDate ?? this.joinDate,
      isVerified: isVerified ?? this.isVerified,
      role: role ?? this.role,
    );
  }
}

/// Profile Setting Model
class ProfileSetting {
  final String id;
  final String title;
  final String description;
  final SettingType type;
  final dynamic value;
  final List<String>? options;

  const ProfileSetting({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.value,
    this.options,
  });

  ProfileSetting copyWith({
    String? id,
    String? title,
    String? description,
    SettingType? type,
    dynamic value,
    List<String>? options,
  }) {
    return ProfileSetting(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      value: value ?? this.value,
      options: options ?? this.options,
    );
  }
}

/// Setting Type Enum
enum SettingType {
  toggle,
  selection,
  navigation,
  input,
}
