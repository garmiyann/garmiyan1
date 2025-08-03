import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.deepPurple,
      ),
      body: currentUserId == null
          ? const Center(child: Text('Not logged in'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .where('toUserId', isEqualTo: currentUserId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No notifications yet'));
                }
                final notifications = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notif =
                        notifications[index].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: const Icon(Icons.person_add_rounded,
                          color: Colors.deepPurple),
                      title: Text(notif['message'] ?? 'Someone followed you'),
                      subtitle: notif['timestamp'] != null
                          ? Text(DateTime.fromMillisecondsSinceEpoch(
                                  notif['timestamp'])
                              .toLocal()
                              .toString())
                          : null,
                    );
                  },
                );
              },
            ),
    );
  }
}
