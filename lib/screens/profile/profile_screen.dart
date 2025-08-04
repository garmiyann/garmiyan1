import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'settings_screen.dart';
import '../finance/balance_screen.dart';
import '../communication/messenger_screen.dart';
import '../lifestyle/live_screen.dart';
import '../lifestyle/lifestyle_screen.dart';
import '../lifestyle/groups_screen.dart';
import '../general/notifications_screen.dart';
import '../payment/payment_screen.dart';
import '../menu/menu_bottom/tiktok_studio/tiktok_studio_screen.dart';
import '../menu/menu_bottom/my_project/my_project_screen.dart';
import '../menu/menu_bottom/my_qr_code/my_qr_code_screen.dart';
import '../../data/services/theme_service.dart';

/// A widget for displaying a section header within the drop-up menu.
class DropUpSectionHeader extends StatelessWidget {
  final String title;

  const DropUpSectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Made background color theme-aware
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[800]
          : const Color(0xFFFAFAFA),
      child: Padding(
        // Updated padding to provide symmetric vertical padding, centering the text
        // within the background while maintaining horizontal padding.
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 6, // Changed font size to 6 as requested (smaller)
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[400]
                  : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}

/// A widget for displaying a single item in the drop-up menu.
class DropUpMenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? description;
  final VoidCallback onTap;

