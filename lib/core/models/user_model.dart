enum UserRole {
  buyer,
  seller,
}

extension UserRoleExtension on UserRole {
  String get name => toString().split('.').last;

  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (e) => e.name == role.toLowerCase(),
      orElse: () => UserRole.buyer,
    );
  }
}

class UserModel {
  final String id;
  final String username;
  final String email;
  final String? profileImage;
  final String? bio;
  final String? college; 
  final String? phoneNumber;
  final String? createdAt;
  final UserRole role;
  final bool isTwoFactorEnabled;
  final bool isPrivateProfile;
  final bool showPhoneNumber;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.profileImage,
    this.bio,
    this.college,
    this.phoneNumber,
    this.createdAt,
    this.role = UserRole.buyer,
    this.isTwoFactorEnabled = false,
    this.isPrivateProfile = false,
    this.showPhoneNumber = false,
  });

  bool get isSeller => role == UserRole.seller;
  bool get isBuyer => role == UserRole.buyer;

  // 📥 Backend JSON ko Flutter Object mein badalne ke liye
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      username: json['username'] ?? 'User',
      email: json['email'] ?? '',
      profileImage: json['profileImage'],
      bio: json['bio'],
      college: json['college'],
      phoneNumber: json['phoneNumber'],
      createdAt: json['createdAt'],
      role: UserRoleExtension.fromString(json['role'] ?? 'buyer'),
      isTwoFactorEnabled: json['isTwoFactorEnabled'] ?? false,
      isPrivateProfile: json['isPrivateProfile'] ?? false,
      showPhoneNumber: json['showPhoneNumber'] ?? false,
    );
  }

  // 📤 Object ko wapas JSON mein badalne ke liye (Update Profile ke waqt)
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'profileImage': profileImage,
      'bio': bio,
      'college': college,
      'phoneNumber': phoneNumber,
      'role': role.name,
      'isTwoFactorEnabled': isTwoFactorEnabled,
      'isPrivateProfile': isPrivateProfile,
      'showPhoneNumber': showPhoneNumber,
    };
  }

  // 🔄 Profile update karte waqt agar sirf kuch fields badalni ho
  UserModel copyWith({
    String? username,
    String? profileImage,
    String? bio,
    String? college,
    String? phoneNumber,
    UserRole? role,
    bool? isTwoFactorEnabled,
    bool? isPrivateProfile,
    bool? showPhoneNumber,
  }) {
    return UserModel(
      id: id,
      username: username ?? this.username,
      email: email,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      college: college ?? this.college,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt,
      role: role ?? this.role,
      isTwoFactorEnabled: isTwoFactorEnabled ?? this.isTwoFactorEnabled,
      isPrivateProfile: isPrivateProfile ?? this.isPrivateProfile,
      showPhoneNumber: showPhoneNumber ?? this.showPhoneNumber,
    );
  }
}
