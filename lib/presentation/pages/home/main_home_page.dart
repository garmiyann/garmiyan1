import 'dart:ui';
import 'package:flutter/material.dart';
// import 'profile_screen.dart';        // Commented out - missing file
// import 'notifications_screen.dart';  // Commented out - missing file
// import 'ai/ai_chat_screen.dart';     // Commented out - missing file
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../screens/profile/profile_screen.dart'; // Import the main TikTok-style profile

/// Data model for an action option in the add modal.
class _AddActionOption {
  final IconData icon;
  final String title;
  final String description;

  _AddActionOption({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _HomeContent(),
    const SimpleAIChatScreen(),
    const SimpleNotificationsScreen(),
    const ProfileScreen(), // Connect directly to main TikTok-style profile
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // For the center "add" button, show the custom drop-up modal
      _showAddOptionsModal(context);
    } else {
      // Map TikTok navigation indices to your existing pages
      int pageIndex = index;
      if (index > 2) pageIndex = index - 1; // Adjust for the add button
      setState(() {
        _selectedIndex = pageIndex;
      });
    }
  }

  void _showAddOptionsModal(BuildContext context) {
    final List<_AddActionOption> options = <_AddActionOption>[
      _AddActionOption(
        icon: Icons.folder_open,
        title: 'Add Project',
        description: 'Start a new creative project',
      ),
      _AddActionOption(
        icon: Icons.image,
        title: 'Add Image',
        description: 'Upload an image from your gallery',
      ),
      _AddActionOption(
        icon: Icons.videocam,
        title: 'Add Video',
        description: 'Record or upload a video clip',
      ),
      _AddActionOption(
        icon: Icons.group_add,
        title: 'Create Group',
        description: 'Start a new collaborative group',
      ),
    ];

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Column(
                children: options.map<Widget>((_AddActionOption option) {
                  return _AddOptionTile(
                    option: option,
                    onTap: () {
                      Navigator.pop(bc);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${option.title} tapped!'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        height: 75,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 0.5),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _TikTokNavItem(
              icon: Icons.home,
              label: 'Home',
              selected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            _AINavItem(
              label: 'AI Chat',
              selected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            _CenterAddButton(
              onTap: () => _onItemTapped(2),
            ),
            Stack(
              children: <Widget>[
                _TikTokNavItem(
                  icon: Icons.notifications,
                  label: 'Notifications',
                  selected: _selectedIndex == 2,
                  onTap: () => _onItemTapped(3),
                ),
                Positioned(
                  right: 10,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: const Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            _TikTokNavItem(
              icon: Icons.person,
              label: 'Profile',
              selected: _selectedIndex == 3,
              onTap: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _TikTokNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TikTokNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55,
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: selected ? Colors.deepPurple : Colors.grey.shade600,
              size: selected ? 24 : 22,
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  color: selected ? Colors.deepPurple : Colors.grey.shade600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AINavItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AINavItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55,
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: selected ? 24 : 22,
              height: selected ? 24 : 22,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: selected
                      ? [Colors.deepPurple, Colors.purple]
                      : [Colors.grey.shade600, Colors.grey.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(selected ? 12 : 11),
              ),
              child: Center(
                child: Text(
                  'AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: selected ? 10 : 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  color: selected ? Colors.deepPurple : Colors.grey.shade600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CenterAddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 28,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              left: 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            Container(
              width: 34,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.add, color: Colors.black, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

/// A tile widget for displaying an add option in the bottom sheet.
class _AddOptionTile extends StatelessWidget {
  final _AddActionOption option;
  final VoidCallback onTap;

  const _AddOptionTile({
    required this.option,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 0.8),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Icon(option.icon, size: 24, color: Colors.black87),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    option.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    option.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _HomeContentWithSearch(),
    );
  }
}

class _HomeContentWithSearch extends StatefulWidget {
  @override
  State<_HomeContentWithSearch> createState() => _HomeContentWithSearchState();
}

class _HomeContentWithSearchState extends State<_HomeContentWithSearch> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  final Color _primaryColor = Colors.deepPurple;
  final Color _secondaryColor = Colors.teal;

  Future<void> _searchUsers(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }
    setState(() {
      _isSearching = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      final nameSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('firstName', isGreaterThanOrEqualTo: query)
          .where('firstName', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      final lastNameSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('lastName', isGreaterThanOrEqualTo: query)
          .where('lastName', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      final results = <Map<String, dynamic>>[];
      for (var doc in snapshot.docs) {
        results.add({...doc.data(), 'uid': doc.id});
      }
      for (var doc in nameSnapshot.docs) {
        results.add({...doc.data(), 'uid': doc.id});
      }
      for (var doc in lastNameSnapshot.docs) {
        results.add({...doc.data(), 'uid': doc.id});
      }

      final uniqueResults = <String, Map<String, dynamic>>{};
      for (var user in results) {
        uniqueResults[user['username']] = user;
      }

      final currentUser = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      final currentUsername = currentUser.data()?['username'];

      setState(() {
        _searchResults = uniqueResults.values
            .where((user) => user['username'] != currentUsername)
            .toList();
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search users by name or username...',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onChanged: _searchUsers,
          ),
          const SizedBox(height: 8),

          if (_isSearching)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            ),

          if (_searchResults.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final user = _searchResults[index];
                  return ListTile(
                    leading: user['profileImageUrl'] != null &&
                            user['profileImageUrl'].toString().isNotEmpty
                        ? CircleAvatar(
                            backgroundColor: _primaryColor.withOpacity(0.1),
                            backgroundImage:
                                NetworkImage(user['profileImageUrl']),
                          )
                        : CircleAvatar(
                            backgroundColor: _primaryColor.withOpacity(0.1),
                            child: Icon(Icons.person_rounded,
                                color: _primaryColor),
                          ),
                    title: Text(
                      ((user['firstName'] ?? '') +
                                  (user['lastName'] != null &&
                                          user['lastName'] != ''
                                      ? ' ${user['lastName']}'
                                      : ''))
                              .trim()
                              .isNotEmpty
                          ? ((user['firstName'] ?? '') +
                                  (user['lastName'] != null &&
                                          user['lastName'] != ''
                                      ? ' ${user['lastName']}'
                                      : ''))
                              .trim()
                          : 'No Name',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text('@${user['username'] ?? 'user'}'),
                    trailing: Icon(Icons.chevron_right_rounded,
                        color: Colors.grey.shade400),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ProfileScreen(), // Navigate to main profile
                        ),
                      );
                    },
                  );
                },
              ),
            ),

          // Top Row - Account
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const ProfileScreen()), // Navigate to main profile
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _primaryColor.withOpacity(0.1),
                      backgroundImage: const AssetImage('assets/profile.jpg'),
                      radius: 24,
                      child: const Icon(Icons.person_rounded),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'GARMİYANN',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Badge(
                  backgroundColor: _primaryColor,
                  child: const Icon(Icons.notifications_none_rounded, size: 28),
                ),
                onPressed: () {},
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Account Balance Box
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_secondaryColor, _secondaryColor.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _secondaryColor.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.account_balance_wallet_rounded,
                        color: Colors.white),
                    SizedBox(width: 8),
                    Text('Account Balance',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('14,304.39 IQD',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActionButton(
                      icon: Icons.arrow_downward_rounded,
                      label: 'Deposit',
                      onPressed: () {},
                    ),
                    _buildActionButton(
                      icon: Icons.history_rounded,
                      label: 'History',
                      onPressed: () {},
                    ),
                    _buildActionButton(
                      icon: Icons.arrow_upward_rounded,
                      label: 'Withdraw',
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Discount Box
          Container(
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange.shade200),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cash Back',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    Text('Up to 80% back', style: TextStyle(fontSize: 14)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward_rounded),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Services Grid
          const Text('Services',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 0.9,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _serviceIcon(Icons.currency_exchange_rounded, 'Exchange'),
              _serviceIcon(Icons.local_shipping_rounded, 'Shipping'),
              _serviceIcon(Icons.shopping_bag_rounded, 'Shopping'),
              _serviceIcon(Icons.travel_explore_rounded, 'Travel'),
              _serviceIcon(Icons.card_giftcard_rounded, 'Gift Cards'),
              _serviceIcon(Icons.more_horiz_rounded, 'More'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: _secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
    );
  }

  Widget _serviceIcon(IconData icon, String label) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.grey.shade50,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: _primaryColor),
            ),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                )),
          ],
        ),
      ),
    );
  }
}

// Simple placeholder screens
class SimpleAIChatScreen extends StatelessWidget {
  const SimpleAIChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'AI Chat',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            Text(
              'Coming Soon...',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleNotificationsScreen extends StatelessWidget {
  const SimpleNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Notifications',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            Text(
              'No new notifications',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleProfileScreen extends StatelessWidget {
  const SimpleProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              user?.displayName ?? 'User Profile',
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
            Text(
              user?.email ?? 'No email',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB700FF),
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
