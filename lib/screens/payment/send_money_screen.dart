import 'package:flutter/material.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({Key? key}) : super(key: key);

  @override
  _SendMoneyScreenState createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  String selectedRecipient = '';
  final List<Map<String, dynamic>> _recentContacts = [
    {
      'name': 'John Doe',
      'email': 'john@example.com',
      'avatar': 'https://i.pravatar.cc/150?img=1',
      'isFrequent': true,
    },
    {
      'name': 'Sarah Smith',
      'email': 'sarah@example.com',
      'avatar': 'https://i.pravatar.cc/150?img=2',
      'isFrequent': true,
    },
    {
      'name': 'Mike Johnson',
      'email': 'mike@example.com',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'isFrequent': false,
    },
    {
      'name': 'Emily Davis',
      'email': 'emily@example.com',
      'avatar': 'https://i.pravatar.cc/150?img=4',
      'isFrequent': false,
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
          'Send Money',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => _scanQRCode(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search contacts or enter email/phone',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            // Quick actions
            Row(
              children: [
                Expanded(
                  child: _quickActionButton(
                    icon: Icons.contacts,
                    label: 'Contacts',
                    onTap: () => _selectFromContacts(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _quickActionButton(
                    icon: Icons.phone,
                    label: 'Phone Number',
                    onTap: () => _enterPhoneNumber(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _quickActionButton(
                    icon: Icons.email,
                    label: 'Email',
                    onTap: () => _enterEmail(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Recent & Frequent contacts
            const Text(
              'Recent & Frequent',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _recentContacts.length,
                itemBuilder: (context, index) {
                  final contact = _recentContacts[index];
                  return _contactAvatar(contact);
                },
              ),
            ),

            const SizedBox(height: 24),

            if (selectedRecipient.isNotEmpty) ...[
              // Selected recipient
              Container(
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
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: Text(
                        selectedRecipient[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedRecipient,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Sending to this contact',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectedRecipient = '';
                        });
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Amount input
              const Text(
                'Amount',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: '0.00',
                  prefixText: '\$ ',
                  prefixStyle: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              // Quick amount buttons
              Row(
                children: [
                  Expanded(child: _amountButton('\$10')),
                  const SizedBox(width: 8),
                  Expanded(child: _amountButton('\$25')),
                  const SizedBox(width: 8),
                  Expanded(child: _amountButton('\$50')),
                  const SizedBox(width: 8),
                  Expanded(child: _amountButton('\$100')),
                ],
              ),

              const SizedBox(height: 24),

              // Note
              const Text(
                'Add a note (optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'What\'s this for?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 32),

              // Send button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _sendMoney(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Send \$${_amountController.text.isEmpty ? '0.00' : _amountController.text}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _quickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
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
          children: [
            Icon(icon, color: Colors.blue, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactAvatar(Map<String, dynamic> contact) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRecipient = contact['name'] as String;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(contact['avatar'] as String),
                ),
                if (contact['isFrequent'] as bool)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              contact['name'] as String,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _amountButton(String amount) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _amountController.text = amount.substring(1); // Remove $ sign
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          amount,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _selectFromContacts() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contact picker coming soon!')),
    );
  }

  void _enterPhoneNumber() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Phone number input coming soon!')),
    );
  }

  void _enterEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email input coming soon!')),
    );
  }

  void _scanQRCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('QR code scanner coming soon!')),
    );
  }

  void _sendMoney() {
    if (selectedRecipient.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select recipient and enter amount')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Transfer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('To: $selectedRecipient'),
            Text('Amount: \$${_amountController.text}'),
            if (_noteController.text.isNotEmpty)
              Text('Note: ${_noteController.text}'),
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Successfully sent \$${_amountController.text} to $selectedRecipient'),
                ),
              );
            },
            child: const Text('Send Money'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
