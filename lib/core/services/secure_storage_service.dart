import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  SecureStorageService._internal();

  // 🔑 Keys (Study App Relevant)
  static const String _keyToken = 'auth_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUsername = 'username';
  static const String _keyEmail = 'email';
  static const String _keyProfileImage = 'profile_image';
  static const String _keyRole = 'user_role';
  static const String _keyCollege = 'college';
  static const String _keyPhone = 'phone_number';
  static const String _keyTheme = 'theme_mode';
  static const String _key2FA = 'is_2fa_enabled';
  static const String _keyPrivateProfile = 'is_private_profile';
  static const String _keyShowPhone = 'show_phone_number';
  static const String _keyLanguage = 'language_code';

  /// ✅ User Data Save Karein (Login ke baad)
  Future<void> saveUserData({
    required String token,
    required String userId,
    required String username,
    required String email,
    required String role,
    String? profileImage,
    String? college,
    String? phoneNumber,
    bool? isTwoFactorEnabled,
    bool? isPrivateProfile,
    bool? showPhoneNumber,
  }) async {
    await _secureStorage.write(key: _keyToken, value: token);
    await _secureStorage.write(key: _keyUserId, value: userId);
    await _secureStorage.write(key: _keyUsername, value: username);
    await _secureStorage.write(key: _keyEmail, value: email);
    await _secureStorage.write(key: _keyRole, value: role);
    if (profileImage != null) {
      await _secureStorage.write(key: _keyProfileImage, value: profileImage);
    }
    if (college != null) {
      await _secureStorage.write(key: _keyCollege, value: college);
    }
    if (phoneNumber != null) {
      await _secureStorage.write(key: _keyPhone, value: phoneNumber);
    }
    if (isTwoFactorEnabled != null) {
      await _secureStorage.write(key: _key2FA, value: isTwoFactorEnabled.toString());
    }
    if (isPrivateProfile != null) {
      await _secureStorage.write(key: _keyPrivateProfile, value: isPrivateProfile.toString());
    }
    if (showPhoneNumber != null) {
      await _secureStorage.write(key: _keyShowPhone, value: showPhoneNumber.toString());
    }
  }

  /// 📥 Pura User Data ek saath nikalne ke liye (Map format mein)
  Future<Map<String, dynamic>?> getUserData() async {
    final token = await _secureStorage.read(key: _keyToken);

    // Agar token nahi hai, iska matlab user logged in nahi hai
    if (token == null) return null;

    return {
      "token": token,
      "userId": await _secureStorage.read(key: _keyUserId),
      "username": await _secureStorage.read(key: _keyUsername),
      "email": await _secureStorage.read(key: _keyEmail),
      "role": await _secureStorage.read(key: _keyRole),
      "profileImage": await _secureStorage.read(key: _keyProfileImage),
      "college": await _secureStorage.read(key: _keyCollege),
      "phoneNumber": await _secureStorage.read(key: _keyPhone),
      "isTwoFactorEnabled": await _secureStorage.read(key: _key2FA),
      "isPrivateProfile": await _secureStorage.read(key: _keyPrivateProfile),
      "showPhoneNumber": await _secureStorage.read(key: _keyShowPhone),
    };
  }

  /// 📥 Token nikalne ke liye (Jo ApiHelper use karega)
  Future<String?> getToken() async => await _secureStorage.read(key: _keyToken);

  /// 📥 Role nikalne ke liye
  Future<String?> getRole() async => await _secureStorage.read(key: _keyRole);

  /// 🧽 Logout ke liye sara data delete karein
  Future<void> logout() async => await _secureStorage.deleteAll();

  // Individual Getters
  Future<String?> getUsername() async => await _secureStorage.read(key: _keyUsername);
  Future<String?> getUserId() async => await _secureStorage.read(key: _keyUserId);

  /// 🎨 Theme Management
  Future<void> saveThemeMode(String theme) async => await _secureStorage.write(key: _keyTheme, value: theme);
  Future<String?> getThemeMode() async => await _secureStorage.read(key: _keyTheme);

  /// 🌍 Language Management
  Future<void> saveLanguageCode(String code) async => await _secureStorage.write(key: _keyLanguage, value: code);
  Future<String?> getLanguageCode() async => await _secureStorage.read(key: _keyLanguage);
}
