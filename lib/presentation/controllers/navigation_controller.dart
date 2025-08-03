import 'package:flutter/material.dart';
import 'base_controller.dart';

/// Navigation Controller
///
/// Manages navigation state, bottom navigation,
/// drawer state, and routing throughout the app.
class NavigationController extends BaseController {
  // Navigation state
  int _currentIndex = 0;
  int _previousIndex = 0;
  bool _isDrawerOpen = false;
  final List<NavigationItem> _navigationItems = [];
  final List<String> _navigationHistory = [];

  // Getters
  int get currentIndex => _currentIndex;
  int get previousIndex => _previousIndex;
  bool get isDrawerOpen => _isDrawerOpen;
  List<NavigationItem> get navigationItems => _navigationItems;
  List<String> get navigationHistory => _navigationHistory;

  /// Initialize navigation
  void init() {
    _setupNavigationItems();
  }

  /// Setup navigation items
  void _setupNavigationItems() {
    _navigationItems.clear();
    _navigationItems.addAll([
      NavigationItem(
        id: 'home',
        label: 'Home',
        icon: Icons.home,
        activeIcon: Icons.home,
        route: '/home',
      ),
      NavigationItem(
        id: 'analytics',
        label: 'Analytics',
        icon: Icons.analytics_outlined,
        activeIcon: Icons.analytics,
        route: '/analytics',
      ),
      NavigationItem(
        id: 'orders',
        label: 'Orders',
        icon: Icons.shopping_cart_outlined,
        activeIcon: Icons.shopping_cart,
        route: '/orders',
        badge: '12',
      ),
      NavigationItem(
        id: 'profile',
        label: 'Profile',
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        route: '/profile',
      ),
    ]);

    safeNotifyListeners();
  }

  /// Change current navigation index
  void changeIndex(int index) {
    if (index >= 0 &&
        index < _navigationItems.length &&
        index != _currentIndex) {
      _previousIndex = _currentIndex;
      _currentIndex = index;

      // Add to navigation history
      final route = _navigationItems[index].route;
      _addToHistory(route);

      safeNotifyListeners();
    }
  }

  /// Go to specific navigation item by ID
  void navigateToId(String itemId) {
    final index = _navigationItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      changeIndex(index);
    }
  }

  /// Go back to previous navigation item
  void goBack() {
    if (_previousIndex >= 0 && _previousIndex < _navigationItems.length) {
      final temp = _currentIndex;
      _currentIndex = _previousIndex;
      _previousIndex = temp;

      safeNotifyListeners();
    }
  }

  /// Toggle drawer state
  void toggleDrawer() {
    _isDrawerOpen = !_isDrawerOpen;
    safeNotifyListeners();
  }

  /// Open drawer
  void openDrawer() {
    if (!_isDrawerOpen) {
      _isDrawerOpen = true;
      safeNotifyListeners();
    }
  }

  /// Close drawer
  void closeDrawer() {
    if (_isDrawerOpen) {
      _isDrawerOpen = false;
      safeNotifyListeners();
    }
  }

  /// Add route to navigation history
  void _addToHistory(String route) {
    _navigationHistory.add(route);

    // Keep only last 10 routes
    if (_navigationHistory.length > 10) {
      _navigationHistory.removeAt(0);
    }
  }

  /// Clear navigation history
  void clearHistory() {
    _navigationHistory.clear();
    safeNotifyListeners();
  }

  /// Get current navigation item
  NavigationItem get currentNavigationItem {
    if (_currentIndex >= 0 && _currentIndex < _navigationItems.length) {
      return _navigationItems[_currentIndex];
    }
    return _navigationItems.first;
  }

  /// Get navigation item by ID
  NavigationItem? getNavigationItem(String id) {
    try {
      return _navigationItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Update navigation item badge
  void updateBadge(String itemId, String? badge) {
    final index = _navigationItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      _navigationItems[index] = _navigationItems[index].copyWith(badge: badge);
      safeNotifyListeners();
    }
  }

  /// Remove badge from navigation item
  void removeBadge(String itemId) {
    updateBadge(itemId, null);
  }

  /// Check if can go back
  bool get canGoBack => _navigationHistory.length > 1;

  /// Get previous route
  String? get previousRoute {
    if (_navigationHistory.length > 1) {
      return _navigationHistory[_navigationHistory.length - 2];
    }
    return null;
  }

  /// Reset navigation to initial state
  void reset() {
    _currentIndex = 0;
    _previousIndex = 0;
    _isDrawerOpen = false;
    _navigationHistory.clear();
    super.reset();
  }
}

/// Navigation Item Model
class NavigationItem {
  final String id;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;
  final String? badge;
  final bool isEnabled;

  const NavigationItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
    this.badge,
    this.isEnabled = true,
  });

  NavigationItem copyWith({
    String? id,
    String? label,
    IconData? icon,
    IconData? activeIcon,
    String? route,
    String? badge,
    bool? isEnabled,
  }) {
    return NavigationItem(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      activeIcon: activeIcon ?? this.activeIcon,
      route: route ?? this.route,
      badge: badge ?? this.badge,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
