import 'package:flutter/material.dart';

class MessagesTopBarScreen extends StatefulWidget {
  const MessagesTopBarScreen({super.key});

  @override
  State<MessagesTopBarScreen> createState() => _MessagesTopBarScreenState();
}

class _MessagesTopBarScreenState extends State<MessagesTopBarScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final List<Conversation> _conversations = [
    Conversation(
      name: 'John Doe',
      lastMessage: 'Hey! How are you doing?',
      time: '2 min',
      unreadCount: 2,
      isOnline: true,
      avatar: 'J',
    ),
    Conversation(
      name: 'Sarah Wilson',
      lastMessage: 'Thanks for the help yesterday!',
      time: '1 hour',
      unreadCount: 0,
      isOnline: false,
      avatar: 'S',
    ),
    Conversation(
      name: 'Mike Chen',
      lastMessage: 'Can we schedule a meeting?',
      time: '3 hours',
      unreadCount: 1,
      isOnline: true,
      avatar: 'M',
    ),
    Conversation(
      name: 'Alice Johnson',
      lastMessage: 'The project looks great!',
      time: '1 day',
      unreadCount: 0,
      isOnline: false,
      avatar: 'A',
    ),
  ];

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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Messages',
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
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              _showNewMessageDialog();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.deepPurple,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Chats'),
            Tab(text: 'Groups'),
            Tab(text: 'Requests'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search messages...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: (value) {
                  // Handle search
                },
              ),
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildChatsTab(),
                _buildGroupsTab(),
                _buildRequestsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewMessageDialog();
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.message, color: Colors.white),
      ),
    );
  }

  Widget _buildChatsTab() {
    return ListView.builder(
      itemCount: _conversations.length,
      itemBuilder: (context, index) {
        return _buildConversationItem(_conversations[index]);
      },
    );
  }

  Widget _buildGroupsTab() {
    return const Center(
      child: Text(
        'No group conversations yet',
        style: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    );
  }

  Widget _buildRequestsTab() {
    return const Center(
      child: Text(
        'No message requests',
        style: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    );
  }

  Widget _buildConversationItem(Conversation conversation) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Text(
                conversation.avatar,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (conversation.isOnline)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                conversation.name,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: conversation.unreadCount > 0
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
            Text(
              conversation.time,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                conversation.lastMessage,
                style: TextStyle(
                  color: conversation.unreadCount > 0
                      ? Colors.grey[300]
                      : Colors.grey[500],
                  fontWeight: conversation.unreadCount > 0
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (conversation.unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  conversation.unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        onTap: () {
          _openChat(conversation);
        },
        onLongPress: () {
          _showConversationOptions(conversation);
        },
      ),
    );
  }

  void _showNewMessageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'New Message',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search people...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Recent contacts would go here
              const Text(
                'Recent contacts will appear here',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Handle new message creation
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showConversationOptions(Conversation conversation) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.push_pin, color: Colors.white),
                title: const Text('Pin conversation',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // Handle pin
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.notifications_off, color: Colors.white),
                title: const Text('Mute notifications',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // Handle mute
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive, color: Colors.white),
                title: const Text('Archive',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // Handle archive
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete conversation',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _deleteConversation(conversation);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _openChat(Conversation conversation) {
    // Navigate to individual chat screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(conversation: conversation)));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening chat with ${conversation.name}'),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  void _deleteConversation(Conversation conversation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Delete Conversation',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete this conversation with ${conversation.name}?',
            style: const TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _conversations.remove(conversation);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Conversation deleted'),
                    backgroundColor: Colors.deepPurple,
                  ),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

class Conversation {
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final String avatar;

  Conversation({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
    required this.avatar,
  });
}
