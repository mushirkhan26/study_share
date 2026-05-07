import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/app_constants.dart';
import '../../services/secure_storage_service.dart';
import '../base_api/api_response.dart';

class NotificationService {
  final SecureStorageService _storage = SecureStorageService();
  static const String baseUrl = "${AppConstants.apiBaseUrl}notifications";

  Future<ApiResponse<List<dynamic>>> getNotifications() async {
    try {
      final token = await _storage.getToken();
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(jsonDecode(response.body));
      } else {
        return ApiResponse.error('Failed to fetch notifications');
      }
    } catch (e) {
      return ApiResponse.error('Network Error: $e');
    }
  }

  Future<ApiResponse<void>> markAsRead(String id) async {
    try {
      final token = await _storage.getToken();
      final response = await http.put(
        Uri.parse('$baseUrl/$id/read'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(null);
      } else {
        return ApiResponse.error('Failed to update status');
      }
    } catch (e) {
      return ApiResponse.error('Network Error: $e');
    }
  }

  Future<ApiResponse<void>> markAllAsRead() async {
    try {
      final token = await _storage.getToken();
      final response = await http.put(
        Uri.parse('$baseUrl/read-all'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(null);
      } else {
        return ApiResponse.error('Failed to update status');
      }
    } catch (e) {
      return ApiResponse.error('Network Error: $e');
    }
  }
}
