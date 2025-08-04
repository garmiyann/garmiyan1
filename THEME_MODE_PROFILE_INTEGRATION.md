# Profile Theme Mode Integration

This document explains how to add theme mode functionality to profile and settings pages in your Flutter application.

## Available Theme Mode Components

### 1. ThemeToggleButton
- **Location**: `lib/presentation/widgets/simple_theme_toggle.dart`
- **Use case**: Simple toggle button for app bars
- **Features**: Toggles between light and dark mode with animated icon

```dart
AppBar(
  title: Text('Profile'),
  actions: [
    const ThemeToggleButton(),
  ],
)
```

### 2. ThemeModeToggleTile
- **Location**: `lib/presentation/widgets/simple_theme_toggle.dart`
- **Use case**: Settings list tile with theme selection dialog
- **Features**: Shows current theme mode and opens selection dialog

```dart
Card(
  child: Column(
    children: [
      const ThemeModeToggleTile(
        title: 'Appearance',
        subtitle: 'Choose your preferred theme',
      ),
      // Other settings tiles...
    ],
  ),
)
```

### 3. ThemeModeSelector
- **Location**: `lib/presentation/widgets/theme_mode_selector.dart`
- **Use case**: Full theme selection widget with all options visible
- **Features**: Shows Light, Dark, and System options as cards

```dart
Card(
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: const ThemeModeSelector(),
  ),
)
```

## Implementation Examples

### Complete Profile Page
The `ProfilePage` in `lib/presentation/pages/profile/profile_page.dart` demonstrates a complete profile implementation with:
- Profile header with user information
- Theme mode selector section
- Profile settings
- Account actions

### Professional Settings Page
The `SettingsPage` in `lib/presentation/pages/profile/professional_settings_page.dart` shows:
- App information section
- Appearance section with theme selector
- Account management

### Integration Example
The `ProfileWithThemeExample` in `lib/presentation/pages/profile/profile_with_theme_example.dart` shows three different ways to integrate theme selection:
1. App bar toggle button
2. Settings tile with dialog
3. Full embedded selector

## Theme Modes Available

1. **Light Mode**: Always uses light theme
2. **Dark Mode**: Always uses dark theme  
3. **System Default**: Follows system theme setting

## Architecture

The theme system uses:
- `ThemeService`: Manages theme state and persistence
- Clean architecture pattern with proper separation of concerns
- SharedPreferences for theme preference storage
- AnimatedBuilder for reactive UI updates

## Usage Recommendations

- Use `ThemeToggleButton` in app bars for quick theme switching
- Use `ThemeModeToggleTile` in settings pages for clean integration
- Use `ThemeModeSelector` when you want all options visible at once
- All widgets are fully responsive and follow Material Design guidelines

## Customization

All theme components respect your app's:
- Color scheme (`AppColors`)
- Text styles (`AppTextStyles`) 
- Spacing (`AppDimensions`)
- Localization (`AppStrings`)

The theme selection automatically persists user preferences and applies them across the entire application.
