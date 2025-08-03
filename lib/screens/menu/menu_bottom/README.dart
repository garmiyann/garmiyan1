// Menu Bottom Structure Documentation
/*
Updated Menu Bottom Navigation Structure:

menu_bottom/
├── menu_bottom_screens.dart (Main export file)
├── home/ (Home Tab - Main feed/dashboard)
│   ├── home.dart (Export file)
│   └── home_screen.dart
├── ai/ (AI Assistant Tab)
│   ├── ai.dart (Export file)
│   └── ai_screen.dart
├── plus_button/ (Create/Add Content Tab)
│   ├── plus_button.dart (Export file)
│   ├── plus_button_screen.dart (Main plus menu)
│   └── add_project_screen.dart (Add new project)
├── notification/ (Notifications Tab)
│   ├── notification.dart (Export file)
│   └── notification_screen.dart
└── profile/ (User Profile Tab)
    ├── profile.dart (Export file)
    └── profile_screen.dart

Features:
1. HOME: Main dashboard and feed
2. AI: AI Assistant and smart features
3. PLUS: Create projects, posts, media, live streams, stories, events
4. NOTIFICATIONS: Activity feed and alerts
5. PROFILE: User settings and account management

Usage:
- Import all: import 'screens/menu/menu_bottom/menu_bottom_screens.dart';
- Import specific: import 'screens/menu/menu_bottom/home/home.dart';

Each folder is self-contained with its own export file for clean imports.
*/
