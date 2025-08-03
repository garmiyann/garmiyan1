/// Professional Presentation Layer
///
/// This barrel file exports all presentation layer components following
/// Clean Architecture principles and enterprise-level organization.
///
/// Architecture:
/// - pages/: Screen implementations
/// - widgets/: Reusable UI components
/// - controllers/: State management
/// - routes/: Navigation and routing
/// - theme/: UI theming and styling

// Pages - Main screens
export 'pages/pages.dart';

// Widgets - Reusable components
export 'widgets/widgets.dart';

// Controllers - State management
export 'controllers/controllers.dart';

// Routes - Navigation
export 'routes/routes.dart';

// Theme - UI styling (re-export from core)
export '../core/theme/app_theme.dart';
