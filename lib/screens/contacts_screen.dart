import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF527DA3), // Telegram blue
        elevation: 0,
        title: const Text(
          'Contacts',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {},
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'invite_friend',
                child: Text('Invite Friends'),
              ),
              const PopupMenuItem(
                value: 'add_contact',
                child: Text('Add Contact'),
              ),
              const PopupMenuItem(
                value: 'sort_by',
                child: Text('Sort by'),
              ),
              const PopupMenuItem(
                value: 'help',
                child: Text('Help'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search name or number',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // Quick actions
          Container(
            color: Colors.grey[50],
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF40A2E3),
                    child: Icon(Icons.group_add, color: Colors.white),
                  ),
                  title: const Text(
                    'New Group',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    // Navigate to new group screen
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF40A2E3),
                    child: Icon(Icons.campaign, color: Colors.white),
                  ),
                  title: const Text(
                    'New Channel',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    // Navigate to new channel screen
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF40A2E3),
                    child: Icon(Icons.person_add, color: Colors.white),
                  ),
                  title: const Text(
                    'Add People Nearby',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    // Navigate to add nearby people screen
                  },
                ),
              ],
            ),
          ), // Contacts list
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sorted by last seen time',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ),

          Expanded(
            child: _buildContactsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 100,
                  color: Colors.grey,
                ),
                SizedBox(height: 20),
                Text(
                  'No contacts found',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        final currentUserId = FirebaseAuth.instance.currentUser?.uid;
        final filteredUsers = snapshot.data!.docs.where((doc) {
          final userData = doc.data() as Map<String, dynamic>;
          final name =
              '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'
                  .toLowerCase();
          final username = (userData['username'] ?? '').toLowerCase();

          // Filter out current user and apply search query
          return doc.id != currentUserId &&
              (name.contains(_searchQuery) || username.contains(_searchQuery));
        }).toList();

        if (filteredUsers.isEmpty) {
          return const Center(
            child: Text(
              'No contacts found',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            final user = filteredUsers[index];
            final userData = user.data() as Map<String, dynamic>;

            return ContactListTile(
              userId: user.id,
              userData: userData,
              onTap: () => _startChat(user.id, userData),
            );
          },
        );
      },
    );
  }

  void _startChat(String otherUserId, Map<String, dynamic> userData) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    try {
      // Check if chat already exists
      final existingChats = await FirebaseFirestore.instance
          .collection('chats')
          .where('participants', arrayContains: currentUserId)
          .get();

      String chatId = '';

      // Look for existing chat with this user
      for (var doc in existingChats.docs) {
        final data = doc.data();
        final participants = List<String>.from(data['participants'] ?? []);
        if (participants.contains(otherUserId)) {
          chatId = doc.id;
          break;
        }
      }

      // If no existing chat found, create a new one
      if (chatId.isEmpty) {
        final newChat =
            await FirebaseFirestore.instance.collection('chats').add({
          'participants': [currentUserId, otherUserId],
          'lastMessage': '',
          'lastMessageTime': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
          'unreadCount': 0,
        });
        chatId = newChat.id;
      }

      // Navigate to chat screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            chatId: chatId,
            otherUserId: otherUserId,
            otherUserName:
                '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'
                    .trim(),
            otherUserAvatar: userData['avatar'] ?? '',
          ),
        ),
      );
    } catch (e) {
      print('Error starting chat: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start chat: $e')),
      );
    }
  }
}

class ContactListTile extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> userData;
  final VoidCallback onTap;

  const ContactListTile({
    Key? key,
    required this.userId,
    required this.userData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name =
        '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'.trim();
    final username = userData['username'] ?? '';
    final avatar = userData['avatar'] ?? '';
    final about = userData['about'] ?? 'Hey there! I am using WhatsApp.';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: const Color(0xFF40A2E3),
        backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
        child: avatar.isEmpty
            ? Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'U',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              )
            : null,
      ),
      title: Text(
        name.isNotEmpty ? name : username,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        about,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      onTap: onTap,
    );
  }
}
