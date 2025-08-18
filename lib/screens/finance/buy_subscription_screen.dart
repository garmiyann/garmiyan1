import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/profile_data.dart';

class BuySubscriptionScreen extends StatefulWidget {
  final VoidCallback? onPurchaseComplete;

  const BuySubscriptionScreen({super.key, this.onPurchaseComplete});

  @override
  State<BuySubscriptionScreen> createState() => _BuySubscriptionScreenState();
}

class _BuySubscriptionScreenState extends State<BuySubscriptionScreen>
    with TickerProviderStateMixin {
  String selectedPlan = 'yearly'; // Default to yearly for better value
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> subscriptionPlans = [
    {
      'id': 'monthly',
      'title': 'Starter',
      'subtitle': 'Monthly Plan',
      'price': '4.99',
      'period': '/mo',
      'originalPrice': null,
      'savings': null,
      'description': 'Try premium features',
      'popular': false,
      'color': const Color(0xFF6C5CE7),
      'gradient': [const Color(0xFF6C5CE7), const Color(0xFFA29BFE)],
      'features': ['No Ads', 'Fast Downloads', '2GB Storage'],
    },
    {
      'id': 'yearly',
      'title': 'Professional',
      'subtitle': 'Annual Plan',
      'price': '49.99',
      'period': '/yr',
      'originalPrice': '59.88',
      'savings': '17% OFF',
      'description': 'Best value option',
      'popular': true,
      'color': const Color(0xFF00B894),
      'gradient': [const Color(0xFF00B894), const Color(0xFF00CEC9)],
      'features': ['Everything in Starter', '10GB Storage', 'Priority Support'],
    },
    {
      'id': 'lifetime',
      'title': 'Enterprise',
      'subtitle': 'One-time Payment',
      'price': '149.99',
      'period': 'forever',
      'originalPrice': '199.99',
      'savings': '25% OFF',
      'description': 'Pay once, use forever',
      'popular': false,
      'color': const Color(0xFFE17055),
      'gradient': [const Color(0xFFE17055), const Color(0xFFFD79A8)],
      'features': ['Everything in Pro', 'Unlimited Storage', 'Custom Features'],
    },
  ];

  final List<Map<String, dynamic>> premiumFeatures = [
    {
      'icon': Icons.block,
      'title': 'Ad-Free',
      'description': 'Clean experience',
      'color': const Color(0xFF6C5CE7),
    },
    {
      'icon': Icons.cloud_sync,
      'title': 'Cloud Sync',
      'description': 'Instant backup',
      'color': const Color(0xFF00B894),
    },
    {
      'icon': Icons.speed,
      'title': 'Fast Speed',
      'description': 'Premium servers',
      'color': const Color(0xFFE17055),
    },
    {
      'icon': Icons.security,
      'title': 'Security',
      'description': 'End-to-end encryption',
      'color': const Color(0xFF74B9FF),
    },
    {
      'icon': Icons.support_agent,
      'title': 'Support',
      'description': '24/7 assistance',
      'color': const Color(0xFFFD79A8),
    },
    {
      'icon': Icons.new_releases,
      'title': 'Early Access',
      'description': 'Latest features first',
      'color': const Color(0xFFFFCB74),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3F4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Color(0xFF5F6368), size: 18),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text(
          'Upgrade to Premium',
          style: TextStyle(
            color: Color(0xFF202124),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Hero Section
                  SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.workspace_premium,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Unlock Premium Features',
                            style: TextStyle(
                              color: Color(0xFF202124),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Get the most out of your experience with our premium plans',
                            style: TextStyle(
                              color: const Color(0xFF5F6368),
                              fontSize: 13,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Features Grid
                  Text(
                    'WHAT\'S INCLUDED',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF5F6368),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: premiumFeatures.length,
                    itemBuilder: (context, index) {
                      final feature = premiumFeatures[index];
                      return _buildFeatureCard(feature);
                    },
                  ),

                  const SizedBox(height: 24),

                  // Subscription Plans
                  Text(
                    'CHOOSE YOUR PLAN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF5F6368),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...subscriptionPlans
                      .map((plan) => _buildPlanCard(plan))
                      .toList(),

                  const SizedBox(height: 80),
                ],
              ),
            ),

            // Bottom Purchase Section
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> feature) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE8EAED),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: feature['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              feature['icon'],
              color: feature['color'],
              size: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            feature['title'],
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF202124),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            feature['description'],
            style: TextStyle(
              fontSize: 9,
              color: const Color(0xFF5F6368),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    final isSelected = selectedPlan == plan['id'];
    final features = plan['features'] as List<String>;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = plan['id'];
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? plan['color'] : const Color(0xFFE8EAED),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? plan['color'].withOpacity(0.1)
                  : Colors.black.withOpacity(0.02),
              spreadRadius: 0,
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                plan['title'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF202124),
                                ),
                              ),
                              if (plan['savings'] != null) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00B894),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    plan['savings'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            plan['subtitle'],
                            style: TextStyle(
                              fontSize: 11,
                              color: const Color(0xFF5F6368),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? plan['color']
                            : const Color(0xFFE8EAED),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isSelected ? Icons.check : Icons.circle_outlined,
                        color:
                            isSelected ? Colors.white : const Color(0xFF5F6368),
                        size: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '\$${plan['price']}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF202124),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      plan['period'],
                      style: TextStyle(
                        fontSize: 11,
                        color: const Color(0xFF5F6368),
                      ),
                    ),
                    if (plan['originalPrice'] != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '\$${plan['originalPrice']}',
                        style: TextStyle(
                          fontSize: 10,
                          color: const Color(0xFF9AA0A6),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  plan['description'],
                  style: TextStyle(
                    fontSize: 11,
                    color: const Color(0xFF5F6368),
                  ),
                ),
                const SizedBox(height: 8),
                ...features
                    .map((feature) => Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check,
                                size: 12,
                                color: plan['color'],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                feature,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF5F6368),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ],
            ),
            if (plan['popular'] == true)
              Positioned(
                top: -8,
                right: -8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00B894),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00B894).withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'POPULAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    final selectedPlanData =
        subscriptionPlans.firstWhere((p) => p['id'] == selectedPlan);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _purchaseSubscription,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedPlanData['color'],
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Get ${selectedPlanData['title']} Plan',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cancel anytime • Secure checkout • 30-day guarantee',
              style: TextStyle(
                fontSize: 10,
                color: const Color(0xFF5F6368),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _purchaseSubscription() {
    final selectedPlanData =
        subscriptionPlans.firstWhere((p) => p['id'] == selectedPlan);

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: selectedPlanData['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.workspace_premium,
                    color: selectedPlanData['color'],
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Confirm Purchase',
                  style: TextStyle(
                    color: Color(0xFF202124),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      color: Color(0xFF5F6368),
                      fontSize: 13,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: 'Upgrade to '),
                      TextSpan(
                        text: selectedPlanData['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: selectedPlanData['color'],
                        ),
                      ),
                      const TextSpan(text: ' plan for '),
                      TextSpan(
                        text: '\$${selectedPlanData['price']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF202124),
                        ),
                      ),
                      TextSpan(text: selectedPlanData['period']),
                      const TextSpan(text: '?'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFF1F3F4),
                            foregroundColor: const Color(0xFF5F6368),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _completePurchase();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedPlanData['color'],
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Purchase',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _completePurchase() {
    // Get the ProfileData and activate premium
    try {
      final profileData = Provider.of<ProfileData>(context, listen: false);
      profileData.activatePremium();
    } catch (e) {
      // Provider error - continue without state update
      debugPrint('Provider error: $e');
    }

    // Call callback if provided
    if (widget.onPurchaseComplete != null) {
      widget.onPurchaseComplete!();
    }

    Navigator.of(context).pop(); // Go back to settings

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Premium activated! Welcome aboard.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF00B894),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
