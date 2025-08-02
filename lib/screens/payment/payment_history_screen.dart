import 'package:flutter/material.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Payment History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(child: _filterTab('All', true)),
                Expanded(child: _filterTab('Income', false)),
                Expanded(child: _filterTab('Expense', false)),
                Expanded(child: _filterTab('Transfer', false)),
              ],
            ),
          ),
          // Transactions list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _getAllTransactions().length,
              itemBuilder: (context, index) {
                final transaction = _getAllTransactions()[index];
                return _transactionCard(transaction);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterTab(String title, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.grey[600],
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _transactionCard(Map<String, dynamic> transaction) {
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
            color: (transaction['color'] as Color).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            transaction['icon'] as IconData,
            color: transaction['color'] as Color,
            size: 24,
          ),
        ),
        title: Text(
          transaction['title'] as String,
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
              transaction['description'] as String,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              transaction['date'] as String,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              transaction['amount'] as String,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: (transaction['amount'] as String).startsWith('+')
                    ? Colors.green
                    : Colors.red,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: transaction['status'] == 'Completed'
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                transaction['status'] as String,
                style: TextStyle(
                  fontSize: 10,
                  color: transaction['status'] == 'Completed'
                      ? Colors.green
                      : Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getAllTransactions() {
    return [
      {
        'title': 'Coffee Shop Payment',
        'description': 'Starbucks Downtown',
        'date': 'Today, 2:30 PM',
        'amount': '-\$4.50',
        'status': 'Completed',
        'icon': Icons.local_cafe,
        'color': Colors.orange,
      },
      {
        'title': 'Salary Deposit',
        'description': 'Monthly salary from XYZ Corp',
        'date': 'Yesterday, 9:00 AM',
        'amount': '+\$2,500.00',
        'status': 'Completed',
        'icon': Icons.work,
        'color': Colors.green,
      },
      {
        'title': 'Transfer to John Doe',
        'description': 'Split dinner bill',
        'date': 'Jan 28, 4:15 PM',
        'amount': '-\$50.00',
        'status': 'Completed',
        'icon': Icons.person,
        'color': Colors.blue,
      },
      {
        'title': 'Online Shopping',
        'description': 'Amazon purchase',
        'date': 'Jan 27, 11:20 AM',
        'amount': '-\$89.99',
        'status': 'Pending',
        'icon': Icons.shopping_bag,
        'color': Colors.purple,
      },
      {
        'title': 'Uber Ride',
        'description': 'Trip to Airport',
        'date': 'Jan 26, 7:45 AM',
        'amount': '-\$25.30',
        'status': 'Completed',
        'icon': Icons.local_taxi,
        'color': Colors.black,
      },
    ];
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Transactions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Date Range'),
              trailing: const Icon(Icons.date_range),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Amount Range'),
              trailing: const Icon(Icons.attach_money),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Category'),
              trailing: const Icon(Icons.category),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
