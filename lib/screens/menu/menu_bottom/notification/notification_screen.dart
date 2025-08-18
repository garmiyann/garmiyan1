import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'New Message',
      'subtitle': 'You have received a new message from John',
      'time': '2 min ago',
      'icon': Icons.message,
      'color': Color(0xFF2196F3),
      'isRead': false,
    },
    {
      'title': 'Project Update',
      'subtitle': 'Your project "Mobile App" has been updated',
      'time': '1 hour ago',
      'icon': Icons.update,
      'color': Color(0xFF4CAF50),
      'isRead': false,
    },
    {
      'title': 'Payment Received',
      'subtitle': 'You received a payment of \$100',
      'time': '3 hours ago',
      'icon': Icons.payment,
      'color': Color(0xFFFF9800),
      'isRead': true,
    },
    {
      'title': 'System Update',
      'subtitle': 'New features available in your app',
      'time': '1 day ago',
      'icon': Icons.system_update,
      'color': Color(0xFF9C27B0),
      'isRead': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Mark all as read
              setState(() {
                for (var notification in _notifications) {
                  notification['isRead'] = true;
                }
              });
            },
            icon: const Icon(Icons.done_all, color: Colors.white),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: notification['isRead']
                  ? Colors.white.withOpacity(0.05)
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: notification['isRead']
                    ? Colors.white.withOpacity(0.1)
                    : notification['color'].withOpacity(0.3),
                width: 1,
              ),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: notification['color'].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  notification['icon'],
                  color: notification['color'],
                  size: 24,
                ),
              ),
              title: Text(
                notification['title'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: notification['isRead']
                      ? FontWeight.normal
                      : FontWeight.bold,
                ),
              ),
              subtitle: Text(
                notification['subtitle'],
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              trailing: Text(
                notification['time'],
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
              onTap: () {
                setState(() {
                  notification['isRead'] = true;
                });
              },
            ),
          );
        },
      ),
    );
  }
}
