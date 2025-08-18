import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/profile_data.dart';
import 'settings_screen.dart';

class SettingsWrapper extends StatelessWidget {
  final String? name;
  final String? username;
  final String? phoneNumber;
  final String? profileImageUrl;

  const SettingsWrapper({
    super.key,
    this.name,
    this.username,
    this.phoneNumber,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Check if ProfileData already exists in the widget tree
    try {
      Provider.of<ProfileData>(context, listen: false);
      // If we reach here, Provider already exists, just return SettingsScreen
      return const SettingsScreen();
    } catch (e) {
      // Provider doesn't exist, create it
      return ChangeNotifierProvider<ProfileData>(
        create: (BuildContext context) => ProfileData(
          name: name ?? 'User',
          username: username ?? '@user',
          phoneNumber: phoneNumber ?? '+964 xxx xxx xxxx',
          profileImageUrl: profileImageUrl ?? '',
          isPremium: false, // Default to non-premium
        ),
        child: const SettingsScreen(),
      );
    }
  }
}