  const DropUpMenuItemWidget({
    super.key,
    required this.icon,
    required this.label,
    this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      minVerticalPadding: 0.0,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      leading: Icon(icon,
          size: 20, color: Theme.of(context).iconTheme.color ?? Colors.black87),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (description != null) ...<Widget>[
            const SizedBox(height: 2.0),
            Text(
              description!,
              style: TextStyle(
                fontSize: 8,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
      subtitle: null,
      trailing: const Icon(
        Icons.chevron_right,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
      hoverColor: Colors.transparent, // Disable hover effect
    );
  }
}

class ShopCategoryData extends ChangeNotifier {
  final List<Map<String, dynamic>> categories = <Map<String, dynamic>>[
    {'name': 'All', 'icon': Icons.dashboard_outlined},
    {'name': 'Electronics', 'icon': Icons.electrical_services_outlined},
    {'name': 'Clothing', 'icon': Icons.checkroom_outlined},
    {'name': 'Books', 'icon': Icons.book_outlined},
    {'name': 'Home Decor', 'icon': Icons.home_outlined},
    {'name': 'Sports', 'icon': Icons.sports_soccer_outlined},
    {'name': 'Beauty', 'icon': Icons.spa_outlined},
  ];

  ShopCategoryData();
}

class ProfileScreen extends StatefulWidget {
  final String? userId;
  const ProfileScreen({Key? key, this.userId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool isFollowing = false;

  Map<String, dynamic>? userData;
  bool isLoading = true;

  /// Defines the structure and content of the drop-up menu.
  /// Each map represents either a 'section' header or an 'item'.
  static const List<Map<String, dynamic>> _menuData = <Map<String, dynamic>>[
    {
      'type': 'item',
      'icon': Icons.star_outline,
      'label': 'TikTok Studio',
      'description':
          'Access advanced tools for content creation and analytics.',
    },
    {
      'type': 'item',
      'icon': Icons.folder_open,
      'label': 'My Project',
      'description': 'Manage your ongoing creative projects and drafts.',
    },
    {
      'type': 'item',
      'icon': Icons.account_balance_wallet_outlined,
      'label': 'Balance',
      'description': 'Manage your earnings, rewards, and virtual gifts.',
    },
    {
      'type': 'item',
      'icon': Icons.qr_code_2_outlined,
      'label': 'My QR code',
      'description': 'Share your profile with others by scanning a QR code.',
    },
    {
      'type': 'item',
      'icon': Icons.palette_outlined,
      'label': 'Preferences',
      'description': 'Customize your app appearance and theme preferences.',
    },
    {
      'type': 'item',
      'icon': Icons.settings_outlined,
      'label': 'Settings and privacy',
      'description':
          'Control your account, app settings, and privacy preferences.',
    },
  ];

  void _showDropUpMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor ??
          (Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[850]
              : Colors.white),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 10), // Top padding
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.blue[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Removed the SizedBox(height: 10) here as requested
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      _menuData.map<Widget>((Map<String, dynamic> itemData) {
                    if (itemData['type'] == 'section') {
                      return DropUpSectionHeader(
                          title: itemData['title']! as String);
                    } else if (itemData['type'] == 'item') {
                      final DropUpMenuItemWidget itemWidget =
                          DropUpMenuItemWidget(
                        icon: itemData['icon']! as IconData,
                        label: itemData['label']! as String,
                        description: itemData['description'] as String?,
                        onTap: () {
                          Navigator.pop(context); // Close the bottom sheet

                          // Handle navigation based on the item
                          if (itemData['label'] == 'Preferences') {
                            _showPreferencesDialog(context);
                          } else if (itemData['label'] ==
                              'Settings and privacy') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsScreen(),
                              ),
                            );
                          } else if (itemData['label'] == 'Balance') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BalanceScreen(),
                              ),
                            );
                          } else if (itemData['label'] == 'TikTok Studio') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TikTokStudioScreen(),
                              ),
                            );
                          } else if (itemData['label'] == 'My Project') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyProjectScreen(),
                              ),
                            );
                          } else if (itemData['label'] == 'My QR code') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyQRCodeScreen(),
                              ),
                            );
                          }
                          // You can add more navigation cases here for other menu items
                        },
                      );

                      // Directly return the itemWidget without a wrapping box
                      return itemWidget;
                    }
                    return const SizedBox
                        .shrink(); // Fallback for unknown types
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 10), // Bottom padding
          ],
        );
      },
    );
  }

  void _showPreferencesDialog(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor ??
          (Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[850]
              : Colors.white),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.palette_outlined,
                    color: Colors.blue,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Preferences',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Customize your app appearance and settings',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 20),

              // Theme Mode Selection
              FutureBuilder<ThemeService>(
                future: ThemeService.getInstance(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ListTile(
                      leading: const Icon(Icons.palette_outlined),
                      title: const Text('Theme Mode'),
                      subtitle: const Text('Loading...'),
                      trailing: const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }

                  final themeService = snapshot.data!;
                  return AnimatedBuilder(
                    animation: themeService,
                    builder: (context, child) {
                      String currentTheme = 'System Default';
                      IconData currentIcon = Icons.auto_mode;
                      switch (themeService.themeMode) {
                        case ThemeMode.light:
                          currentTheme = 'Light Mode';
                          currentIcon = Icons.light_mode;
                          break;
                        case ThemeMode.dark:
                          currentTheme = 'Dark Mode';
                          currentIcon = Icons.dark_mode;
                          break;
                        case ThemeMode.system:
                          currentTheme = 'System Default';
                          currentIcon = Icons.auto_mode;
                          break;
                      }

                      return Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: Icon(
                            currentIcon,
                            color: Colors.blue,
                          ),
                          title: const Text(
                            'Theme Mode',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            currentTheme,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _showThemeSelectionDialog(context, themeService);
                          },
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              // Other preferences placeholders
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.language,
                        color: Colors.blue,
                      ),
                      title: const Text(
                        'Language',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'English',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Language settings coming soon!'),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.blue,
                      ),
                      title: const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'Manage notification preferences',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Notification preferences coming soon!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Footer
              Center(
                child: Text(
                  'Powered by CGC',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showThemeSelectionDialog(
      BuildContext context, ThemeService themeService) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Select Theme Mode',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeDialogOption(
                context: context,
                title: 'Light Mode',
                subtitle: 'Use light theme',
                icon: Icons.light_mode,
                themeMode: ThemeMode.light,
                themeService: themeService,
                isSelected: themeService.isLightMode,
              ),
              const SizedBox(height: 8),
              _buildThemeDialogOption(
                context: context,
                title: 'Dark Mode',
                subtitle: 'Use dark theme',
                icon: Icons.dark_mode,
                themeMode: ThemeMode.dark,
                themeService: themeService,
                isSelected: themeService.isDarkMode,
              ),
              const SizedBox(height: 8),
              _buildThemeDialogOption(
                context: context,
                title: 'System Default',
                subtitle: 'Follow system theme setting',
                icon: Icons.auto_mode,
                themeMode: ThemeMode.system,
                themeService: themeService,
                isSelected: themeService.isSystemMode,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildThemeDialogOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeMode themeMode,
    required ThemeService themeService,
    required bool isSelected,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.blue : Colors.grey[600],
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.blue : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: isSelected
            ? const Icon(
                Icons.check_circle,
                color: Colors.blue,
              )
            : null,
        onTap: () {
          themeService.setThemeMode(themeMode);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchUserData();
    checkIfFollowing();
  }

  Future<void> checkIfFollowing() async {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final targetUid = widget.userId ?? currentUid;
    if (currentUid != null && targetUid != null && currentUid != targetUid) {
      final currentUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .get();
      final following =
          currentUserDoc.data()?['following'] as List<dynamic>? ?? [];
      setState(() {
        isFollowing = following.contains(targetUid);
      });
    }
  }

  Future<void> handleFollowUnfollow() async {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final targetUid = widget.userId ?? currentUid;
    if (currentUid == null || targetUid == null || currentUid == targetUid)
      return;

    final currentUserRef =
        FirebaseFirestore.instance.collection('users').doc(currentUid);
    final targetUserRef =
        FirebaseFirestore.instance.collection('users').doc(targetUid);

    if (!isFollowing) {
      // Follow: add targetUid to current user's 'following', add currentUid to target user's 'followers'
      await currentUserRef.update({
        'following': FieldValue.arrayUnion([targetUid]),
      });
      await targetUserRef.update({
        'followers': FieldValue.arrayUnion([currentUid]),
      });
    } else {
      // Unfollow: remove targetUid from current user's 'following', remove currentUid from target user's 'followers'
      await currentUserRef.update({
        'following': FieldValue.arrayRemove([targetUid]),
      });
      await targetUserRef.update({
        'followers': FieldValue.arrayRemove([currentUid]),
      });
    }
    setState(() {
      isFollowing = !isFollowing;
    });
  }

  Future<void> fetchUserData() async {
    final uid = widget.userId ?? FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        setState(() {
          userData = doc.data();
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side icons
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LiveScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.live_tv,
                            color: Theme.of(context).iconTheme.color ??
                                Colors.black,
                            size: 23),
                        const SizedBox(height: 2),
                        Text(
                          'Live',
                          style: TextStyle(
                            fontSize: 8,
                            color:
                                Theme.of(context).textTheme.bodySmall?.color ??
                                    Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LifestyleScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.spa,
                            color: Theme.of(context).iconTheme.color ??
                                Colors.black,
                            size: 23),
                        const SizedBox(height: 2),
                        Text(
                          'Lifestyle',
                          style: TextStyle(
                            fontSize: 8,
                            color:
                                Theme.of(context).textTheme.bodySmall?.color ??
                                    Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GroupsScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.groups,
                            color: Theme.of(context).iconTheme.color ??
                                Colors.black,
                            size: 23),
                        const SizedBox(height: 2),
                        Text(
                          'Groups',
                          style: TextStyle(
                            fontSize: 8,
                            color:
                                Theme.of(context).textTheme.bodySmall?.color ??
                                    Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Center - empty space
            const Spacer(),
            // Right side icons
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.notifications,
                            color: Theme.of(context).iconTheme.color ??
                                Colors.black,
                            size: 23),
                        const SizedBox(height: 2),
                        Text(
                          'Notify',
                          style: TextStyle(
                            fontSize: 8,
                            color:
                                Theme.of(context).textTheme.bodySmall?.color ??
                                    Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MessengerScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.chat_bubble_outline,
                                color: Theme.of(context).iconTheme.color ??
                                    Colors.black,
                                size: 23),
                            const SizedBox(height: 2),
                            Text(
                              'Chat',
                              style: TextStyle(
                                fontSize: 8,
                                color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color ??
                                    Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chats')
                          .where('participants',
                              arrayContains:
                                  FirebaseAuth.instance.currentUser?.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const SizedBox.shrink();

                        int unreadCount = 0;
                        for (var doc in snapshot.data!.docs) {
                          final data = doc.data() as Map<String, dynamic>;
                          unreadCount += (data['unreadCount'] as int?) ?? 0;
                        }

                        if (unreadCount == 0) return const SizedBox.shrink();

                        return Positioned(
                          right: 8,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              unreadCount > 99 ? '99+' : unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.monetization_on_outlined,
                            color: Theme.of(context).iconTheme.color ??
                                Colors.black,
                            size: 23),
                        const SizedBox(height: 2),
                        Text(
                          'Payment',
                          style: TextStyle(
                            fontSize: 8,
                            color:
                                Theme.of(context).textTheme.bodySmall?.color ??
                                    Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _showDropUpMenu(context),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.menu,
                            color: Theme.of(context).iconTheme.color ??
                                Colors.black,
                            size: 23),
                        const SizedBox(height: 2),
                        Text(
                          'Menu',
                          style: TextStyle(
                            fontSize: 8,
                            color:
                                Theme.of(context).textTheme.bodySmall?.color ??
                                    Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Profile Image
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Name with verification badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          ((userData?['firstName'] ?? '') +
                                      (userData?['lastName'] != null &&
                                              userData?['lastName'] != ''
                                          ? ' ' + userData!['lastName']
                                          : ''))
                                  .trim()
                                  .isNotEmpty
                              ? ((userData?['firstName'] ?? '') +
                                      (userData?['lastName'] != null &&
                                              userData?['lastName'] != ''
                                          ? ' ' + userData!['lastName']
                                          : ''))
                                  .trim()
                              : 'No Name',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.color,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(1),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: <Color>[
                                Colors.purple,
                                Colors.pink,
                                Colors.orange,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  colors: <Color>[
                                    Colors.purple,
                                    Colors.pink,
                                    Colors.orange,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds);
                              },
                              child: const Icon(
                                Icons.verified,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Username
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '@${userData?['username'] ?? 'user'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color
                                    ?.withOpacity(0.7) ??
                                Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if ((widget.userId ??
                                FirebaseAuth.instance.currentUser?.uid) !=
                            FirebaseAuth.instance.currentUser?.uid) ...[
                          ElevatedButton(
                            onPressed: handleFollowUnfollow,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isFollowing ? Colors.white : Colors.blue,
                              foregroundColor:
                                  isFollowing ? Colors.black : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                                side: isFollowing
                                    ? BorderSide(color: Colors.grey[300]!)
                                    : BorderSide.none,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                if (!isFollowing) ...<Widget>[
                                  const Icon(Icons.add, size: 18),
                                  const SizedBox(width: 4),
                                ],
                                Text(isFollowing ? 'Following' : 'Follow'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            child: const Text('Message'),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _SmallStatItem(
                          value: (userData?['following'] is List)
                              ? (userData!['following'] as List)
                                  .length
                                  .toString()
                              : '0',
                          label: 'Following',
                        ),
                        _SmallStatItem(
                          value: (userData?['followers'] is List)
                              ? (userData!['followers'] as List)
                                  .length
                                  .toString()
                              : '0',
                          label: 'Followers',
                        ),
                        const _SmallStatItem(value: '1.2K', label: 'Likes'),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Location and link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          userData?['location'] ??
                              userData?['country'] ??
                              'No Location',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.link, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        const Text(
                          'kartikkhorwal.com',
                          style: TextStyle(fontSize: 14, color: Colors.blue),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    // Bio
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Building Websites and Webapps with Seamless User Experience Across Devices. '
                        'UI/UX Designer • Frontend Developer • Digital Creator\n\n'
                        'Currently working on exciting new projects!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[300]
                              : Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                Container(
                  alignment: Alignment.center,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                    tabs: const <Widget>[
                      Tab(icon: Icon(Icons.person_outline), text: 'Profile'),
                      Tab(icon: Icon(Icons.grid_on), text: 'Posts'),
                      Tab(icon: Icon(Icons.video_library), text: 'Reels'),
                      Tab(icon: Icon(Icons.shopping_bag), text: 'Shop'),
                    ],
                    indicatorColor: Colors.blue,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(fontSize: 12),
                    unselectedLabelStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            const ProfileTabContent(),
            const PostsGridContent(),
            const ReelsTabContent(),
            ChangeNotifierProvider<ShopCategoryData>(
              create: (BuildContext context) => ShopCategoryData(),
              builder: (BuildContext context, Widget? child) =>
                  const ShopTabContent(),
            ),
          ],
        ),
      ),
    );
  }
}

class ReelsTabContent extends StatelessWidget {
  const ReelsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Reels Content',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ShopTabContent extends StatefulWidget {
  const ShopTabContent({super.key});

  @override
  State<ShopTabContent> createState() => _ShopTabContentState();
}

class _ShopTabContentState extends State<ShopTabContent>
    with TickerProviderStateMixin {
  late TabController _shopTabController;
  late List<Map<String, dynamic>> _categories;

  @override
  void initState() {
    super.initState();
    _categories = context.read<ShopCategoryData>().categories;
    _shopTabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _shopTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Modern styled category selection Tab Bar
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]
                : Colors.white,
            borderRadius: BorderRadius.circular(12.0), // Added border radius
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.3)
                    : const Color.fromARGB(26, 158, 158, 158),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            // Added ClipRRect to ensure TabBar contents respect the border radius
            borderRadius: BorderRadius.circular(12.0),
            child: TabBar(
              controller: _shopTabController,
              isScrollable: true,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              labelPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Theme.of(context)
                    .primaryColor
                    .withAlpha((255 * 0.1).toInt()),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey[600],
              dividerColor:
                  Colors.transparent, // Removed the line under the TabBar
              tabs: _categories.map<Widget>((Map<String, dynamic> category) {
                return Tab(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        category['icon'] as IconData,
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category['name'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight:
                              FontWeight.normal, // Changed from FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Content based on selected category
        Expanded(
          child: TabBarView(
            controller: _shopTabController,
            children: _categories
                .map<Widget>(
                    (Map<String, dynamic> categoryData) => CategoryViewContent(
                          category: categoryData,
                        ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class CategoryViewContent extends StatelessWidget {
  const CategoryViewContent({
    required this.category,
    super.key,
  });

  final Map<String, dynamic> category;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Showing items for: ${category['name']}',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SmallStatItem extends StatelessWidget {
  const _SmallStatItem({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: const TextStyle(
            fontSize: 16, // Changed from 18 to 16
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._widget);

  final Widget _widget;

  @override
  double get minExtent => 72.0; // Increased height to accommodate the TabBar

  @override
  double get maxExtent => 72.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[900]
          : Colors.white,
      child: _widget,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class ProfileTabContent extends StatelessWidget {
  const ProfileTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Profile Content',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class PostsGridContent extends StatelessWidget {
  const PostsGridContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Posts Content',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
