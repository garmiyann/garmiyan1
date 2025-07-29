import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/profile_data.dart';

class ManageSubscriptionScreen extends StatefulWidget {
  final VoidCallback? onCancelComplete;

  const ManageSubscriptionScreen({super.key, this.onCancelComplete});

  @override
  State<ManageSubscriptionScreen> createState() =>
      _ManageSubscriptionScreenState();
}

class _ManageSubscriptionScreenState extends State<ManageSubscriptionScreen> {
  bool autoRenew = true;
  String selectedPlan = 'monthly';

  final List<Map<String, dynamic>> subscriptionPlans = [
    {
      'id': 'monthly',
      'title': 'Monthly Plan',
      'price': '\$4.99',
      'period': 'per month',
      'savings': null,
      'description': 'Billed monthly, cancel anytime',
    },
    {
      'id': 'yearly',
      'title': 'Yearly Plan',
      'price': '\$49.99',
      'period': 'per year',
      'savings': 'Save 17%',
      'description': 'Billed annually, best value',
    },
  ];

  final List<String> benefits = [
    'No Ads',
    'Larger Uploads (4 GB)',
    'Faster Downloads',
    'Exclusive Stickers',
    'Voice-to-Text for Voice Messages',
    'Unique Reaction Emojis',
    'Advanced Chat Management',
    'Premium Support',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Manage Subscription',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Current Status Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.diamond, color: Colors.blue, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Telegram Premium',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'ACTIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Next billing: August 15, 2025',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Current plan: Monthly (\$4.99/month)',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Auto-Renewal Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.autorenew, color: Colors.blue),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Auto-Renewal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Automatically renew subscription',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: autoRenew,
                  onChanged: (value) {
                    setState(() {
                      autoRenew = value;
                    });
                  },
                  activeColor: Colors.blue,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Change Plan Section
          const Text(
            'CHANGE PLAN',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),

          // Subscription Plans
          ...subscriptionPlans
              .map((plan) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selectedPlan == plan['id']
                            ? Colors.blue
                            : Colors.grey.shade300,
                        width: selectedPlan == plan['id'] ? 2 : 1,
                      ),
                    ),
                    child: RadioListTile<String>(
                      value: plan['id'],
                      groupValue: selectedPlan,
                      onChanged: (value) {
                        setState(() {
                          selectedPlan = value!;
                        });
                      },
                      title: Row(
                        children: [
                          Text(
                            plan['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (plan['savings'] != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                plan['savings'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${plan['price']} ${plan['period']}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            plan['description'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      activeColor: Colors.blue,
                    ),
                  ))
              .toList(),

          const SizedBox(height: 24),

          // Benefits Section
          const Text(
            'PREMIUM BENEFITS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: benefits
                  .map((benefit) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              benefit,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),

          const SizedBox(height: 32),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _showCancelDialog();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Cancel Subscription',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _updateSubscription();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Update Plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Subscription'),
          content: const Text(
            'Are you sure you want to cancel your Telegram Premium subscription? '
            'You will lose access to premium features at the end of your current billing period.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Keep Subscription'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _cancelSubscription();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Cancel Subscription'),
            ),
          ],
        );
      },
    );
  }

  void _cancelSubscription() {
    // Get the ProfileData and deactivate premium
    try {
      final profileData = Provider.of<ProfileData>(context, listen: false);
      profileData.deactivatePremium();
    } catch (e) {
      // Provider error - continue without state update
      debugPrint('Provider error: $e');
    }

    // Call callback if provided
    if (widget.onCancelComplete != null) {
      widget.onCancelComplete!();
    }

    Navigator.of(context).pop(); // Go back to settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Subscription cancelled. You will keep premium features until August 15, 2025.'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _updateSubscription() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Subscription updated to ${selectedPlan == 'monthly' ? 'Monthly' : 'Yearly'} plan!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
