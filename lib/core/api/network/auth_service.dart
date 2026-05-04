import '../../models/user_model.dart';
import '../../services/logger_service.dart';
import '../base_api/api_helper.dart';
import '../base_api/api_response.dart';


class AuthService {
  final ApiHelper _apiHelper = ApiHelper();
  final LoggingService _logger = LoggingService.instance;

  /// 🔐 Login API (Ab email ya username se)
  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    final body = {"email": email, "password": password};
    _logger.logAuth('Attempting login for: $email');
    return await _apiHelper.post<Map<String, dynamic>>('auth/login', body);
  }

  /// 📝 Signup API (Naye students ke liye)
  Future<ApiResponse<Map<String, dynamic>>> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    final body = {
      "username": username,
      "email": email,
      "password": password,
    };
    return await _apiHelper.post<Map<String, dynamic>>('auth/signup', body);
  }

  /// 🔎 OTP Verification (Password bhulne par)
  Future<ApiResponse<Map<String, dynamic>>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final body = {"email": email, "otp": otp};
    return await _apiHelper.post<Map<String, dynamic>>('auth/verify-otp', body);
  }

  /// 👤 Get User Profile Info
  Future<ApiResponse<UserModel>> getUserProfile(String userId) async {
    final endpoint = 'users/profile/$userId';
    final response = await _apiHelper.get<Map<String, dynamic>>(endpoint);

    if (response.success && response.data != null) {
      // JSON se Model banana
      final user = UserModel.fromJson(response.data!['data']);
      return ApiResponse.success(user);
    }
    return ApiResponse.error(response.message ?? 'Profile not found');
  }

  /// ✏️ Update Profile (Photo ya Name badalne ke liye)
  Future<ApiResponse<Map<String, dynamic>>> updateProfile({
    required String userId,
    String? username,
    String? profileImage,
  }) async {
    final endpoint = 'users/update/$userId';
    final body = {
      if (username != null) "username": username,
      if (profileImage != null) "profileImage": profileImage,
    };
    return await _apiHelper.put<Map<String, dynamic>>(endpoint, body);
  }
}