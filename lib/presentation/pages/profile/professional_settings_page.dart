import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../../widgets/theme_mode_selector.dart';

/// Professional Settings Page
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.settings),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Info Section
              _buildSectionHeader('App Information'),
              const SizedBox(height: AppDimensions.spacingMedium),
              _buildInfoCard(context),

              const SizedBox(height: AppDimensions.spacingXLarge),

              // Theme Section
              _buildSectionHeader('Appearance'),
              const SizedBox(height: AppDimensions.spacingMedium),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                  child: const ThemeModeSelector(),
                ),
              ),

              const SizedBox(height: AppDimensions.spacingXLarge),

              // Account Section
              _buildSectionHeader('Account'),
              const SizedBox(height: AppDimensions.spacingMedium),
              _buildAccountCard(context),

              const Spacer(),

              // Powered by CGC
              Center(
                child: Text(
                  'Powered by CGC',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingMedium),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.headlineSmall.copyWith(
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(
              'App Version',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              AppStrings.appVersion,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.business),
            title: Text(
              'Company',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              AppStrings.companyName,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(
              'Profile',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Manage your profile settings',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).pushNamed('/profile');
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.security),
            title: Text(
              'Privacy & Security',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Manage your privacy settings',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to privacy settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Privacy settings coming soon!'),
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.error),
            title: Text(
              'Sign Out',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.error,
              ),
            ),
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sign Out',
            style: AppTextStyles.headlineSmall,
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement actual logout
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              },
              child: Text(
                'Sign Out',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
