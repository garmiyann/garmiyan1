/// User model representing a user in the application
class UserModel {
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

  const UserModel({
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

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      profileImage: json['profile_image'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      isEmailVerified: json['is_email_verified'] as bool? ?? false,
      isPhoneVerified: json['is_phone_verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'profile_image': profileImage,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'address': address,
      'city': city,
      'country': country,
      'is_email_verified': isEmailVerified,
      'is_phone_verified': isPhoneVerified,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with modified fields
  UserModel copyWith({
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
    return UserModel(
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

  /// Get display name (name or email)
  String get displayName => name ?? email;

  /// Get full address
  String? get fullAddress {
    final parts = [address, city, country]
        .where((part) => part != null && part.isNotEmpty);
    return parts.isNotEmpty ? parts.join(', ') : null;
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
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
