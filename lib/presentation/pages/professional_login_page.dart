import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/usecases/sign_in_usecase.dart';

/// Professional login page using the new architecture
class ProfessionalLoginPage extends StatefulWidget {
  const ProfessionalLoginPage({super.key});

  @override
  State<ProfessionalLoginPage> createState() => _ProfessionalLoginPageState();
}

class _ProfessionalLoginPageState extends State<ProfessionalLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _showPassword = false;

  // Dependency injection - in a real app, use a service locator
  late final SignInUseCase _signInUseCase;

  @override
  void initState() {
    super.initState();
    // Initialize use case with repository
    final userRepository = UserRepositoryImpl();
    _signInUseCase = SignInUseCase(userRepository);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Use the professional architecture
      final result = await _signInUseCase.call(SignInParams(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ));

      if (mounted) {
        result.fold(
          // Handle failure
          (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failure.message),
                backgroundColor: AppColors.error,
              ),
            );
          },
          // Handle success
          (user) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('${AppStrings.welcomeBack}, ${user.displayName}!'),
                backgroundColor: AppColors.success,
              ),
            );

            // Navigate to home
            Navigator.of(context).pushReplacementNamed('/home');
          },
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.signIn),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  AppStrings.welcomeBack,
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppDimensions.spacingXLarge),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                  decoration: InputDecoration(
                    labelText: AppStrings.email,
                    prefixIcon: const Icon(Icons.email_outlined),
                    // Theme applied automatically
                  ),
                ),

                const SizedBox(height: AppDimensions.spacingLarge),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  validator: Validators.password,
                  decoration: InputDecoration(
                    labelText: AppStrings.password,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: AppDimensions.spacingXLarge),

                // Sign In Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.textPrimary,
                            ),
                          ),
                        )
                      : Text(AppStrings.signIn),
                ),

                const SizedBox(height: AppDimensions.spacingMedium),

                // Forgot Password
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/forgot-password');
                  },
                  child: Text(AppStrings.forgotPassword),
                ),

                const Spacer(),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.dontHaveAccount,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/register');
                      },
                      child: Text(AppStrings.signUp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
