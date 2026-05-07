import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../constants/app_constants.dart';
import '../../services/secure_storage_service.dart';
import '../base_api/api_response.dart';

class MaterialService {
  final SecureStorageService _storage = SecureStorageService();
  static const String baseUrl = "${AppConstants.apiBaseUrl}materials";

  Future<ApiResponse<List<dynamic>>> getMaterials() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return ApiResponse.success(jsonDecode(response.body));
      } else {
        return ApiResponse.error('Failed to fetch materials');
      }
    } catch (e) {
      return ApiResponse.error('Network Error: $e');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> uploadMaterial({
    required String title,
    required String subject,
    String? description,
    required String type,
    required File file,
  }) async {
    try {
      final token = await _storage.getToken();
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['title'] = title;
      request.fields['subject'] = subject;
      if (description != null) request.fields['description'] = description;
      request.fields['type'] = type;
      
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return ApiResponse.success(jsonDecode(response.body));
      } else {
        return ApiResponse.error('Failed to upload material');
      }
    } catch (e) {
      return ApiResponse.error('Network Error: $e');
    }
  }
}
