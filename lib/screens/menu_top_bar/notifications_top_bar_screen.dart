import 'package:flutter/material.dart';

class NotificationsTopBarScreen extends StatefulWidget {
  const NotificationsTopBarScreen({super.key});

  @override
  State<NotificationsTopBarScreen> createState() => _NotificationsTopBarScreenState();
}

class _NotificationsTopBarScreenState extends State<NotificationsTopBarScreen> {
  bool _showOnlyUnread = false;
  
  final List<NotificationItem> _notifications = [
    NotificationItem(
      type: NotificationType.like,
      title: 'John liked your photo',
      message: 'Your photo got a new like from John Doe',
      time: '2 minutes ago',
      isRead: false,
      avatar: 'J',
    ),
    NotificationItem(
      type: NotificationType.comment,
      title: 'New comment on your post',
      message: 'Sarah: "Great content! Thanks for sharing"',
      time: '1 hour ago',
      isRead: false,
      avatar: 'S',
    ),
    NotificationItem(
      type: NotificationType.follow,
      title: 'Mike started following you',
      message: 'Mike Chen is now following your account',
      time: '3 hours ago',
      isRead: true,
      avatar: 'M',
    ),
    NotificationItem(
      type: NotificationType.message,
      title: 'New message',
      message: 'Alice sent you a message',
      time: '5 hours ago',
      isRead: false,
      avatar: 'A',
    ),
    NotificationItem(
      type: NotificationType.system,
      title: 'Security Alert',
      message: 'New login from Windows device',
      time: '1 day ago',
      isRead: true,
      avatar: '!',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredNotifications = _showOnlyUnread 
      ? _notifications.where((n) => !n.isRead).toList()
      : _notifications;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: Colors.grey[900],
            onSelected: (value) {
              switch (value) {
                case 'mark_all_read':
                  _markAllAsRead();
                  break;
                case 'clear_all':
                  _clearAllNotifications();
                  break;
                case 'settings':
                  // Navigate to notification settings
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Text('Mark all as read', style: TextStyle(color: Colors.white)),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Text('Clear all', style: TextStyle(color: Colors.white)),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Notification settings', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Toggle
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Show only unread',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: _showOnlyUnread,
                  onChanged: (value) => setState(() => _showOnlyUnread = value),
                  activeColor: Colors.deepPurple,
                ),
              ],
            ),
          ),
          
          // Notifications List
          Expanded(
            child: filteredNotifications.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: filteredNotifications.length,
                  itemBuilder: (context, index) {
                    return _buildNotificationItem(filteredNotifications[index]);
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.grey[900] : Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        border: notification.isRead 
          ? null 
          : Border.all(color: Colors.deepPurple.withOpacity(0.3)),
      ),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: _getNotificationColor(notification.type),
              child: Text(
                notification.avatar,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (!notification.isRead)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              notification.time,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            notification.isRead ? Icons.mark_email_read : Icons.mark_email_unread,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              notification.isRead = !notification.isRead;
            });
          },
        ),
        onTap: () {
          if (!notification.isRead) {
            setState(() {
              notification.isRead = true;
            });
          }
          _handleNotificationTap(notification);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            _showOnlyUnread ? 'No unread notifications' : 'No notifications',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _showOnlyUnread 
              ? 'All caught up! Check back later for new updates.'
              : 'You\'ll see notifications here when you get them.',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return Colors.red;
      case NotificationType.comment:
        return Colors.blue;
      case NotificationType.follow:
        return Colors.green;
      case NotificationType.message:
        return Colors.purple;
      case NotificationType.system:
        return Colors.orange;
    }
  }

  void _handleNotificationTap(NotificationItem notification) {
    // Handle navigation based on notification type
    switch (notification.type) {
      case NotificationType.like:
      case NotificationType.comment:
        // Navigate to post
        break;
      case NotificationType.follow:
        // Navigate to profile
        break;
      case NotificationType.message:
        // Navigate to messages
        break;
      case NotificationType.system:
        // Navigate to settings or show details
        break;
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Clear All Notifications',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to clear all notifications? This action cannot be undone.',
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _notifications.clear();
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All notifications cleared'),
                    backgroundColor: Colors.deepPurple,
                  ),
                );
              },
              child: const Text(
                'Clear All',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

enum NotificationType {
  like,
  comment,
  follow,
  message,
  system,
}

class NotificationItem {
  final NotificationType type;
  final String title;
  final String message;
  final String time;
  final String avatar;
  bool isRead;

  NotificationItem({
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.avatar,
    required this.isRead,
  });
}
