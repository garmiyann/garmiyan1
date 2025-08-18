import 'package:flutter/material.dart';
import '../../data/services/theme_service.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_dimensions.dart';

/// Simple theme toggle button for app bars
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

/// Simple theme mode toggle list tile for settings pages
class ThemeModeToggleTile extends StatefulWidget {
  final String? title;
  final String? subtitle;
  final bool showIcon;

  const ThemeModeToggleTile({
    super.key,
    this.title,
    this.subtitle,
    this.showIcon = true,
  });

  @override
  State<ThemeModeToggleTile> createState() => _ThemeModeToggleTileState();
}

class _ThemeModeToggleTileState extends State<ThemeModeToggleTile> {
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

  String get _currentThemeText {
    switch (_themeService.themeMode) {
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
      case ThemeMode.system:
        return 'System Default';
    }
  }

  IconData get _currentThemeIcon {
    switch (_themeService.themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.auto_mode;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return ListTile(
        leading: widget.showIcon ? const Icon(Icons.palette_outlined) : null,
        title: Text(widget.title ?? 'Theme Mode'),
        subtitle: const Text('Loading...'),
        trailing: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _themeService,
      builder: (context, child) {
        return ListTile(
          leading: widget.showIcon
              ? Icon(
                  _currentThemeIcon,
                  color: AppColors.primary,
                )
              : null,
          title: Text(
            widget.title ?? 'Theme Mode',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            widget.subtitle ?? _currentThemeText,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _currentThemeText,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSmall),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
          onTap: () => _showThemeSelectionDialog(context),
        );
      },
    );
  }

  void _showThemeSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Theme Mode',
            style: AppTextStyles.headlineSmall,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeDialogOption(
                context: context,
                title: 'Light Mode',
                subtitle: 'Use light theme',
                icon: Icons.light_mode,
                themeMode: ThemeMode.light,
                isSelected: _themeService.isLightMode,
              ),
              _buildThemeDialogOption(
                context: context,
                title: 'Dark Mode',
                subtitle: 'Use dark theme',
                icon: Icons.dark_mode,
                themeMode: ThemeMode.dark,
                isSelected: _themeService.isDarkMode,
              ),
              _buildThemeDialogOption(
                context: context,
                title: 'System Default',
                subtitle: 'Use system theme setting',
                icon: Icons.auto_mode,
                themeMode: ThemeMode.system,
                isSelected: _themeService.isSystemMode,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildThemeDialogOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeMode themeMode,
    required bool isSelected,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
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
      onTap: () {
        _themeService.setThemeMode(themeMode);
        Navigator.of(context).pop();
      },
    );
  }
}
