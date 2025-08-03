import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Professional Authentication Wrapper
///
/// Handles authentication state and routing in a professional manner.
/// Follows Clean Architecture patterns with proper error handling.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Professional Logo/Brand Section
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_pin,
                  size: 60,
                  color: AppColors.onPrimary,
                ),
              ),

              const SizedBox(height: AppDimensions.spacingXLarge),

              Text(
                AppStrings.welcomeTo,
                style: AppTextStyles.headlineLarge.copyWith(
                  color: AppColors.onBackground,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppDimensions.spacingSmall),

              Text(
                AppStrings.appName,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppDimensions.spacingXLarge),

              // Professional Auth Options
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                ),
                child: Column(
                  children: [
                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _navigateToLogin(context),
                        style: ElevatedButton.styleFrom(
                          padding:
                              const EdgeInsets.all(AppDimensions.paddingLarge),
                        ),
                        child: Text(
                          AppStrings.signIn,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.spacingMedium),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _navigateToRegister(context),
                        style: OutlinedButton.styleFrom(
                          padding:
                              const EdgeInsets.all(AppDimensions.paddingLarge),
                        ),
                        child: Text(
                          AppStrings.signUp,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.spacingLarge),

                    // Phone Login Option
                    TextButton.icon(
                      onPressed: () => _navigateToPhoneLogin(context),
                      icon: const Icon(Icons.phone),
                      label: Text(
                        'Continue with Phone',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  void _navigateToPhoneLogin(BuildContext context) {
    Navigator.pushNamed(context, '/phone-login');
  }
}
