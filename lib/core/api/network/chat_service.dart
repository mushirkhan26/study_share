import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/app_constants.dart';
import '../../services/secure_storage_service.dart';
import '../base_api/api_response.dart';

class ChatService {
  final SecureStorageService _storage = SecureStorageService();

  Future<ApiResponse<Map<String, dynamic>>> getOrCreateConversation(String sellerId, String bookId) async {
    try {
      final token = await _storage.getToken();
      final response = await http.post(
        Uri.parse('${AppConstants.apiBaseUrl}chat/conversation'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'sellerId': sellerId,
          'bookId': bookId,
        }),
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(jsonDecode(response.body));
      } else {
        final error = jsonDecode(response.body);
        return ApiResponse.error(error['message'] ?? 'Failed to get conversation');
      }
    } catch (e) {
      return ApiResponse.error('Network Error: $e');
    }
  }

  Future<ApiResponse<List<dynamic>>> getConversations() async {
    try {
      final token = await _storage.getToken();
      final response = await http.get(
        Uri.parse('${AppConstants.apiBaseUrl}chat/conversations'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(jsonDecode(response.body));
      } else {
        return ApiResponse.error('Failed to fetch conversations');
      }
    } catch (e) {
      return ApiResponse.error('Network Error: $e');
    }
  }

  Future<ApiResponse<List<dynamic>>> getMessages(String conversationId) async {
    try {
      final token = await _storage.getToken();
      final response = await http.get(
        Uri.parse('${AppConstants.apiBaseUrl}chat/messages/$conversationId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(jsonDecode(response.body));
      } else {
        return ApiResponse.error('Failed to fetch messages');
      }
    } catch (e) {
      return ApiResponse.error('Network Error: $e');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> sendMessage(String conversationId, String text) async {
    try {
      final token = await _storage.getToken();
      final response = await http.post(
        Uri.parse('${AppConstants.apiBaseUrl}chat/message'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'conversationId': conversationId,
          'text': text,
        }),
      );

      if (response.statusCode == 201) {
        return ApiResponse.success(jsonDecode(response.body));
      } else {
        return ApiResponse.error('Failed to send message');
      }
    } catch (e) {
      return ApiResponse.error('Network Error: $e');
    }
  }

  Future<ApiResponse<void>> markAsRead(String conversationId) async {
    try {
      final token = await _storage.getToken();
      final response = await http.put(
        Uri.parse('${AppConstants.apiBaseUrl}chat/messages/$conversationId/read'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(null);
      } else {
        return ApiResponse.error('Failed to mark messages as read');
      }
    } catch (e) {
      return ApiResponse.error('Network Error: $e');
    }
  }
}
