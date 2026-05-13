import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../constants/app_constants.dart';
import '../../models/user_model.dart';
import '../../services/logger_service.dart';
import '../../services/secure_storage_service.dart';
import '../base_api/api_helper.dart';
import '../base_api/api_response.dart';

class AuthService {
  final ApiHelper _apiHelper = ApiHelper();
  final LoggingService _logger = LoggingService.instance;
  final SecureStorageService _storage = SecureStorageService();

  /// 🔐 Login API
  Future<ApiResponse<UserModel>> login({
    required String email,
    required String password,
  }) async {
    final body = {"email": email, "password": password};
    _logger.logAuth('Attempting login for: $email');
    
    final response = await _apiHelper.post<Map<String, dynamic>>('auth/login', body);
    
    if (response.success && response.data != null) {
      final userData = response.data!;
      final user = UserModel.fromJson(userData);
      
      // Save data to secure storage
      await _storage.saveUserData(
        token: userData['token'],
        userId: userData['_id'],
        username: userData['username'],
        email: userData['email'],
        role: userData['role'],
        profileImage: userData['profileImage'],
        college: userData['college'],
      );
      
      return ApiResponse.success(user);
    }
    return ApiResponse.error(response.message ?? 'Login failed');
  }

  /// 📝 Signup API
  Future<ApiResponse<UserModel>> signup({
    required String username,
    required String email,
    required String password,
    required String college,
    UserRole role = UserRole.buyer,
  }) async {
    final body = {
      "username": username,
      "email": email,
      "password": password,
      "college": college,
      "role": role.name,
    };
    
    final response = await _apiHelper.post<Map<String, dynamic>>('auth/signup', body);
    
    if (response.success && response.data != null) {
      final userData = response.data!;
      final user = UserModel.fromJson(userData);
      
      // Save data to secure storage
      await _storage.saveUserData(
        token: userData['token'],
        userId: userData['_id'],
        username: userData['username'],
        email: userData['email'],
        role: userData['role'],
        profileImage: userData['profileImage'],
        college: userData['college'],
      );
      
      return ApiResponse.success(user);
    }
    return ApiResponse.error(response.message ?? 'Signup failed');
  }

  /// 👤 Get User Profile Info
  Future<ApiResponse<UserModel>> getUserProfile() async {
    final response = await _apiHelper.get<Map<String, dynamic>>('auth/profile');

    if (response.success && response.data != null) {
      final user = UserModel.fromJson(response.data!);
      
      // Sync local storage with latest data
      await _storage.saveUserData(
        token: (await _storage.getToken())!,
        userId: user.id,
        username: user.username,
        email: user.email,
        role: user.role.name,
        profileImage: user.profileImage,
        college: user.college,
      );
      
      return ApiResponse.success(user);
    }
    return ApiResponse.error(response.message ?? 'Profile not found');
  }

  /// 📊 Get User Stats (Ads count, Earnings)
  Future<ApiResponse<Map<String, dynamic>>> getUserStats() async {
    final response = await _apiHelper.get<Map<String, dynamic>>('auth/stats');
    if (response.success && response.data != null) {
      return ApiResponse.success(response.data!);
    }
    return ApiResponse.error(response.message ?? 'Stats not found');
  }

  /// ✏️ Update Profile (Photo ya Name badalne ke liye)
  Future<ApiResponse<UserModel>> updateProfile({
    String? username,
    String? college,
    String? role,
    File? profileImage,
  }) async {
    final Map<String, String> fields = {};
    if (username != null) fields['username'] = username;
    if (college != null) fields['college'] = college;
    if (role != null) fields['role'] = role;

    final Map<String, String> files = {};
    if (profileImage != null) {
      files['profileImage'] = profileImage.path;
    }

    final response = await _apiHelper.multipartRequest<Map<String, dynamic>>(
      'PUT',
      'auth/profile',
      fields: fields,
      files: files,
    );

    if (response.success && response.data != null) {
      final userData = response.data!;
      final user = UserModel.fromJson(userData);
      
      final token = await _storage.getToken();
      
      // Sync local storage
      await _storage.saveUserData(
        token: token!,
        userId: user.id,
        username: user.username,
        email: user.email,
        role: user.role.name,
        profileImage: user.profileImage,
        college: user.college,
      );
      
      return ApiResponse.success(user);
    }
    return ApiResponse.error(response.message ?? 'Failed to update profile');
  }
}
