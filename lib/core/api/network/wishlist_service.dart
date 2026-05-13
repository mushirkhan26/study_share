import '../base_api/api_helper.dart';
import '../base_api/api_response.dart';

class WishlistService {
  final ApiHelper _apiHelper = ApiHelper();

  Future<ApiResponse<Map<String, dynamic>>> toggleWishlist(String bookId) async {
    final response = await _apiHelper.post<Map<String, dynamic>>('wishlist/$bookId', {});
    if (response.success && response.data != null) {
      return ApiResponse.success(response.data!);
    }
    return ApiResponse.error(response.message ?? 'Failed to update wishlist');
  }

  Future<ApiResponse<List<dynamic>>> getWishlist() async {
    final response = await _apiHelper.get<List<dynamic>>('wishlist');
    if (response.success && response.data != null) {
      return ApiResponse.success(response.data!);
    }
    return ApiResponse.error(response.message ?? 'Failed to fetch wishlist');
  }

  Future<ApiResponse<bool>> checkIfSaved(String bookId) async {
    final response = await _apiHelper.get<Map<String, dynamic>>('wishlist/check/$bookId');
    if (response.success && response.data != null) {
      return ApiResponse.success(response.data!['isSaved'] ?? false);
    }
    return ApiResponse.error(response.message ?? 'Failed to check status');
  }
}
