/// User entity representing the business logic user model
class User {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String? profileImage;
  final DateTime? dateOfBirth;
  final String? address;
  final String? city;
  final String? country;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.profileImage,
    this.dateOfBirth,
    this.address,
    this.city,
    this.country,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get display name (name or email)
  String get displayName => name ?? email;

  /// Get full address
  String? get fullAddress {
    final parts = [address, city, country]
        .where((part) => part != null && part.isNotEmpty);
    return parts.isNotEmpty ? parts.join(', ') : null;
  }

  /// Check if profile is complete
  bool get isProfileComplete {
    return name != null &&
        phone != null &&
        address != null &&
        city != null &&
        country != null;
  }

  /// Get completion percentage
  double get profileCompletionPercentage {
    int completedFields = 0;
    int totalFields = 6; // name, phone, address, city, country, profileImage

    if (name != null && name!.isNotEmpty) completedFields++;
    if (phone != null && phone!.isNotEmpty) completedFields++;
    if (address != null && address!.isNotEmpty) completedFields++;
    if (city != null && city!.isNotEmpty) completedFields++;
    if (country != null && country!.isNotEmpty) completedFields++;
    if (profileImage != null && profileImage!.isNotEmpty) completedFields++;

    return (completedFields / totalFields) * 100;
  }

  /// Create a copy with modified fields
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? profileImage,
    DateTime? dateOfBirth,
    String? address,
    String? city,
    String? country,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.phone == phone &&
        other.profileImage == profileImage &&
        other.dateOfBirth == dateOfBirth &&
        other.address == address &&
        other.city == city &&
        other.country == country &&
        other.isEmailVerified == isEmailVerified &&
        other.isPhoneVerified == isPhoneVerified &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      email,
      name,
      phone,
      profileImage,
      dateOfBirth,
      address,
      city,
      country,
      isEmailVerified,
      isPhoneVerified,
      createdAt,
      updatedAt,
    );
  }
}
