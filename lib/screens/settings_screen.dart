import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/profile_data.dart';
import 'manage_subscription_screen.dart';
import 'buy_subscription_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileData>(
      create: (BuildContext context) => ProfileData(
        name: 'Ahmad Karim',
        username: '@Ahmadkarim23',
        phoneNumber: '+964 785 312 3668',
        profileImageUrl:
            'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
        isPremium: false, // Default to non-premium to show buy subscription box
      ),
      child: const TelegramSettingsPage(),
    );
  }
}

class TelegramSettingsPage extends StatelessWidget {
  const TelegramSettingsPage({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate back to login page and clear all routes
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (Route<dynamic> route) => false,
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  ProfileSubscriptionData get _profileSubscriptionData =>
      ProfileSubscriptionData(
        title: 'Telegram Premium',
        status: 'Active',
        benefits: <String>[
          'No Ads',
          'Larger Uploads (4 GB)',
          'Faster Downloads',
          'Exclusive Stickers',
          'Voice-to-Text for Voice Messages',
          'Unique Reaction Emojis',
        ],
        actionText: 'Manage Subscription',
        actionIcon: Icons.arrow_forward_ios,
        expiryDate: '2025-08-15',
        price: '\$4.99/month',
        signatureText: 'Premium',
      );

  List<SettingsSectionData> _settingsSections(BuildContext context) =>
      <SettingsSectionData>[
        SettingsSectionData(
          title: "General",
          children: <SettingTileData>[
            SettingTileData(
                icon: Icons.person_outline,
                title: 'My Profile',
                description: 'Edit your profile info',
                trailingIcon: Icons.chevron_right),
            SettingTileData(
                icon: Icons.bookmark_outline,
                title: 'Saved Messages',
                description: 'View your saved items',
                trailingIcon: Icons.chevron_right),
            SettingTileData(
                icon: Icons.phone_outlined,
                title: 'Recent Calls',
                description: 'Check your call history',
                trailingIcon: Icons.chevron_right),
            SettingTileData(
                icon: Icons.devices_other_outlined,
                title: 'Devices',
                trailing: '4',
                description: 'Manage active sessions',
                trailingIcon: Icons.chevron_right),
            SettingTileData(
                icon: Icons.folder_open_outlined,
                title: 'Chat Folders',
                description: 'Organize your chats',
                trailingIcon: Icons.chevron_right),
          ],
        ),
        SettingsSectionData(
          title: "Account",
          children: <SettingTileData>[
            SettingTileData(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                description: 'Change your name and username',
                trailingIcon: Icons.chevron_right),
            SettingTileData(
                icon: Icons.lock_open_outlined,
                title: 'Privacy Controls',
                description: 'Manage your account privacy',
                trailingIcon: Icons.chevron_right),
            SettingTileData(
                icon: Icons.phone_android_outlined,
                title: 'Phone Number',
                description: 'Update your contact number',
                trailingIcon: Icons.chevron_right),
            SettingTileData(
                icon: Icons.vpn_key_outlined,
                title: 'Two-Step Verification',
                description: 'Add an extra layer of security',
                trailingIcon: Icons.chevron_right),
            SettingTileData(
                icon: Icons.delete_outline,
                title: 'Delete Account',
                description: 'Permanently remove your account',
                trailingIcon: Icons.chevron_right),
          ],
        ),
        SettingsSectionData(
          title: "Preferences",
          children: <SettingTileData>[
            SettingTileData(
                icon: Icons.notifications_none_outlined,
                title: 'Notifications and Sounds',
                description: 'Customize alerts'),
            SettingTileData(
                icon: Icons.lock_outline,
                title: 'Privacy and Security',
                description: 'Control your privacy settings'),
            SettingTileData(
                icon: Icons.storage_outlined,
                title: 'Data and Storage',
                description: 'Manage media and cache'),
          ],
        ),
        SettingsSectionData(
          title: "Account Actions",
          children: <SettingTileData>[
            SettingTileData(
                icon: Icons.logout,
                title: 'Log Out',
                description: 'Sign out from this account',
                trailingIcon: Icons.chevron_right,
                onTap: () {
                  _showLogoutDialog(context);
                }),
          ],
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final ProfileData profileData = Provider.of<ProfileData>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Settings and Privacy',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: <Widget>[
          // Telegram logo
          Center(
            child: Container(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(20),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'TELEGRAM',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 24),

          /// Profile Section Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
                BoxShadow(
                  color: Colors.blue.withOpacity(0.15),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 35,
                      backgroundImage:
                          NetworkImage(profileData.profileImageUrl),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            profileData.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profileData.username,
                            style: TextStyle(
                                color: Colors.grey.shade700, fontSize: 10),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            profileData.phoneNumber,
                            style: TextStyle(
                                color: Colors.grey.shade700, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            profileData.updateProfile(
                                newProfileImageUrl:
                                    'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg');
                          },
                          icon: const Icon(Icons.camera_alt_outlined,
                              color: Colors.blue),
                          label: const Text("Change Photo",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 12)),
                        ),
                      ),
                      // Demo button to toggle premium status
                      TextButton.icon(
                        onPressed: () {
                          if (profileData.isPremium) {
                            profileData.deactivatePremium();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Premium deactivated (Demo)')),
                            );
                          } else {
                            profileData.activatePremium();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Premium activated! (Demo)')),
                            );
                          }
                        },
                        icon: Icon(
                          profileData.isPremium
                              ? Icons.diamond
                              : Icons.diamond_outlined,
                          color: profileData.isPremium
                              ? Colors.amber
                              : Colors.grey,
                        ),
                        label: Text(
                          profileData.isPremium ? "Premium" : "Demo",
                          style: TextStyle(
                            color: profileData.isPremium
                                ? Colors.amber
                                : Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Subscription Box - shows different content based on premium status
          profileData.isPremium
              ? ProfileSubscriptionBox(data: _profileSubscriptionData)
              : const BuySubscriptionBox(),

          const SizedBox(height: 24),

          /// Settings Groups
          ..._settingsSections(context)
              .map<Widget>(
                  (SettingsSectionData data) => SettingsSection(data: data))
              .expand<Widget>((Widget widget) =>
                  <Widget>[widget, const SizedBox(height: 16)])
              .take(_settingsSections(context).length * 2 - 1)
              .toList(),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}

class AccountItem extends StatelessWidget {
  const AccountItem({required this.data, super.key});

  final AccountItemData data;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(data.imageUrl)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(data.title,
              style: const TextStyle(color: Colors.black, fontSize: 12)),
          if (data.description != null)
            Text(
              data.description!,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
            ),
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(data.badge, style: const TextStyle(color: Colors.white)),
      ),
      onTap: () {},
    );
  }
}

// ProfileSubscriptionBox widget with redesigned style
class ProfileSubscriptionBox extends StatelessWidget {
  const ProfileSubscriptionBox({required this.data, super.key});

