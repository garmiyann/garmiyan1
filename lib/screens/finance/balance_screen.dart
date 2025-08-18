import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  bool isLoading = true;
  Map<String, dynamic>? userData;
  double totalBalance = 0.0;
  double totalEarnings = 0.0;
  double pendingAmount = 0.0;

  final List<Map<String, dynamic>> recentTransactions = [
    {
      'type': 'earning',
      'title': 'Video Views Reward',
      'amount': 15.50,
      'date': '2025-07-28',
      'icon': Icons.play_circle_filled,
      'status': 'completed'
    },
    {
      'type': 'earning',
      'title': 'Live Stream Gifts',
      'amount': 25.00,
      'date': '2025-07-27',
      'icon': Icons.card_giftcard,
      'status': 'completed'
    },
    {
      'type': 'withdrawal',
      'title': 'Bank Transfer',
      'amount': -50.00,
      'date': '2025-07-26',
      'icon': Icons.account_balance,
      'status': 'pending'
    },
    {
      'type': 'earning',
      'title': 'Creator Fund',
      'amount': 35.75,
      'date': '2025-07-25',
      'icon': Icons.account_balance_wallet,
      'status': 'completed'
    },
    {
      'type': 'earning',
      'title': 'Brand Partnership',
      'amount': 150.00,
      'date': '2025-07-24',
      'icon': Icons.business,
      'status': 'completed'
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchUserBalance();
  }

  Future<void> fetchUserBalance() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        final doc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (doc.exists) {
          setState(() {
            userData = doc.data();
            totalBalance = (userData?['balance'] ?? 176.25).toDouble();
            totalEarnings = (userData?['totalEarnings'] ?? 892.50).toDouble();
            pendingAmount = (userData?['pendingAmount'] ?? 50.00).toDouble();
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          // Set default values if Firebase fails
          totalBalance = 176.25;
          totalEarnings = 892.50;
          pendingAmount = 50.00;
          isLoading = false;
        });
      }
    }
  }

  void _showWithdrawDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[800] : Colors.white,
          title: Text(
            'Withdraw Funds',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Available Balance: \$${totalBalance.toStringAsFixed(2)}',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: 'Withdrawal Amount',
                  labelStyle: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                  prefixText: '\$',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: 'Bank Account',
                  labelStyle: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Withdrawal request submitted successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Balance & Earnings',
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Cards
            Row(
              children: [
                Expanded(
                  child: _BalanceCard(
                    title: 'Total Balance',
                    amount: totalBalance,
                    icon: Icons.account_balance_wallet,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _BalanceCard(
                    title: 'Total Earnings',
                    amount: totalEarnings,
                    icon: Icons.trending_up,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Pending Amount Card
            _BalanceCard(
              title: 'Pending Amount',
              amount: pendingAmount,
              icon: Icons.schedule,
              color: Colors.orange,
              subtitle: 'Processing withdrawal',
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showWithdrawDialog,
                    icon: const Icon(Icons.account_balance),
                    label: const Text('Withdraw'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Navigate to earnings details
                    },
                    icon: const Icon(Icons.analytics),
                    label: const Text('Analytics'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Recent Transactions
            Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? Colors.black : Colors.black)
                        .withOpacity(isDark ? 0.3 : 0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentTransactions.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                ),
                itemBuilder: (context, index) {
                  final transaction = recentTransactions[index];
                  return _TransactionTile(transaction: transaction);
                },
              ),
            ),

            const SizedBox(height: 24),

            // Earning Sources
            const Text(
              'Earning Sources',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _EarningSourceItem(
                    icon: Icons.play_circle_filled,
                    title: 'Video Views',
                    amount: 245.30,
                    percentage: 27.4,
                  ),
                  const Divider(),
                  _EarningSourceItem(
                    icon: Icons.card_giftcard,
                    title: 'Live Gifts',
                    amount: 189.60,
                    percentage: 21.2,
                  ),
                  const Divider(),
                  _EarningSourceItem(
                    icon: Icons.business,
                    title: 'Partnerships',
                    amount: 320.00,
                    percentage: 35.8,
                  ),
                  const Divider(),
                  _EarningSourceItem(
                    icon: Icons.account_balance_wallet,
                    title: 'Creator Fund',
                    amount: 137.60,
                    percentage: 15.4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const _BalanceCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.black)
                .withOpacity(isDark ? 0.3 : 0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              if (subtitle != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Processing',
                    style: TextStyle(
                      fontSize: 10,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? Colors.grey[500] : Colors.grey[500],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEarning = transaction['type'] == 'earning';
    final amount = transaction['amount'] as double;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (isEarning ? Colors.green : Colors.red).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          transaction['icon'],
          color: isEarning ? Colors.green : Colors.red,
          size: 20,
        ),
      ),
      title: Text(
        transaction['title'],
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction['date'],
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          if (transaction['status'] == 'pending')
            Text(
              'Pending',
              style: TextStyle(
                fontSize: 10,
                color: Colors.orange[600],
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
      trailing: Text(
        '${isEarning ? '+' : ''}\$${amount.abs().toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isEarning ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}

class _EarningSourceItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final double amount;
  final double percentage;

  const _EarningSourceItem({
    required this.icon,
    required this.title,
    required this.amount,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(1)}% of total earnings',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
