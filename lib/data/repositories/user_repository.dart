import '../../core/core.dart';
import '../models/models.dart';

/// Abstract repository interface for user operations
abstract class UserRepository {
  /// Get current user
  Future<Result<UserModel?>> getCurrentUser();

  /// Sign in with email and password
  Future<Result<UserModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<Result<UserModel>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  });

  /// Sign out current user
  Future<Result<void>> signOut();

  /// Send password reset email
  Future<Result<void>> sendPasswordResetEmail(String email);

  /// Send email verification
  Future<Result<void>> sendEmailVerification();

  /// Update user profile
  Future<Result<UserModel>> updateUserProfile(UserModel user);

  /// Get user by ID
  Future<Result<UserModel>> getUserById(String userId);

  /// Check if user is authenticated
  bool isAuthenticated();

  /// Get authentication state stream
  Stream<UserModel?> get authStateChanges;
}
