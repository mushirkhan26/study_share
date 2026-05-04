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

  /// ✅ User Data Save Karein (Login ke baad)
  Future<void> saveUserData({
    required String token,
    required String userId,
    required String username,
    required String email,
    String? profileImage,
  }) async {
    await _secureStorage.write(key: _keyToken, value: token);
    await _secureStorage.write(key: _keyUserId, value: userId);
    await _secureStorage.write(key: _keyUsername, value: username);
    await _secureStorage.write(key: _keyEmail, value: email);
    if (profileImage != null) {
      await _secureStorage.write(key: _keyProfileImage, value: profileImage);
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
      "profileImage": await _secureStorage.read(key: _keyProfileImage),
    };
  }
  /// 📥 Token nikalne ke liye (Jo ApiHelper use karega)
  Future<String?> getToken() async => await _secureStorage.read(key: _keyToken);

  /// 🧽 Logout ke liye sara data delete karein
  Future<void> clearAll() async => await _secureStorage.deleteAll();

  // Individual Getters
  Future<String?> getUsername() async => await _secureStorage.read(key: _keyUsername);
  Future<String?> getUserId() async => await _secureStorage.read(key: _keyUserId);
}