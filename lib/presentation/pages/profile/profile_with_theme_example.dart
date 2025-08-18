import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../../widgets/simple_theme_toggle.dart';
import '../../widgets/theme_mode_selector.dart' show ThemeModeSelector;

/// Example of how to add theme mode to any existing profile page
class ProfileWithThemeExample extends StatelessWidget {
  const ProfileWithThemeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Option 1: Simple theme toggle button in app bar
          const ThemeToggleButton(),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile header
              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: const Text('John Doe'),
                  subtitle: const Text('john.doe@example.com'),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.spacingLarge),

              // Settings section with theme mode
              Text(
                'Settings',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingMedium),

              Card(
                child: Column(
                  children: [
                    // Option 2: Theme mode as a settings tile
                    const ThemeModeToggleTile(
                      title: 'Appearance',
                      subtitle: 'Choose your preferred theme',
                    ),

                    const Divider(height: 1),

                    ListTile(
                      leading: const Icon(Icons.notifications_outlined),
                      title: const Text('Notifications'),
                      subtitle: const Text('Manage your notifications'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),

                    const Divider(height: 1),

                    ListTile(
                      leading: const Icon(Icons.language_outlined),
                      title: const Text('Language'),
                      subtitle: const Text('Select your language'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.spacingLarge),

              // Alternative: Full theme selector embedded
              Text(
                'Theme Selection',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingMedium),

              // Option 3: Full theme mode selector widget
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                  child:
                      const ThemeModeSelector(), // From theme_mode_selector.dart
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
