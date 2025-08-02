import 'package:flutter/material.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Groups',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateGroupDialog(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'My Groups'),
            Tab(text: 'Discover'),
            Tab(text: 'Invites'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMyGroupsTab(),
          _buildDiscoverTab(),
          _buildInvitesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateGroupDialog(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildMyGroupsTab() {
    final myGroups = [
      {
        'name': 'Flutter Developers',
        'members': '1,234',
        'description': 'A community for Flutter developers to share knowledge and help each other',
        'image': 'https://via.placeholder.com/100x100/2196f3/ffffff?text=FD',
        'isAdmin': true,
        'lastActivity': '2 hours ago',
      },
      {
        'name': 'Photography Enthusiasts',
        'members': '856',
        'description': 'Share your best shots and get feedback from fellow photographers',
        'image': 'https://via.placeholder.com/100x100/ff9800/ffffff?text=PE',
        'isAdmin': false,
        'lastActivity': '1 day ago',
      },
      {
        'name': 'Fitness Motivation',
        'members': '2,341',
        'description': 'Stay motivated and achieve your fitness goals together',
        'image': 'https://via.placeholder.com/100x100/4caf50/ffffff?text=FM',
        'isAdmin': false,
        'lastActivity': '3 hours ago',
      },
    ];

    if (myGroups.isEmpty) {
      return _buildEmptyState(
        Icons.group_outlined,
        'No Groups Yet',
        'Join or create groups to connect with people who share your interests',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: myGroups.length,
      itemBuilder: (context, index) {
        final group = myGroups[index];
        return _buildGroupCard(group, showJoinButton: false);
      },
    );
  }

  Widget _buildDiscoverTab() {
    final discoverGroups = [
      {
        'name': 'Tech Startups',
        'members': '3,456',
        'description': 'Connect with entrepreneurs and discuss the latest in tech startups',
        'image': 'https://via.placeholder.com/100x100/9c27b0/ffffff?text=TS',
        'category': 'Technology',
      },
      {
        'name': 'Book Club',
        'members': '789',
        'description': 'Monthly book discussions and recommendations',
        'image': 'https://via.placeholder.com/100x100/795548/ffffff?text=BC',
        'category': 'Literature',
      },
      {
        'name': 'Travel Adventurers',
        'members': '5,678',
        'description': 'Share travel experiences and discover new destinations',
        'image': 'https://via.placeholder.com/100x100/00bcd4/ffffff?text=TA',
        'category': 'Travel',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: discoverGroups.length,
      itemBuilder: (context, index) {
        final group = discoverGroups[index];
        return _buildGroupCard(group, showJoinButton: true);
      },
    );
  }

  Widget _buildInvitesTab() {
    final invites = [
      {
        'name': 'Mobile App Designers',
        'members': '1,123',
        'description': 'UI/UX designers focused on mobile app design',
        'image': 'https://via.placeholder.com/100x100/e91e63/ffffff?text=MAD',
        'invitedBy': 'Sarah Johnson',
      },
    ];

    if (invites.isEmpty) {
      return _buildEmptyState(
        Icons.mail_outline,
        'No Invites',
        'You don\'t have any group invites at the moment',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: invites.length,
      itemBuilder: (context, index) {
        final invite = invites[index];
        return _buildInviteCard(invite);
      },
    );
  }

  Widget _buildGroupCard(Map<String, dynamic> group, {required bool showJoinButton}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    group['image']!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              group['name']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (group['isAdmin'] == true)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Admin',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.people, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${group['members']} members',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (group['lastActivity'] != null) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              group['lastActivity']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              group['description']!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (group['category'] != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      group['category']!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                const Spacer(),
                if (showJoinButton)
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Joined ${group['name']}!'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Join', style: TextStyle(color: Colors.white)),
                  )
                else
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening ${group['name']}...'),
                        ),
                      );
                    },
                    child: const Text('View'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteCard(Map<String, dynamic> invite) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    invite['image']!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invite['name']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.people, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${invite['members']} members',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              invite['description']!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Invited by ${invite['invitedBy']}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invite declined')),
                      );
                    },
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Joined ${invite['name']}!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('Accept', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Group'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Group name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Group description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
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
                const SnackBar(
                  content: Text('Group creation feature coming soon!'),
                ),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
