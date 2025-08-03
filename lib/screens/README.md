# Screens Directory Organization

This directory has been systematically reorganized into logical categories following clean architecture principles.

## Directory Structure

### 📁 `auth/` - Authentication Screens
- `otp_verification_page.dart` - OTP verification screen
- `index.dart` - Barrel export file

### 📁 `communication/` - Communication & Messaging
- `chat_screen.dart` - Individual chat interface
- `contacts_screen.dart` - Contacts list and management
- `messenger_screen.dart` - Main messaging hub
- `index.dart` - Barrel export file

### 📁 `profile/` - User Profile Management
- `profile_screen.dart` - TikTok-style user profile with follow/unfollow system
- `settings_screen.dart` - User settings and preferences
- `about_screen.dart` - About user information
- `index.dart` - Barrel export file

### 📁 `lifestyle/` - Lifestyle & Social Features
- `live_screen.dart` - Live streaming interface
- `lifestyle_screen.dart` - Lifestyle content and recommendations
- `groups_screen.dart` - Group management and interactions
- `index.dart` - Barrel export file

### 📁 `shopping/` - E-commerce Features
- `shop_page.dart` - Main shopping interface
- `shopping_browser_page.dart` - Shopping browser and product catalog
- `index.dart` - Barrel export file

### 📁 `finance/` - Financial Management
- `balance_screen.dart` - Account balance and financial overview
- `buy_subscription_screen.dart` - Subscription purchase interface
- `manage_subscription_screen.dart` - Subscription management
- `index.dart` - Barrel export file

### 📁 `general/` - General Utility Screens
- `notifications_screen.dart` - Notifications center
- `telegram_settings_page.dart` - Telegram integration settings
- `index.dart` - Barrel export file

### 📁 `onboarding/` - User Onboarding
- `onboarding_page.dart` - App introduction and tutorial
- `index.dart` - Barrel export file

### 📁 Other Specialized Directories
- `ai/` - AI-powered features and interfaces
- `menu/` - Menu systems and navigation
- `menu_top_bar/` - Top navigation bar components
- `payment/` - Payment processing interfaces

## Migration Status

✅ **COMPLETED** - All screen files have been successfully moved to their appropriate category directories
✅ **COMPLETED** - All import paths across the codebase have been updated to reflect the new structure
✅ **COMPLETED** - Index/barrel export files created for each category for easier imports
✅ **COMPLETED** - README documentation updated with final structure

## Usage

You can now import screens using organized paths:
```dart
// Old way
import '../../../screens/profile_screen.dart';

// New organized way
import '../../../screens/profile/profile_screen.dart';

// Or using barrel exports
import '../../../screens/profile/index.dart';
```

## Benefits

1. **Better Organization** - Related screens are grouped logically
2. **Easier Navigation** - Developers can quickly find relevant screens
3. **Scalability** - New screens can be easily categorized
4. **Maintainability** - Clear separation of concerns
5. **Team Collaboration** - Consistent structure for all team members

## Architecture Alignment

This organization aligns with the clean architecture patterns used in the `presentation/` layer, providing a clear bridge between legacy screens and the new architectural approach.