  final ProfileSubscriptionData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[
            Color(0xFF1E3C72), // Blue gradient
            Color(0xFF2A5298), // Lighter blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: const Color(0xFF2A5298).withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(Icons.diamond, color: Colors.amber, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          data.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data.status,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ManageSubscriptionScreen(
                        onCancelComplete: () {
                          // Update the current screen's ProfileData
                          final profileData =
                              Provider.of<ProfileData>(context, listen: false);
                          profileData.deactivatePremium();
                        },
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(data.actionIcon,
                          size: 16, color: Colors.cyanAccent.shade100),
                      const SizedBox(width: 8),
                      Text(
                        data.actionText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.cyanAccent.shade100,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Signature on top right box
          if (data.signatureText != null)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  data.signatureText!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Buy Subscription Box for non-premium users
class BuySubscriptionBox extends StatelessWidget {
  const BuySubscriptionBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[
            Color(0xFF1E3C72), // Blue gradient
            Color(0xFF2A5298), // Lighter blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: const Color(0xFF2A5298).withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.diamond_outlined, color: Colors.amber, size: 28),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Telegram Premium',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Unlock exclusive features',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'UPGRADE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Benefits preview
          const Row(
            children: <Widget>[
              Icon(Icons.block, color: Colors.white70, size: 16),
              SizedBox(width: 8),
              Text('No Ads',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
              SizedBox(width: 20),
              Icon(Icons.cloud_upload, color: Colors.white70, size: 16),
              SizedBox(width: 8),
              Text('4GB Uploads',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: <Widget>[
              Icon(Icons.speed, color: Colors.white70, size: 16),
              SizedBox(width: 8),
              Text('Faster Downloads',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
              SizedBox(width: 20),
              Icon(Icons.emoji_emotions, color: Colors.white70, size: 16),
              SizedBox(width: 8),
              Text('Premium Stickers',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),

          const SizedBox(height: 16),

          // Buy button
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BuySubscriptionScreen(
                    onPurchaseComplete: () {
                      // Update the current screen's ProfileData
                      final profileData =
                          Provider.of<ProfileData>(context, listen: false);
                      profileData.activatePremium();
                    },
                  ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.shopping_cart,
                      size: 16, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text(
                    'Get Premium',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward,
                      size: 16, color: Colors.white.withOpacity(0.8)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  const SettingsSection({required this.data, super.key});

  final SettingsSectionData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(data.title.toUpperCase(),
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
          ),
          ...data.children
              .map<Widget>(
                  (SettingTileData tileData) => SettingTile(data: tileData))
              .expand<Widget>((Widget widget) => <Widget>[
                    widget,
                    Divider(color: Colors.grey.shade200, height: 1)
                  ])
              .take(data.children.length * 2 - 1)
              .toList(),
        ],
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  const SettingTile({required this.data, super.key});

  final SettingTileData data;

  @override
  Widget build(BuildContext context) {
    final List<Widget> trailingWidgets = <Widget>[];

    // Add trailing text if present
    if (data.trailing != null) {
      trailingWidgets.add(
          Text(data.trailing!, style: TextStyle(color: Colors.grey.shade600)));
    }

    // Add trailing icon if present
    if (data.trailingIcon != null) {
      if (trailingWidgets.isNotEmpty) {
        trailingWidgets.add(const SizedBox(width: 4));
      }
      trailingWidgets
          .add(Icon(data.trailingIcon!, color: Colors.grey.shade600, size: 18));
    }

    return ListTile(
      leading: Icon(data.icon, color: Colors.grey.shade700),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(data.title,
              style: const TextStyle(color: Colors.black, fontSize: 11)),
          if (data.description != null)
            Text(
              data.description!,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
            ),
        ],
      ),
      trailing: trailingWidgets.isNotEmpty
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: trailingWidgets,
            )
          : null,
      onTap: data.onTap ?? () {},
    );
  }
}
