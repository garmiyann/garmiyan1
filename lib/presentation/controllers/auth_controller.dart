import 'package:flutter/material.dart';
import '../../data/services/local_storage_service.dart';
import 'base_controller.dart';

/// Authentication Controller
///
/// Manages user authentication state including login, logout,
/// registration, and session management.
class AuthController extends BaseController {
  // User state
  User? _currentUser;
  bool _isLoggedIn = false;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  /// Initialize controller and check auth status
  void init() {
    _checkAuthStatus();
  }

  /// Check if user is already authenticated
  Future<void> _checkAuthStatus() async {
    await executeWithLoading(() async {
      // Check stored authentication token
      final token = await _getStoredToken();
      if (token != null && token.isNotEmpty) {
        // Validate token and get user data
        await _validateTokenAndGetUser(token);
      }
    });
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    final result = await executeWithLoading(() async {
      // Validate inputs
      if (email.isEmpty) {
        setError('Email is required');
        return false;
      }

      if (password.isEmpty) {
        setError('Password is required');
        return false;
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful login
      _currentUser = User(
        id: '1',
        email: email,
        name: _extractNameFromEmail(email),
        avatarUrl: null,
      );

      _isLoggedIn = true;
      await _storeAuthToken(
          'mock_token_${DateTime.now().millisecondsSinceEpoch}');

      clearError();
      safeNotifyListeners();
      return true;
    });

    return result ?? false;
  }

  /// Register new user
  Future<bool> register(String name, String email, String password) async {
    final result = await executeWithLoading(() async {
      // Validate inputs
      if (name.isEmpty || name.length < 2) {
        setError('Name must be at least 2 characters');
        return false;
      }

      if (email.isEmpty) {
        setError('Email is required');
        return false;
      }

      if (password.isEmpty || password.length < 6) {
        setError('Password must be at least 6 characters');
        return false;
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful registration
      _currentUser = User(
        id: '1',
        email: email,
        name: name,
        avatarUrl: null,
      );

      _isLoggedIn = true;
      await _storeAuthToken(
          'mock_token_${DateTime.now().millisecondsSinceEpoch}');

      clearError();
      safeNotifyListeners();
      return true;
    });

    return result ?? false;
  }

  /// Logout current user
  Future<void> logout() async {
    await executeWithLoading(() async {
      // Clear stored token
      await _clearStoredToken();

      // Clear stored credentials
      final storageService = await LocalStorageService.getInstance();
      await storageService.clearCredentials();

      // Clear user state
      _currentUser = null;
      _isLoggedIn = false;

      clearError();
      safeNotifyListeners();
    });
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    final result = await executeWithLoading(() async {
      if (email.isEmpty) {
        setError('Email is required');
        return false;
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      clearError();
      return true;
    });

    return result ?? false;
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? name,
    String? avatarUrl,
  }) async {
    final result = await executeWithLoading(() async {
      if (_currentUser == null) {
        setError('User not logged in');
        return false;
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Update user data
      _currentUser = _currentUser!.copyWith(
        name: name ?? _currentUser!.name,
        avatarUrl: avatarUrl ?? _currentUser!.avatarUrl,
      );

      clearError();
      safeNotifyListeners();
      return true;
    });

    return result ?? false;
  }

  // Private helper methods

  String _extractNameFromEmail(String email) {
    return email
        .split('@')
        .first
        .replaceAll('.', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }

  Future<String?> _getStoredToken() async {
    try {
      // In a real app, use secure storage
      return await StorageService.getString('auth_token');
    } catch (e) {
      debugPrint('Failed to get stored token: $e');
      return null;
    }
  }

  Future<void> _storeAuthToken(String token) async {
    try {
      // In a real app, use secure storage
      await StorageService.setString('auth_token', token);
    } catch (e) {
      debugPrint('Failed to store auth token: $e');
    }
  }

  Future<void> _clearStoredToken() async {
    try {
      await StorageService.remove('auth_token');
    } catch (e) {
      debugPrint('Failed to clear stored token: $e');
    }
  }

  Future<void> _validateTokenAndGetUser(String token) async {
    try {
      // Simulate token validation
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock user data based on token
      _currentUser = User(
        id: '1',
        email: 'user@example.com',
        name: 'John Doe',
        avatarUrl: null,
      );

      _isLoggedIn = true;
      safeNotifyListeners();
    } catch (e) {
      debugPrint('Token validation failed: $e');
      await _clearStoredToken();
    }
  }
}

/// User Model
class User {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

/// Storage Service Mock
class StorageService {
  static final Map<String, String> _storage = {};

  static Future<String?> getString(String key) async {
    return _storage[key];
  }

  static Future<void> setString(String key, String value) async {
    _storage[key] = value;
  }

  static Future<void> remove(String key) async {
    _storage.remove(key);
  }
}
