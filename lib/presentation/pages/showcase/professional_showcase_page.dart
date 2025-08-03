import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../widgets/widgets.dart';
import '../../screens/showcase/data_visualization_showcase_screen.dart';

/// Professional Architecture Showcase
///
/// Demonstrates all professional components working together
/// in a real-world enterprise application scenario.
class ProfessionalShowcasePage extends StatefulWidget {
  const ProfessionalShowcasePage({super.key});

  @override
  State<ProfessionalShowcasePage> createState() =>
      _ProfessionalShowcasePageState();
}

class _ProfessionalShowcasePageState extends State<ProfessionalShowcasePage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  int _currentNavIndex = 0;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Professional Showcase',
          style: AppTextStyles.headlineMedium,
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: _showNotificationDemo,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Professional Header Section
              _buildHeaderSection(),

              const SizedBox(height: AppDimensions.spacingXLarge),

              // Professional Form Section
              _buildFormSection(),

              const SizedBox(height: AppDimensions.spacingXLarge),

              // Professional Button Showcase
              _buildButtonSection(),

              const SizedBox(height: AppDimensions.spacingXLarge),

              // Professional Cards Section
              _buildCardsSection(),

              const SizedBox(height: AppDimensions.spacingXLarge),

              // Professional Statistics
              _buildStatisticsSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildProfessionalBottomNav(),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.architecture,
            size: 64,
            color: AppColors.onPrimary,
          ),
          const SizedBox(height: AppDimensions.spacingMedium),
          Text(
            '🏗️ Professional Architecture',
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingSmall),
          Text(
            'Enterprise-level Flutter components\nwith Material Design 3',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.onPrimary.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Professional Form Components',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMedium),

        // Email Field
        ProfessionalTextField(
          controller: _emailController,
          label: 'Email Address',
          hint: 'Enter your professional email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
          validator: Validators.email,
        ),

        const SizedBox(height: AppDimensions.spacingMedium),

        // Password Field
        ProfessionalTextField(
          controller: _passwordController,
          label: 'Password',
          hint: 'Enter secure password',
          obscureText: true,
          prefixIcon: Icons.lock_outlined,
          validator: Validators.password,
        ),

        const SizedBox(height: AppDimensions.spacingMedium),

        // Phone Field
        ProfessionalTextField(
          controller: _phoneController,
          label: 'Phone Number',
          hint: 'Enter your phone number',
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone_outlined,
        ),
      ],
    );
  }

  Widget _buildButtonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Professional Button Components',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMedium),

        // Primary Button
        ProfessionalButton(
          text: 'Submit Form',
          onPressed: _handleSubmit,
          type: ButtonType.primary,
          size: ButtonSize.large,
          icon: Icons.send,
          isLoading: _isLoading,
          isFullWidth: true,
          enableHaptics: true,
          tooltip: 'Submit the form with validation',
        ),

        const SizedBox(height: AppDimensions.spacingMedium),

        // Button Row
        Row(
          children: [
            Expanded(
              child: ProfessionalButton(
                text: 'Secondary',
                onPressed: _showSecondaryDemo,
                type: ButtonType.secondary,
                size: ButtonSize.medium,
                icon: Icons.star,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingMedium),
            Expanded(
              child: ProfessionalButton(
                text: 'Text Button',
                onPressed: _showTextDemo,
                type: ButtonType.text,
                size: ButtonSize.medium,
                icon: Icons.text_fields,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.spacingMedium),

        // Icon buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ProfessionalButton(
              text: '',
              onPressed: _showIconDemo,
              type: ButtonType.icon,
              size: ButtonSize.medium,
              icon: Icons.favorite,
              customColor: AppColors.error,
              tooltip: 'Like this post',
            ),
            ProfessionalButton(
              text: '',
              onPressed: _showIconDemo,
              type: ButtonType.icon,
              size: ButtonSize.medium,
              icon: Icons.share,
              customColor: AppColors.secondary,
              tooltip: 'Share content',
            ),
            ProfessionalButton(
              text: '',
              onPressed: _showIconDemo,
              type: ButtonType.icon,
              size: ButtonSize.medium,
              icon: Icons.bookmark,
              customColor: AppColors.warning,
              tooltip: 'Bookmark for later',
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.spacingLarge),

        // Data Visualization Showcase Button
        SizedBox(
          width: double.infinity,
          child: ProfessionalButton(
            text: 'Data Visualization Showcase',
            onPressed: _navigateToDataVisualization,
            type: ButtonType.primary,
            size: ButtonSize.large,
            icon: Icons.analytics,
            customColor: AppColors.accent,
            tooltip: 'View professional data visualization components',
          ),
        ),
      ],
    );
  }

  Widget _buildCardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Professional Card Components',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMedium),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: AppDimensions.spacingMedium,
          mainAxisSpacing: AppDimensions.spacingMedium,
          childAspectRatio: 1.2,
          children: [
            _buildFeatureCard(
                'Clean Architecture', Icons.architecture, AppColors.primary),
            _buildFeatureCard('Material Design 3', Icons.design_services,
                AppColors.secondary),
            _buildFeatureCard(
                'Professional Forms', Icons.assignment, AppColors.success),
            _buildFeatureCard(
                'Enterprise Ready', Icons.business, AppColors.warning),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSmall),
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Architecture Statistics',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMedium),
        Row(
          children: [
            Expanded(child: _buildStatCard('Components', '50+', Icons.widgets)),
            const SizedBox(width: AppDimensions.spacingMedium),
            Expanded(child: _buildStatCard('Domains', '7', Icons.domain)),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingMedium),
        Row(
          children: [
            Expanded(child: _buildStatCard('Routes', '25+', Icons.route)),
            const SizedBox(width: AppDimensions.spacingMedium),
            Expanded(child: _buildStatCard('Quality', '100%', Icons.verified)),
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

  Widget _buildProfessionalBottomNav() {
    return ProfessionalBottomNav(
      currentIndex: _currentNavIndex,
      onTap: (index) {
        setState(() {
          _currentNavIndex = index;
        });
      },
      items: const [
        ProfessionalNavItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: 'Home',
        ),
        ProfessionalNavItem(
          icon: Icons.explore_outlined,
          activeIcon: Icons.explore,
          label: 'Explore',
          badge: '5',
        ),
        ProfessionalNavItem(
          icon: Icons.favorite_outline,
          activeIcon: Icons.favorite,
          label: 'Favorites',
        ),
        ProfessionalNavItem(
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          label: 'Profile',
        ),
      ],
    );
  }

  // Event Handlers
  void _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Form submitted successfully! 🎉'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
          ),
        );
      }
    }
  }

  void _navigateToDataVisualization() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DataVisualizationShowcaseScreen(),
      ),
    );
  }

  void _showSecondaryDemo() {
    _showDemoMessage('Secondary button clicked! 👍');
  }

  void _showTextDemo() {
    _showDemoMessage('Text button clicked! 📝');
  }

  void _showIconDemo() {
    _showDemoMessage('Icon button clicked! ⭐');
  }

  void _showNotificationDemo() {
    _showDemoMessage('Notification clicked! 🔔');
  }

  void _showDemoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
