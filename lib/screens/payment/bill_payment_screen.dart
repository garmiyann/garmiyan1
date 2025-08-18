import 'package:flutter/material.dart';

class BillPaymentScreen extends StatefulWidget {
  const BillPaymentScreen({Key? key}) : super(key: key);

  @override
  _BillPaymentScreenState createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  final List<Map<String, dynamic>> _billCategories = [
    {
      'title': 'Utilities',
      'icon': Icons.electrical_services,
      'color': Colors.orange,
      'bills': ['Electricity', 'Water', 'Gas', 'Internet'],
    },
    {
      'title': 'Mobile & Phone',
      'icon': Icons.phone_android,
      'color': Colors.green,
      'bills': ['Mobile Postpaid', 'Mobile Prepaid', 'Landline'],
    },
    {
      'title': 'Entertainment',
      'icon': Icons.tv,
      'color': Colors.purple,
      'bills': ['Netflix', 'Spotify', 'Disney+', 'Cable TV'],
    },
    {
      'title': 'Insurance',
      'icon': Icons.security,
      'color': Colors.blue,
      'bills': ['Health Insurance', 'Car Insurance', 'Life Insurance'],
    },
    {
      'title': 'Loans & Credit',
      'icon': Icons.credit_card,
      'color': Colors.red,
      'bills': ['Credit Card', 'Home Loan', 'Personal Loan'],
    },
    {
      'title': 'Education',
      'icon': Icons.school,
      'color': Colors.teal,
      'bills': ['School Fees', 'University', 'Online Courses'],
    },
  ];

  final List<Map<String, dynamic>> _recentBills = [
    {
      'title': 'Electricity Bill',
      'provider': 'City Power Co.',
      'amount': '\$125.50',
      'dueDate': 'Due in 3 days',
      'icon': Icons.electrical_services,
      'color': Colors.orange,
      'status': 'pending',
    },
    {
      'title': 'Mobile Postpaid',
      'provider': 'Verizon',
      'amount': '\$89.99',
      'dueDate': 'Due in 7 days',
      'icon': Icons.phone_android,
      'color': Colors.green,
      'status': 'pending',
    },
    {
      'title': 'Internet Bill',
      'provider': 'Xfinity',
      'amount': '\$65.00',
      'dueDate': 'Paid',
      'icon': Icons.wifi,
      'color': Colors.blue,
      'status': 'paid',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Bill Payment',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showBillHistory(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recent & Upcoming Bills
            const Text(
              'Recent & Upcoming Bills',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentBills.length,
              itemBuilder: (context, index) {
                final bill = _recentBills[index];
                return _buildRecentBillCard(bill);
              },
            ),

            const SizedBox(height: 24),

            // Bill Categories
            const Text(
              'Bill Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemCount: _billCategories.length,
              itemBuilder: (context, index) {
                final category = _billCategories[index];
                return _buildCategoryCard(category);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentBillCard(Map<String, dynamic> bill) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (bill['color'] as Color).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            bill['icon'] as IconData,
            color: bill['color'] as Color,
            size: 24,
          ),
        ),
        title: Text(
          bill['title'] as String,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              bill['provider'] as String,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              bill['dueDate'] as String,
              style: TextStyle(
                fontSize: 11,
                color: bill['status'] == 'paid' ? Colors.green : Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              bill['amount'] as String,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (bill['status'] == 'pending')
              ElevatedButton(
                onPressed: () => _payBill(bill),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(60, 28),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text(
                  'Pay',
                  style: TextStyle(fontSize: 12),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Paid',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () => _openCategory(category),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (category['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                category['icon'] as IconData,
                color: category['color'] as Color,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              category['title'] as String,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '${(category['bills'] as List).length} services',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _payBill(Map<String, dynamic> bill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pay ${bill['title']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Provider: ${bill['provider']}'),
            Text('Amount: ${bill['amount']}'),
            const SizedBox(height: 16),
            const Text('Select payment method:'),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Wallet Balance'),
              subtitle: const Text('\$2,458.50 available'),
              trailing: Radio(
                value: true,
                groupValue: true,
                onChanged: (value) {},
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${bill['title']} paid successfully!'),
                ),
              );
            },
            child: const Text('Pay Now'),
          ),
        ],
      ),
    );
  }

  void _openCategory(Map<String, dynamic> category) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (category['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    category['icon'] as IconData,
                    color: category['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  category['title'] as String,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...((category['bills'] as List<String>).map((bill) => ListTile(
                  title: Text(bill),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$bill payment coming soon!')),
                    );
                  },
                ))),
          ],
        ),
      ),
    );
  }

  void _showBillHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bill payment history coming soon!')),
    );
  }
}
