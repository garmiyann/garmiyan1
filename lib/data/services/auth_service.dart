import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/core.dart';
import '../models/models.dart';

/// Authentication service handling user authentication
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Check if user is signed in
  bool get isSignedIn => currentUser != null;

  /// Sign in with email and password
  Future<Result<UserModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final userModel = await _getUserData(credential.user!.uid);
        return userModel.fold(
          (failure) => ResultHelper.failure(failure),
          (user) => ResultHelper.success(user),
        );
      } else {
        return ResultHelper.failure(AuthFailure(
          message: 'Sign in failed. Please try again.',
        ));
      }
    } on FirebaseAuthException catch (e) {
      return ResultHelper.failure(AuthFailure(
        message: _getAuthErrorMessage(e.code),
        details: e.message,
      ));
    } catch (e) {
      return ResultHelper.failure(AuthFailure(
        message: 'An unexpected error occurred.',
        details: e.toString(),
      ));
    }
  }

  /// Sign up with email and password
  Future<Result<UserModel>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Create user document in Firestore
        final userModel = UserModel(
          id: credential.user!.uid,
          email: email,
          name: name,
          isEmailVerified: credential.user!.emailVerified,
          isPhoneVerified: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _saveUserData(userModel);
        return ResultHelper.success(userModel);
      } else {
        return ResultHelper.failure(AuthFailure(
          message: 'Sign up failed. Please try again.',
        ));
      }
    } on FirebaseAuthException catch (e) {
      return ResultHelper.failure(AuthFailure(
        message: _getAuthErrorMessage(e.code),
        details: e.message,
      ));
    } catch (e) {
      return ResultHelper.failure(AuthFailure(
        message: 'An unexpected error occurred.',
        details: e.toString(),
      ));
    }
  }

  /// Sign out
  Future<Result<void>> signOut() async {
    try {
      await _auth.signOut();
      return ResultHelper.success(null);
    } catch (e) {
      return ResultHelper.failure(AuthFailure(
        message: 'Sign out failed.',
        details: e.toString(),
      ));
    }
  }

  /// Send password reset email
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return ResultHelper.success(null);
    } on FirebaseAuthException catch (e) {
      return ResultHelper.failure(AuthFailure(
        message: _getAuthErrorMessage(e.code),
        details: e.message,
      ));
    } catch (e) {
      return ResultHelper.failure(AuthFailure(
        message: 'Failed to send password reset email.',
        details: e.toString(),
      ));
    }
  }

  /// Send email verification
  Future<Result<void>> sendEmailVerification() async {
    try {
      final user = currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return ResultHelper.success(null);
      } else {
        return ResultHelper.failure(AuthFailure(
          message: 'No user to verify or email already verified.',
        ));
      }
    } catch (e) {
      return ResultHelper.failure(AuthFailure(
        message: 'Failed to send verification email.',
        details: e.toString(),
      ));
    }
  }

  /// Update user profile
  Future<Result<UserModel>> updateUserProfile(UserModel updatedUser) async {
    try {
      final user = currentUser;
      if (user == null) {
        return ResultHelper.failure(AuthFailure(
          message: 'No authenticated user found.',
        ));
      }

      // Update display name in Firebase Auth
      if (updatedUser.name != null) {
        await user.updateDisplayName(updatedUser.name);
      }

      // Update user document in Firestore
      final userWithUpdatedTime = updatedUser.copyWith(
        updatedAt: DateTime.now(),
      );
      await _saveUserData(userWithUpdatedTime);

      return ResultHelper.success(userWithUpdatedTime);
    } catch (e) {
      return ResultHelper.failure(AuthFailure(
        message: 'Failed to update profile.',
        details: e.toString(),
      ));
    }
  }

  /// Get user data from Firestore
  Future<Result<UserModel>> _getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return ResultHelper.success(UserModel.fromJson(doc.data()!));
      } else {
        return ResultHelper.failure(DatabaseFailure(
          message: 'User data not found.',
        ));
      }
    } catch (e) {
      return ResultHelper.failure(DatabaseFailure(
        message: 'Failed to get user data.',
        details: e.toString(),
      ));
    }
  }

  /// Save user data to Firestore
  Future<void> _saveUserData(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toJson());
  }

  /// Get authentication error message
  String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'Operation not allowed. Please contact support.';
      default:
        return 'Authentication error occurred.';
    }
  }
}
