import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/app_constants.dart';
import '../../services/secure_storage_service.dart';
import '../base_api/api_response.dart';

class WishlistService {
  final SecureStorageService _storage = SecureStorageService();
  static const String baseUrl = "${AppConstants.apiBaseUrl}wishlist";

  Future<ApiResponse<Map<String, dynamic>>> toggleWishlist(String bookId) async {
    try {
      final token = await _storage.getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/$bookId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(jsonDecode(response.body));
      } else {
        return ApiResponse.error('Failed to update wishlist');
      }
    } catch (e) {
      return ApiResponse.error('Network Error: $e');
    }
  }

  Future<ApiResponse<List<dynamic>>> getWishlist() async {
    try {
      final token = await _storage.getToken();
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(jsonDecode(response.body));
      } else {
        return ApiResponse.error('Failed to fetch wishlist');
      }
    } catch (e) {
      return ApiResponse.error('Network Error: $e');
    }
  }

  Future<ApiResponse<bool>> checkIfSaved(String bookId) async {
    try {
      final token = await _storage.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/check/$bookId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse.success(data['isSaved'] ?? false);
      } else {
        return ApiResponse.error('Failed to check status');
      }
    } catch (e) {
      return ApiResponse.error('Network Error: $e');
    }
  }
}
