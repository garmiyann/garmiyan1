import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'contacts_screen.dart';

class MessengerScreen extends StatefulWidget {
  const MessengerScreen({Key? key}) : super(key: key);

  @override
  _MessengerScreenState createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 8,
        shadowColor: isDark ? Colors.black54 : Colors.black26,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [Colors.grey[800]!, Colors.grey[700]!]
                  : [const Color(0xFF527DA3), const Color(0xFF40A2E3)],
            ),
          ),
        ),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isSearching
              ? Container(
                  key: const ValueKey('search'),
                  decoration: BoxDecoration(
                    color:
                        (isDark ? Colors.black : Colors.white).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(
                      color: Theme.of(context).appBarTheme.foregroundColor,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                        color: Theme.of(context)
                            .appBarTheme
                            .foregroundColor
                            ?.withOpacity(0.7),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context)
                            .appBarTheme
                            .foregroundColor
                            ?.withOpacity(0.7),
                      ),
                    ),
                    autofocus: true,
                  ),
                )
              : Text(
                  'Telegram',
                  key: const ValueKey('title'),
                  style: TextStyle(
                    color: Theme.of(context).appBarTheme.foregroundColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
        actions: [
          if (!_isSearching) ...[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
              splashRadius: 24,
              tooltip: 'Search',
            ),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
              onSelected: (value) {
                switch (value) {
                  case 'new_group':
                    _createNewGroup(context);
                    break;
                  case 'new_channel':
                    _createNewChannel(context);
                    break;
                  case 'contacts':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ContactsScreen()),
                    );
                    break;
                  case 'calls':
                    _showCallsScreen(context);
                    break;
                  case 'saved_messages':
                    _showSavedMessages(context);
                    break;
                  case 'settings':
                    _showSettings(context);
                    break;
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 8,
              itemBuilder: (BuildContext context) => [
                _buildPopupMenuItem('new_group', Icons.group_add, 'New Group'),
                _buildPopupMenuItem(
                    'new_channel', Icons.campaign, 'New Channel'),
                _buildPopupMenuItem('contacts', Icons.contacts, 'Contacts'),
                _buildPopupMenuItem('calls', Icons.call, 'Calls'),
                _buildPopupMenuItem(
                    'saved_messages', Icons.bookmark, 'Saved Messages'),
                _buildPopupMenuItem('settings', Icons.settings, 'Settings'),
              ],
            ),
          ] else ...[
            IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
              },
              splashRadius: 24,
              tooltip: 'Close search',
            ),
          ],
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).appBarTheme.foregroundColor,
          indicatorWeight: 3,
          labelColor: Theme.of(context).appBarTheme.foregroundColor,
          unselectedLabelColor:
              Theme.of(context).appBarTheme.foregroundColor?.withOpacity(0.7),
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: 'ALL CHATS'),
            Tab(text: 'UNREAD'),
            Tab(text: 'GROUPS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AllChatsTab(),
          UnreadChatsTab(),
          GroupChatsTab(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton:
          null, // Remove the floating action button since we have bottom nav
    );
  }

  Widget _buildBottomNavigationBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
            (isDark ? Colors.grey[900] : Colors.white),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.black)
                .withOpacity(isDark ? 0.3 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(
                icon: Icons.call,
                label: 'Calls',
                onTap: () => _showCallsScreen(context),
              ),
              _buildBottomNavItem(
                icon: Icons.chat_bubble_outline,
                label: 'New Message',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactsScreen(),
                  ),
                ),
              ),
              _buildBottomNavItem(
                icon: Icons.settings,
                label: 'Settings',
                onTap: () => _showSettings(context),
              ),
              _buildBottomNavItem(
                icon: Icons.apps,
                label: 'Services',
                onTap: () => _showServicesScreen(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showServicesScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Services',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF40A2E3),
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildServiceCard(
                  icon: Icons.cloud_upload,
                  title: 'File Share',
                  subtitle: 'Share files easily',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('File share coming soon!')),
                    );
                  },
                ),
                _buildServiceCard(
                  icon: Icons.location_on,
                  title: 'Location',
                  subtitle: 'Share your location',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Location share coming soon!')),
                    );
                  },
                ),
                _buildServiceCard(
                  icon: Icons.photo_camera,
                  title: 'Camera',
                  subtitle: 'Take a photo',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Camera feature coming soon!')),
                    );
                  },
                ),
                _buildServiceCard(
                  icon: Icons.mic,
                  title: 'Voice Note',
                  subtitle: 'Record voice message',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Voice notes coming soon!')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF40A2E3),
              Color(0xFF527DA3),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF40A2E3).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
      String value, IconData icon, String text) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _createNewGroup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Group'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Group name',
            border: OutlineInputBorder(),
          ),
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
                const SnackBar(
                    content: Text('Group creation feature coming soon!')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _createNewChannel(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Channel'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Channel name',
            border: OutlineInputBorder(),
          ),
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
                const SnackBar(
                    content: Text('Channel creation feature coming soon!')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showCallsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Calls'),
            backgroundColor: const Color(0xFF40A2E3),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.call, size: 100, color: Colors.grey),
                const SizedBox(height: 20),
                const Text('Call History', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Voice call feature coming soon!')),
                    );
                  },
                  icon: const Icon(Icons.call),
                  label: const Text('Make Voice Call'),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Video call feature coming soon!')),
                    );
                  },
                  icon: const Icon(Icons.videocam),
                  label: const Text('Make Video Call'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSavedMessages(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Saved Messages'),
            backgroundColor: const Color(0xFF40A2E3),
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark, size: 100, color: Colors.grey),
                SizedBox(height: 20),
                Text('No saved messages yet', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Save important messages here',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
            backgroundColor: const Color(0xFF40A2E3),
          ),
          body: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AllChatsTab extends StatelessWidget {
  const AllChatsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      return const Center(child: Text('Please log in to view chats'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .where('participants', arrayContains: currentUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF40A2E3)),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        // Filter out chats where lastMessage is empty
        final chatsWithMessages = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final lastMessage = data['lastMessage']?.toString().trim() ?? '';
          print('Chat ${doc.id}: lastMessage = "$lastMessage"');
          return lastMessage.isNotEmpty;
        }).toList();

        // Sort chats by lastMessageTime manually
        chatsWithMessages.sort((a, b) {
          final dataA = a.data() as Map<String, dynamic>;
          final dataB = b.data() as Map<String, dynamic>;
          final timeA = dataA['lastMessageTime'] as Timestamp?;
          final timeB = dataB['lastMessageTime'] as Timestamp?;

          if (timeA == null && timeB == null) return 0;
          if (timeA == null) return 1;
          if (timeB == null) return -1;

          return timeB.compareTo(timeA);
        });

        print(
            'Total chats: ${snapshot.data!.docs.length}, With messages: ${chatsWithMessages.length}');

        if (chatsWithMessages.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.separated(
          itemCount: chatsWithMessages.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final chat = chatsWithMessages[index];
            return AnimatedContainer(
              duration: Duration(milliseconds: 300 + (index * 50)),
              curve: Curves.easeOutBack,
              child: TelegramChatListTile(chat: chat),
            );
          },
          separatorBuilder: (context, index) => Container(
            height: 0.5,
            color: Colors.grey.withOpacity(0.3),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.forum_outlined,
            size: 100,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            'No chats yet',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Start messaging to see your chats here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class TelegramChatListTile extends StatelessWidget {
  final QueryDocumentSnapshot chat;

  const TelegramChatListTile({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatData = chat.data() as Map<String, dynamic>;
    final participants = List<String>.from(chatData['participants'] ?? []);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final otherUserId = participants.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );

    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(otherUserId).get(),
      builder: (context, userSnapshot) {
        final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
        final userName = userData?['firstName'] ?? 'Unknown User';
        final userAvatar = userData?['avatar'] ?? '';

        return Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: const Color(0xFF40A2E3).withOpacity(0.1),
            highlightColor: const Color(0xFF40A2E3).withOpacity(0.05),
            onTap: () {
              // Mark messages as read when opening chat
              _markChatAsRead(chat.id);

              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      ChatScreen(
                    chatId: chat.id,
                    otherUserId: otherUserId,
                    otherUserName: userName,
                    otherUserAvatar: userAvatar,
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOutCubic,
                      )),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                ),
              );
            },
            onLongPress: () {
              _showChatOptions(context, chat.id, userName);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Hero(
                        tag: 'avatar_$otherUserId',
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: const Color(0xFF40A2E3),
                          backgroundImage: userAvatar.isNotEmpty
                              ? NetworkImage(userAvatar)
                              : null,
                          child: userAvatar.isEmpty
                              ? Text(
                                  userName.isNotEmpty
                                      ? userName[0].toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      userName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color:
                                            chatData['unreadCount'] != null &&
                                                    chatData['unreadCount'] > 0
                                                ? Colors.black
                                                : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  if (chatData['muted'] == true)
                                    Container(
                                      margin: const EdgeInsets.only(left: 6),
                                      child: Icon(
                                        Icons.volume_off,
                                        size: 16,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              _formatTime(chatData['lastMessageTime']),
                              style: TextStyle(
                                color: chatData['unreadCount'] != null &&
                                        chatData['unreadCount'] > 0
                                    ? const Color(0xFF40A2E3)
                                    : Colors.grey[500],
                                fontSize: 13,
                                fontWeight: chatData['unreadCount'] != null &&
                                        chatData['unreadCount'] > 0
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (chatData['lastMessage'] != null &&
                                chatData['lastMessage'].isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Icon(
                                  chatData['unreadCount'] != null &&
                                          chatData['unreadCount'] > 0
                                      ? Icons.check
                                      : Icons.done_all,
                                  size: 16,
                                  color: chatData['unreadCount'] != null &&
                                          chatData['unreadCount'] > 0
                                      ? Colors.grey[500]
                                      : const Color(0xFF40A2E3),
                                ),
                              ),
                            Expanded(
                              child: Text(
                                chatData['lastMessage'] ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: chatData['unreadCount'] != null &&
                                          chatData['unreadCount'] > 0
                                      ? Colors.black87
                                      : Colors.grey[600],
                                  fontSize: 14,
                                  fontWeight: chatData['unreadCount'] != null &&
                                          chatData['unreadCount'] > 0
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (chatData['unreadCount'] != null &&
                                chatData['unreadCount'] > 0)
                              TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 400),
                                tween: Tween<double>(begin: 0.0, end: 1.0),
                                builder: (context, scale, child) {
                                  // Check if chat is muted
                                  final isMuted = chatData['muted'] == true;

                                  return Transform.scale(
                                    scale: scale,
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: isMuted ? 6 : 8,
                                          vertical: isMuted ? 6 : 4),
                                      decoration: BoxDecoration(
                                        gradient: isMuted
                                            ? const LinearGradient(
                                                colors: [
                                                  Color(0xFF95A5A6),
                                                  Color(0xFF7F8C8D),
                                                ],
                                              )
                                            : const LinearGradient(
                                                colors: [
                                                  Color(0xFFFF6B6B),
                                                  Color(0xFFEE5A24),
                                                ],
                                              ),
                                        borderRadius: BorderRadius.circular(
                                            isMuted ? 6 : 12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (isMuted
                                                    ? const Color(0xFF95A5A6)
                                                    : const Color(0xFFFF6B6B))
                                                .withOpacity(0.4),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: isMuted
                                          ? Container(
                                              width: 8,
                                              height: 8,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                            )
                                          : Text(
                                              chatData['unreadCount'] > 99
                                                  ? '99+'
                                                  : chatData['unreadCount']
                                                      .toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';

    final now = DateTime.now();
    final date = timestamp.toDate();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun'
      ][date.weekday - 1];
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showChatOptions(BuildContext context, String chatId, String userName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              userName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.mark_chat_read, color: Colors.green),
              title: const Text('Mark as Read'),
              onTap: () {
                Navigator.pop(context);
                _markChatAsRead(chatId);
              },
            ),
            ListTile(
              leading: const Icon(Icons.mark_chat_unread, color: Colors.blue),
              title: const Text('Mark as Unread'),
              onTap: () {
                Navigator.pop(context);
                _markChatAsUnread(chatId);
              },
            ),
            ListTile(
              leading: const Icon(Icons.volume_off, color: Colors.orange),
              title: const Text('Mute Chat'),
              onTap: () {
                Navigator.pop(context);
                _muteChat(chatId);
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive, color: Colors.blue),
              title: const Text('Archive Chat'),
              onTap: () {
                Navigator.pop(context);
                _archiveChat(chatId);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Chat'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, chatId, userName);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _muteChat(String chatId) {
    FirebaseFirestore.instance.collection('chats').doc(chatId).update({
      'muted': true,
      'mutedAt': FieldValue.serverTimestamp(),
    });
  }

  void _archiveChat(String chatId) {
    FirebaseFirestore.instance.collection('chats').doc(chatId).update({
      'archived': true,
      'archivedAt': FieldValue.serverTimestamp(),
    });
  }

  void _showDeleteConfirmation(
      BuildContext context, String chatId, String userName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chat'),
        content:
            Text('Are you sure you want to delete your chat with $userName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteChat(chatId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteChat(String chatId) {
    FirebaseFirestore.instance.collection('chats').doc(chatId).delete();
  }

  void _markChatAsRead(String chatId) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      FirebaseFirestore.instance.collection('chats').doc(chatId).update({
        'unreadCount': 0,
        'lastReadBy.$currentUserId': FieldValue.serverTimestamp(),
      });
    }
  }

  void _markChatAsUnread(String chatId) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      FirebaseFirestore.instance.collection('chats').doc(chatId).update({
        'unreadCount': 1,
        'isUnread': true,
        'markedUnreadBy': currentUserId,
        'markedUnreadAt': FieldValue.serverTimestamp(),
      });
    }
  }
}

class UnreadChatsTab extends StatelessWidget {
  const UnreadChatsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      return const Center(child: Text('Please log in to view chats'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .where('participants', arrayContains: currentUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF40A2E3)),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        // Filter for chats with unread messages
        final unreadChats = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return data['unreadCount'] != null && data['unreadCount'] > 0;
        }).toList();

        if (unreadChats.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.separated(
          itemCount: unreadChats.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final chat = unreadChats[index];
            return TelegramChatListTile(chat: chat);
          },
          separatorBuilder: (context, index) => Container(
            height: 0.5,
            color: Colors.grey.withOpacity(0.3),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mark_chat_read_outlined,
            size: 100,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            'No unread chats',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'All caught up!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class GroupChatsTab extends StatelessWidget {
  const GroupChatsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('groups')
          .where('members',
              arrayContains: FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF40A2E3)),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.group_outlined,
                  size: 100,
                  color: Colors.grey,
                ),
                SizedBox(height: 20),
                Text(
                  'No groups yet',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Create or join groups to chat with multiple people',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: snapshot.data!.docs.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final group = snapshot.data!.docs[index];
            return TelegramChatListTile(chat: group);
          },
          separatorBuilder: (context, index) => Container(
            height: 0.5,
            color: Colors.grey.withOpacity(0.3),
          ),
        );
      },
    );
  }
}
