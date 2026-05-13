import 'dart:io';
import '../base_api/api_helper.dart';
import '../base_api/api_response.dart';

class MaterialService {
  final ApiHelper _apiHelper = ApiHelper();

  Future<ApiResponse<List<dynamic>>> getMaterials() async {
    final response = await _apiHelper.get<List<dynamic>>('materials');
    if (response.success && response.data != null) {
      return ApiResponse.success(response.data!);
    }
    return ApiResponse.error(response.message ?? 'Failed to fetch materials');
  }

  Future<ApiResponse<Map<String, dynamic>>> uploadMaterial({
    required String title,
    required String subject,
    String? description,
    required String type,
    required File file,
  }) async {
    final Map<String, String> fields = {
      'title': title,
      'subject': subject,
      'type': type,
    };
    if (description != null) fields['description'] = description;

    final Map<String, String> files = {
      'file': file.path,
    };

    final response = await _apiHelper.multipartRequest<Map<String, dynamic>>(
      'POST',
      'materials',
      fields: fields,
      files: files,
    );

    if (response.success && response.data != null) {
      return ApiResponse.success(response.data!);
    }
    return ApiResponse.error(response.message ?? 'Failed to upload material');
  }
}
