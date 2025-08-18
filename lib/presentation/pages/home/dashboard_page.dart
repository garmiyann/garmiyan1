import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Professional Dashboard Page
///
/// Modern dashboard following Material Design 3 principles with
/// professional layout and enterprise-level organization.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: AppTextStyles.headlineMedium,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(),

            const SizedBox(height: AppDimensions.spacingXLarge),

            // Quick Actions Grid
            _buildQuickActionsGrid(),

            const SizedBox(height: AppDimensions.spacingXLarge),

            // Statistics Cards
            _buildStatisticsSection(),

            const SizedBox(height: AppDimensions.spacingXLarge),

            // Recent Activity
            _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good Morning! 👋',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSmall),
          Text(
            'Welcome to your professional dashboard',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.onPrimary.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    final actions = [
      _QuickAction(
        icon: Icons.person_add,
        title: 'Add Contact',
        color: AppColors.success,
      ),
      _QuickAction(
        icon: Icons.message,
        title: 'Messages',
        color: AppColors.secondary,
      ),
      _QuickAction(
        icon: Icons.shopping_cart,
        title: 'Shopping',
        color: AppColors.warning,
      ),
      _QuickAction(
        icon: Icons.settings,
        title: 'Settings',
        color: AppColors.error,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMedium),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppDimensions.spacingMedium,
            mainAxisSpacing: AppDimensions.spacingMedium,
            childAspectRatio: 1.5,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return _buildQuickActionCard(action);
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(_QuickAction action) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _handleQuickAction(action.title),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: action.color.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: Icon(
                  action.icon,
                  color: action.color,
                  size: 32,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSmall),
              Text(
                action.title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistics',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMedium),
        Row(
          children: [
            Expanded(child: _buildStatCard('Messages', '145', Icons.message)),
            const SizedBox(width: AppDimensions.spacingMedium),
            Expanded(child: _buildStatCard('Contacts', '28', Icons.contacts)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(height: AppDimensions.spacingSmall),
            Text(
              value,
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMedium),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => Divider(
              color: AppColors.textSecondary.withOpacity(0.2),
            ),
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.notifications,
                    color: AppColors.primary,
                  ),
                ),
                title: Text(
                  'Activity ${index + 1}',
                  style: AppTextStyles.bodyLarge,
                ),
                subtitle: Text(
                  '2 hours ago',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _handleQuickAction(String action) {
    // Handle quick action navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action clicked'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String title;
  final Color color;

  _QuickAction({
    required this.icon,
    required this.title,
    required this.color,
  });
}
