class UserModel {
  final String id;
  final String username;
  final String email;
  final String? profileImage;
  final String? bio;
  final String? college; // Aap BCA kar rahe hain toh ye field kaam aayegi
  final String? createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.profileImage,
    this.bio,
    this.college,
    this.createdAt,
  });

  // 📥 Backend JSON ko Flutter Object mein badalne ke liye
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      username: json['username'] ?? 'User',
      email: json['email'] ?? '',
      profileImage: json['profileImage'],
      bio: json['bio'],
      college: json['college'],
      createdAt: json['createdAt'],
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
    };
  }

  // 🔄 Profile update karte waqt agar sirf kuch fields badalni ho
  UserModel copyWith({
    String? username,
    String? profileImage,
    String? bio,
    String? college,
  }) {
    return UserModel(
      id: id,
      username: username ?? this.username,
      email: email,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      college: college ?? this.college,
      createdAt: createdAt,
    );
  }
}