/// Professional Application Routes
///
/// Centralized route definitions following enterprise patterns
/// with proper categorization and route management.
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // ================ AUTHENTICATION ROUTES ================
  static const String splash = '/';
  static const String authWrapper = '/auth';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String phoneLogin = '/auth/phone-login';
  static const String forgotPassword = '/auth/forgot-password';
  static const String otpVerification = '/auth/otp-verification';

  // ================ HOME & DASHBOARD ROUTES ================
  static const String home = '/home';
  static const String dashboard = '/dashboard';

  // Profile & Settings Routes
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String accountSettings = '/account-settings';
  static const String notificationSettings = '/notification-settings';
  static const String userPreferences = '/user-preferences';
  static const String about = '/about';

  // Communication Routes
  static const String messenger = '/messenger';
  static const String chat = '/chat';
  static const String contacts = '/contacts';
  static const String groups = '/groups';
  static const String notifications = '/notifications';

  // Shopping Routes
  static const String shop = '/shop';
  static const String shoppingBrowser = '/shopping-browser';
  static const String cart = '/cart';
  static const String checkout = '/checkout';

  // Subscription & Payment Routes
  static const String subscription = '/subscription';
  static const String buySubscription = '/buy-subscription';
  static const String manageSubscription = '/manage-subscription';
  static const String payment = '/payment';
  static const String balance = '/balance';

  // Lifestyle & AI Routes
  static const String lifestyle = '/lifestyle';
  static const String aiAssistant = '/ai-assistant';
  static const String live = '/live';

  // Onboarding Routes
  static const String onboarding = '/onboarding';
  static const String tutorial = '/tutorial';

  /// Get all route names for validation
  static List<String> get allRoutes => [
        splash,
        authWrapper,
        login,
        register,
        forgotPassword,
        otpVerification,
        phoneLogin,
        home,
        dashboard,
        profile,
        settings,
        accountSettings,
        notificationSettings,
        userPreferences,
        about,
        messenger,
        chat,
        contacts,
        groups,
        notifications,
        shop,
        shoppingBrowser,
        cart,
        checkout,
        subscription,
        buySubscription,
        manageSubscription,
        payment,
        balance,
        lifestyle,
        aiAssistant,
        live,
        onboarding,
        tutorial,
      ];

  /// Check if route exists
  static bool isValidRoute(String route) => allRoutes.contains(route);

  /// Get route category for analytics
  static String getRouteCategory(String route) {
    if (route.startsWith('/auth') ||
        [login, register, forgotPassword, otpVerification, phoneLogin]
            .contains(route)) {
      return 'Authentication';
    }
    if ([home, dashboard].contains(route)) {
      return 'Home';
    }
    if ([
      profile,
      settings,
      accountSettings,
      notificationSettings,
      userPreferences,
      about
    ].contains(route)) {
      return 'Profile';
    }
    if ([messenger, chat, contacts, groups, notifications].contains(route)) {
      return 'Communication';
    }
    if ([shop, shoppingBrowser, cart, checkout].contains(route)) {
      return 'Shopping';
    }
    if ([subscription, buySubscription, manageSubscription, payment, balance]
        .contains(route)) {
      return 'Subscription';
    }
    if ([lifestyle, aiAssistant, live].contains(route)) {
      return 'Lifestyle';
    }
    if ([onboarding, tutorial].contains(route)) {
      return 'Onboarding';
    }
    return 'Other';
  }
}
