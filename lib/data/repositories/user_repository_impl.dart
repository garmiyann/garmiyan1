import '../../core/core.dart';
import '../models/models.dart';
import '../services/auth_service.dart';
import 'user_repository.dart';

/// Implementation of UserRepository using AuthService
class UserRepositoryImpl implements UserRepository {
  final AuthService _authService;

  UserRepositoryImpl({AuthService? authService})
      : _authService = authService ?? AuthService();

  @override
  Future<Result<UserModel?>> getCurrentUser() async {
    try {
      final firebaseUser = _authService.currentUser;
      if (firebaseUser == null) {
        return ResultHelper.success(null);
      }

      // For now, create a basic UserModel from Firebase User
      // In a real app, you'd get additional data from Firestore
      final userModel = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        name: firebaseUser.displayName,
        isEmailVerified: firebaseUser.emailVerified,
        isPhoneVerified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return ResultHelper.success(userModel);
    } catch (e) {
      return ResultHelper.failure(AuthFailure(
        message: 'Failed to get current user.',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Result<UserModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _authService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<Result<UserModel>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  }) async {
    return await _authService.signUpWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );
  }

  @override
  Future<Result<void>> signOut() async {
    return await _authService.signOut();
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    return await _authService.sendPasswordResetEmail(email);
  }

  @override
  Future<Result<void>> sendEmailVerification() async {
    return await _authService.sendEmailVerification();
  }

  @override
  Future<Result<UserModel>> updateUserProfile(UserModel user) async {
    return await _authService.updateUserProfile(user);
  }

  @override
  Future<Result<UserModel>> getUserById(String userId) async {
    // In a real implementation, you'd fetch from Firestore
    return ResultHelper.failure(AuthFailure(
      message: 'getUserById not implemented yet.',
    ));
  }

  @override
  bool isAuthenticated() {
    return _authService.isSignedIn;
  }

  @override
  Stream<UserModel?> get authStateChanges async* {
    await for (final firebaseUser in _authService.authStateChanges) {
      if (firebaseUser == null) {
        yield null;
      } else {
        final userModel = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName,
          isEmailVerified: firebaseUser.emailVerified,
          isPhoneVerified: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        yield userModel;
      }
    }
  }
}
