import '../../core/core.dart';
import '../../data/repositories/user_repository.dart';
import '../entities/user.dart';
import 'usecase.dart';

/// Parameters for sign in use case
class SignInParams {
  final String email;
  final String password;

  const SignInParams({
    required this.email,
    required this.password,
  });
}

/// Use case for signing in a user
class SignInUseCase implements UseCase<User, SignInParams> {
  final UserRepository repository;

  SignInUseCase(this.repository);

  @override
  Future<Result<User>> call(SignInParams params) async {
    // Validate email format
    final emailError = Validators.email(params.email);
    if (emailError != null) {
      return ResultHelper.failure(ValidationFailure(
        message: emailError,
      ));
    }

    // Validate password
    final passwordError = Validators.password(params.password);
    if (passwordError != null) {
      return ResultHelper.failure(ValidationFailure(
        message: passwordError,
      ));
    }

    // Call repository to sign in
    final result = await repository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );

    return result.map((userModel) => User(
          id: userModel.id,
          email: userModel.email,
          name: userModel.name,
          phone: userModel.phone,
          profileImage: userModel.profileImage,
          dateOfBirth: userModel.dateOfBirth,
          address: userModel.address,
          city: userModel.city,
          country: userModel.country,
          isEmailVerified: userModel.isEmailVerified,
          isPhoneVerified: userModel.isPhoneVerified,
          createdAt: userModel.createdAt,
          updatedAt: userModel.updatedAt,
        ));
  }
}
