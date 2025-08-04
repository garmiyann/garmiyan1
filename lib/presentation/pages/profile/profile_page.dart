import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../../widgets/theme_mode_selector.dart';

/// Professional Profile Page with Theme Mode Selection
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Settings button to navigate to full settings
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/settings');
            },
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              _buildProfileHeader(context),

              const SizedBox(height: AppDimensions.spacingXLarge),

              // Theme Mode Section
              _buildSectionHeader('Appearance'),
              const SizedBox(height: AppDimensions.spacingMedium),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                  child: const ThemeModeSelector(),
                ),
              ),

              const SizedBox(height: AppDimensions.spacingXLarge),

              // Profile Settings Section
              _buildSectionHeader('Profile Settings'),
              const SizedBox(height: AppDimensions.spacingMedium),
              _buildProfileSettingsCard(context),

              const SizedBox(height: AppDimensions.spacingXLarge),

              // Account Actions Section
              _buildSectionHeader('Account'),
              const SizedBox(height: AppDimensions.spacingMedium),
              _buildAccountActionsCard(context),

              const SizedBox(height: AppDimensions.spacingXLarge),

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

  Widget _buildProfileHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Row(
          children: [
            // Profile Avatar
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Icon(
                Icons.person,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingLarge),

            // Profile Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Doe', // This would come from user data
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingSmall),
                  Text(
                    'john.doe@example.com', // This would come from user data
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Edit Profile Button
            IconButton(
              onPressed: () {
                // Navigate to edit profile
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Edit profile coming soon!'),
                  ),
                );
              },
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSettingsCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(
              'Personal Information',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Update your personal details',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Personal information settings coming soon!'),
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(
              'Notifications',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Manage notification preferences',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notification settings coming soon!'),
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(
              'Language',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'English', // This would come from settings
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Language settings coming soon!'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountActionsCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Privacy settings coming soon!'),
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(
              'Help & Support',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Get help and contact support',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Help & support coming soon!'),
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
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate back to login and clear all routes
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
