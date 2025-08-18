import 'package:flutter/material.dart';
import '../../data/services/theme_service.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_dimensions.dart';

/// Widget for theme mode selection
class ThemeModeSelector extends StatefulWidget {
  const ThemeModeSelector({super.key});

  @override
  State<ThemeModeSelector> createState() => _ThemeModeSelectorState();
}

class _ThemeModeSelectorState extends State<ThemeModeSelector> {
  late ThemeService _themeService;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeThemeService();
  }

  Future<void> _initializeThemeService() async {
    _themeService = await ThemeService.getInstance();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AnimatedBuilder(
      animation: _themeService,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Mode',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMedium),

            // Light Mode Option
            _buildThemeOption(
              title: 'Light Mode',
              subtitle: 'Use light theme',
              icon: Icons.light_mode,
              themeMode: ThemeMode.light,
              isSelected: _themeService.isLightMode,
            ),

            const SizedBox(height: AppDimensions.spacingSmall),

            // Dark Mode Option
            _buildThemeOption(
              title: 'Dark Mode',
              subtitle: 'Use dark theme',
              icon: Icons.dark_mode,
              themeMode: ThemeMode.dark,
              isSelected: _themeService.isDarkMode,
            ),

            const SizedBox(height: AppDimensions.spacingSmall),

            // System Mode Option
            _buildThemeOption(
              title: 'System Default',
              subtitle: 'Use system theme setting',
              icon: Icons.auto_mode,
              themeMode: ThemeMode.system,
              isSelected: _themeService.isSystemMode,
            ),
          ],
        );
      },
    );
  }

  Widget _buildThemeOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeMode themeMode,
    required bool isSelected,
  }) {
    return Card(
      elevation: isSelected ? 4 : 1,
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: AppColors.primary,
              )
            : null,
        onTap: () => _themeService.setThemeMode(themeMode),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          side: isSelected
              ? BorderSide(color: AppColors.primary, width: 2)
              : BorderSide.none,
        ),
      ),
    );
  }
}

/// Simple theme toggle button
class ThemeToggleButton extends StatefulWidget {
  const ThemeToggleButton({super.key});

  @override
  State<ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<ThemeToggleButton> {
  late ThemeService _themeService;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeThemeService();
  }

  Future<void> _initializeThemeService() async {
    _themeService = await ThemeService.getInstance();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return AnimatedBuilder(
      animation: _themeService,
      builder: (context, child) {
        return IconButton(
          onPressed: _themeService.toggleTheme,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              _themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              key: ValueKey(_themeService.themeMode),
              color: AppColors.textPrimary,
            ),
          ),
          tooltip: _themeService.isDarkMode
              ? 'Switch to Light Mode'
              : 'Switch to Dark Mode',
        );
      },
    );
  }
}
