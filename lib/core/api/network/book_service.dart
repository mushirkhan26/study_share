import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/app_constants.dart';
import '../../services/secure_storage_service.dart';
import '../base_api/api_response.dart';

class BookService {
  final SecureStorageService _storage = SecureStorageService();

  Future<ApiResponse<Map<String, dynamic>>> uploadBook({
    required String title,
    required String author,
    required double sellingPrice,
    required double originalPrice,
    required String condition,
    required String tag,
    String? description,
    required File imageFile,
  }) async {
    print('=== UPLOAD BOOK START ===');

    print('File Path: ${imageFile.path}');

    try {
      final token = await _storage.getToken();
      
      var request = http.MultipartRequest('POST', Uri.parse('${AppConstants.apiBaseUrl}books'));
      
      // Headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      // Fields
      request.fields['title'] = title;
      request.fields['author'] = author;
      request.fields['sellingPrice'] = sellingPrice.toString();
      request.fields['originalPrice'] = originalPrice.toString();
      request.fields['condition'] = condition;
      request.fields['tag'] = tag;
      if (description != null) request.fields['description'] = description;

      // Add image file
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      print('Fields: ${request.fields}');
      print('Request Headers: ${request.headers}');

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        return ApiResponse.success(jsonDecode(response.body));
      } else {
        final errorData = jsonDecode(response.body);
        return ApiResponse.error(errorData['message'] ?? 'Failed to upload book');
      }
    } catch (e) {
      print('Upload Error: $e');
      return ApiResponse.error('Network Error: $e');
    }
  }

  Future<ApiResponse<List<dynamic>>> getAllBooks({String? search, String? tag}) async {
    try {
      String url = '${AppConstants.apiBaseUrl}books';
      List<String> params = [];
      if (search != null && search.isNotEmpty) params.add('search=$search');
      if (tag != null && tag != 'All') params.add('tag=$tag');
      
      if (params.isNotEmpty) {
        url += '?' + params.join('&');
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return ApiResponse.success(jsonDecode(response.body));
      } else {
        return ApiResponse.error('Failed to fetch books');
      }
    } catch (e) {
      return ApiResponse.error('Network Error: $e');
    }
  }

  Future<ApiResponse<List<dynamic>>> getMyAds() async {
    try {
      final token = await _storage.getToken();
      final response = await http.get(
        Uri.parse('${AppConstants.apiBaseUrl}books/my-ads'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return ApiResponse.success(jsonDecode(response.body));
      } else {
        return ApiResponse.error('Failed to fetch your ads');
      }
    } catch (e) {
      return ApiResponse.error('Network Error: $e');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> updateBookStatus(String bookId, bool isSold) async {
    try {
      final token = await _storage.getToken();
      final response = await http.put(
        Uri.parse('${AppConstants.apiBaseUrl}books/$bookId/status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'isSold': isSold}),
      );
      if (response.statusCode == 200) {
        return ApiResponse.success(jsonDecode(response.body));
      } else {
        return ApiResponse.error('Failed to update status');
      }
    } catch (e) {
      return ApiResponse.error('Network Error: $e');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> deleteBook(String bookId) async {
    try {
      final token = await _storage.getToken();
      final response = await http.delete(
        Uri.parse('${AppConstants.apiBaseUrl}books/$bookId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return ApiResponse.success(jsonDecode(response.body));
      } else {
        return ApiResponse.error('Failed to delete ad');
      }
    } catch (e) {
      return ApiResponse.error('Network Error: $e');
    }
  }
}
