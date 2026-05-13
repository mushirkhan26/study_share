import 'dart:io';
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
      final data = response.data!;
      
      // If 2FA is required, don't save data yet
      if (data['requires2FA'] == true) {
        return ApiResponse.success(UserModel(id: '', username: '', email: email), message: '2FA_REQUIRED');
      }

      final user = UserModel.fromJson(data);
      
      // Save data to secure storage
      await _storage.saveUserData(
        token: data['token'],
        userId: data['_id'],
        username: data['username'],
        email: data['email'],
        role: data['role'],
        profileImage: data['profileImage'],
        college: data['college'],
        phoneNumber: data['phoneNumber'],
        isTwoFactorEnabled: data['isTwoFactorEnabled'],
        isPrivateProfile: data['isPrivateProfile'],
        showPhoneNumber: data['showPhoneNumber'],
      );
      
      return ApiResponse.success(user);
    }
    return ApiResponse.error(response.message ?? 'Login failed');
  }

  /// 🔑 Verify 2FA OTP
  Future<ApiResponse<UserModel>> verify2FA({
    required String email,
    required String otp,
  }) async {
    final body = {"email": email, "otp": otp};
    final response = await _apiHelper.post<Map<String, dynamic>>('auth/verify-2fa', body);

    if (response.success && response.data != null) {
      final data = response.data!;
      final user = UserModel.fromJson(data);
      
      await _storage.saveUserData(
        token: data['token'],
        userId: data['_id'],
        username: data['username'],
        email: data['email'],
        role: data['role'],
        profileImage: data['profileImage'],
        college: data['college'],
        phoneNumber: data['phoneNumber'],
        isTwoFactorEnabled: data['isTwoFactorEnabled'],
        isPrivateProfile: data['isPrivateProfile'],
        showPhoneNumber: data['showPhoneNumber'],
      );
      
      return ApiResponse.success(user);
    }
    return ApiResponse.error(response.message ?? 'Verification failed');
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
      final data = response.data!;
      final user = UserModel.fromJson(data);
      
      // Save data to secure storage
      await _storage.saveUserData(
        token: data['token'],
        userId: data['_id'],
        username: data['username'],
        email: data['email'],
        role: data['role'],
        profileImage: data['profileImage'],
        college: data['college'],
        phoneNumber: data['phoneNumber'],
        isTwoFactorEnabled: data['isTwoFactorEnabled'],
        isPrivateProfile: data['isPrivateProfile'],
        showPhoneNumber: data['showPhoneNumber'],
      );
      
      return ApiResponse.success(user);
    }
    return ApiResponse.error(response.message ?? 'Signup failed');
  }

  /// 👤 Get User Profile Info
  Future<ApiResponse<UserModel>> getUserProfile() async {
    final response = await _apiHelper.get<Map<String, dynamic>>('auth/profile');

    if (response.success && response.data != null) {
      final data = response.data!;
      final user = UserModel.fromJson(data);
      
      // Sync local storage with latest data
      await _storage.saveUserData(
        token: (await _storage.getToken())!,
        userId: user.id,
        username: user.username,
        email: user.email,
        role: user.role.name,
        profileImage: user.profileImage,
        college: user.college,
        phoneNumber: user.phoneNumber,
        isTwoFactorEnabled: user.isTwoFactorEnabled,
        isPrivateProfile: user.isPrivateProfile,
        showPhoneNumber: user.showPhoneNumber,
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
    String? phoneNumber,
    String? role,
    File? profileImage,
  }) async {
    final Map<String, String> fields = {};
    if (username != null) fields['username'] = username;
    if (college != null) fields['college'] = college;
    if (phoneNumber != null) fields['phoneNumber'] = phoneNumber;
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
      final data = response.data!;
      final user = UserModel.fromJson(data);
      
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
        phoneNumber: user.phoneNumber,
        isTwoFactorEnabled: user.isTwoFactorEnabled,
        isPrivateProfile: user.isPrivateProfile,
        showPhoneNumber: user.showPhoneNumber,
      );
      
      return ApiResponse.success(user);
    }
    return ApiResponse.error(response.message ?? 'Failed to update profile');
  }
  /// 🔐 Change Password
  Future<ApiResponse<String>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final body = {"oldPassword": oldPassword, "newPassword": newPassword};
    final response = await _apiHelper.put<Map<String, dynamic>>('auth/change-password', body);

    if (response.success) {
      return ApiResponse.success(response.message ?? 'Password updated');
    }
    return ApiResponse.error(response.message ?? 'Failed to update password');
  }

  /// ⚙️ Update Privacy/Security Settings
  Future<ApiResponse<Map<String, dynamic>>> updateSettings({
    bool? isTwoFactorEnabled,
    bool? isPrivateProfile,
    bool? showPhoneNumber,
  }) async {
    final Map<String, dynamic> body = {};
    if (isTwoFactorEnabled != null) body['isTwoFactorEnabled'] = isTwoFactorEnabled;
    if (isPrivateProfile != null) body['isPrivateProfile'] = isPrivateProfile;
    if (showPhoneNumber != null) body['showPhoneNumber'] = showPhoneNumber;

    final response = await _apiHelper.put<Map<String, dynamic>>('auth/settings', body);

    if (response.success && response.data != null) {
      return ApiResponse.success(response.data!['settings']);
    }
    return ApiResponse.error(response.message ?? 'Failed to update settings');
  }

  /// 📱 Get Active Sessions
  Future<ApiResponse<List<dynamic>>> getActiveSessions() async {
    final response = await _apiHelper.get<List<dynamic>>('auth/sessions');

    if (response.success && response.data != null) {
      return ApiResponse.success(response.data!);
    }
    return ApiResponse.error(response.message ?? 'Failed to fetch sessions');
  }

  /// 🗑️ Revoke Session
  Future<ApiResponse<String>> revokeSession(String sessionId) async {
    final response = await _apiHelper.delete<Map<String, dynamic>>('auth/sessions/$sessionId');

    if (response.success) {
      return ApiResponse.success(response.message ?? 'Session revoked');
    }
    return ApiResponse.error(response.message ?? 'Failed to revoke session');
  }

  /// ❌ Delete Account
  Future<ApiResponse<String>> deleteAccount() async {
    final response = await _apiHelper.delete<Map<String, dynamic>>('auth/account');

    if (response.success) {
      return ApiResponse.success(response.message ?? 'Account deleted');
    }
    return ApiResponse.error(response.message ?? 'Failed to delete account');
  }

  /// 🔑 Forgot Password - Request OTP
  Future<ApiResponse<String>> forgotPassword(String email) async {
    final response = await _apiHelper.post<Map<String, dynamic>>('auth/forgot-password', {"email": email});
    if (response.success) {
      return ApiResponse.success(response.message ?? 'OTP sent');
    }
    return ApiResponse.error(response.message ?? 'Failed to send OTP');
  }

  /// 🔑 Reset Password
  Future<ApiResponse<String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final body = {
      "email": email,
      "otp": otp,
      "newPassword": newPassword,
    };
    final response = await _apiHelper.post<Map<String, dynamic>>('auth/reset-password', body);
    if (response.success) {
      return ApiResponse.success(response.message ?? 'Password reset success');
    }
    return ApiResponse.error(response.message ?? 'Failed to reset password');
  }
}
