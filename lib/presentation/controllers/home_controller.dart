import 'package:flutter/material.dart';
import 'base_controller.dart';

/// Home Controller
///
/// Manages home screen state including dashboard data,
/// navigation, and user interactions.
class HomeController extends BaseController {
  // Dashboard data
  List<DashboardItem> _dashboardItems = [];
  List<RecentActivity> _recentActivities = [];
  Map<String, dynamic> _stats = {};

  // Getters
  List<DashboardItem> get dashboardItems => _dashboardItems;
  List<RecentActivity> get recentActivities => _recentActivities;
  Map<String, dynamic> get stats => _stats;

  /// Initialize home data
  void init() {
    loadDashboardData();
  }

  /// Load dashboard data
  Future<void> loadDashboardData() async {
    await executeWithLoading(() async {
      // Simulate API calls
      await Future.delayed(const Duration(seconds: 1));

      _dashboardItems = [
        DashboardItem(
          id: '1',
          title: 'Total Users',
          value: '12,345',
          icon: Icons.people,
          color: Colors.blue,
          trend: 8.5,
        ),
        DashboardItem(
          id: '2',
          title: 'Revenue',
          value: '\$125,430',
          icon: Icons.attach_money,
          color: Colors.green,
          trend: 12.3,
        ),
        DashboardItem(
          id: '3',
          title: 'Orders',
          value: '1,234',
          icon: Icons.shopping_cart,
          color: Colors.orange,
          trend: -2.1,
        ),
        DashboardItem(
          id: '4',
          title: 'Conversion',
          value: '3.24%',
          icon: Icons.trending_up,
          color: Colors.purple,
          trend: 0.8,
        ),
      ];

      _recentActivities = [
        RecentActivity(
          id: '1',
          title: 'New user registered',
          description: 'John Doe joined the platform',
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          type: ActivityType.user,
        ),
        RecentActivity(
          id: '2',
          title: 'Order completed',
          description: 'Order #1234 has been delivered',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          type: ActivityType.order,
        ),
        RecentActivity(
          id: '3',
          title: 'Payment received',
          description: '\$250 payment processed',
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          type: ActivityType.payment,
        ),
      ];

      _stats = {
        'totalUsers': 12345,
        'activeUsers': 8492,
        'totalRevenue': 125430,
        'totalOrders': 1234,
        'conversionRate': 3.24,
        'averageOrderValue': 95.50,
      };

      clearError();
      safeNotifyListeners();
    });
  }

  /// Refresh dashboard data
  Future<void> refreshData() async {
    await loadDashboardData();
  }

  /// Get dashboard item by ID
  DashboardItem? getDashboardItem(String id) {
    try {
      return _dashboardItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add new activity
  void addActivity(RecentActivity activity) {
    _recentActivities.insert(0, activity);

    // Keep only last 10 activities
    if (_recentActivities.length > 10) {
      _recentActivities = _recentActivities.take(10).toList();
    }

    safeNotifyListeners();
  }

  /// Clear all activities
  void clearActivities() {
    _recentActivities.clear();
    safeNotifyListeners();
  }

  /// Update stats
  void updateStats(Map<String, dynamic> newStats) {
    _stats.addAll(newStats);
    safeNotifyListeners();
  }
}

/// Dashboard Item Model
class DashboardItem {
  final String id;
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final double trend;

  const DashboardItem({
    required this.id,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
  });
}

/// Recent Activity Model
class RecentActivity {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final ActivityType type;

  const RecentActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
  });
}

/// Activity Type Enum
enum ActivityType {
  user,
  order,
  payment,
  system,
  notification,
}
