import 'package:flutter/material.dart';

// Data model for profile information
class ProfileData extends ChangeNotifier {
  String _name;
  String _username;
  String _phoneNumber;
  String _profileImageUrl;
  bool _isPremium;

  ProfileData({
    required String name,
    required String username,
    required String phoneNumber,
    required String profileImageUrl,
    bool isPremium = false,
  })  : _name = name,
        _username = username,
        _phoneNumber = phoneNumber,
        _profileImageUrl = profileImageUrl,
        _isPremium = isPremium;

  String get name => _name;
  String get username => _username;
  String get phoneNumber => _phoneNumber;
  String get profileImageUrl => _profileImageUrl;
  bool get isPremium => _isPremium;

  void updateProfile({
    String? newName,
    String? newUsername,
    String? newPhoneNumber,
    String? newProfileImageUrl,
  }) {
    if (newName != null) {
      _name = newName;
    }
    if (newUsername != null) {
      _username = newUsername;
    }
    if (newPhoneNumber != null) {
      _phoneNumber = newPhoneNumber;
    }
    if (newProfileImageUrl != null) {
      _profileImageUrl = newProfileImageUrl;
    }
    notifyListeners();
  }

  void activatePremium() {
    _isPremium = true;
    notifyListeners();
  }

  void deactivatePremium() {
    _isPremium = false;
    notifyListeners();
  }
}

// Data model for an account item
class AccountItemData {
  final String title;
  final String imageUrl;
  final String badge;
  final String? description;

  AccountItemData({
    required this.title,
    required this.imageUrl,
    required this.badge,
    this.description,
  });
}

// Data model for a settings tile
class SettingTileData {
  final IconData icon;
  final String title;
  final String? trailing;
  final String? description;
  final IconData? trailingIcon;
  final VoidCallback? onTap;

  SettingTileData({
    required this.icon,
    required this.title,
    this.trailing,
    this.description,
    this.trailingIcon,
    this.onTap,
  });
}

// Data model for a settings section
class SettingsSectionData {
  final String title;
  final List<SettingTileData> children;

  SettingsSectionData({
    required this.title,
    required this.children,
  });
}

// Data model for profile subscription information
class ProfileSubscriptionData {
  final String title;
  final String status;
  final List<String> benefits;
  final String actionText;
  final IconData actionIcon;
  final String? expiryDate;
  final String? price;
  final String? signatureText;

  ProfileSubscriptionData({
    required this.title,
    required this.status,
    required this.benefits,
    required this.actionText,
    required this.actionIcon,
    this.expiryDate,
    this.price,
    this.signatureText,
  });
}
