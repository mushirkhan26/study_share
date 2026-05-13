import 'dart:io';
import '../../models/user_model.dart'; // To use AppConstants
import '../base_api/api_helper.dart';
import '../base_api/api_response.dart';

class BookService {
  final ApiHelper _apiHelper = ApiHelper();

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
    final Map<String, String> fields = {
      'title': title,
      'author': author,
      'sellingPrice': sellingPrice.toString(),
      'originalPrice': originalPrice.toString(),
      'condition': condition,
      'tag': tag,
    };
    if (description != null) fields['description'] = description;

    final Map<String, String> files = {
      'image': imageFile.path,
    };

    final response = await _apiHelper.multipartRequest<Map<String, dynamic>>(
      'POST',
      'books',
      fields: fields,
      files: files,
    );

    if (response.success && response.data != null) {
      return ApiResponse.success(response.data!);
    }
    return ApiResponse.error(response.message ?? 'Failed to upload book');
  }

  Future<ApiResponse<List<dynamic>>> getAllBooks({String? search, String? tag}) async {
    String endpoint = 'books';
    List<String> params = [];
    if (search != null && search.isNotEmpty) params.add('search=$search');
    if (tag != null && tag != 'All') params.add('tag=$tag');
    
    if (params.isNotEmpty) {
      endpoint += '?${params.join('&')}';
    }

    final response = await _apiHelper.get<List<dynamic>>(endpoint);
    if (response.success && response.data != null) {
      return ApiResponse.success(response.data!);
    }
    return ApiResponse.error(response.message ?? 'Failed to fetch books');
  }

  Future<ApiResponse<List<dynamic>>> getMyAds() async {
    final response = await _apiHelper.get<List<dynamic>>('books/my-ads');
    if (response.success && response.data != null) {
      return ApiResponse.success(response.data!);
    }
    return ApiResponse.error(response.message ?? 'Failed to fetch your ads');
  }

  Future<ApiResponse<Map<String, dynamic>>> updateBookStatus(String bookId, bool isSold) async {
    final response = await _apiHelper.put<Map<String, dynamic>>(
      'books/$bookId/status',
      {'isSold': isSold},
    );
    if (response.success && response.data != null) {
      return ApiResponse.success(response.data!);
    }
    return ApiResponse.error(response.message ?? 'Failed to update status');
  }

  Future<ApiResponse<Map<String, dynamic>>> deleteBook(String bookId) async {
    final response = await _apiHelper.delete<Map<String, dynamic>>('books/$bookId');
    if (response.success && response.data != null) {
      return ApiResponse.success(response.data!);
    }
    return ApiResponse.error(response.message ?? 'Failed to delete ad');
  }
}
