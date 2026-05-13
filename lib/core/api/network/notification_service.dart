import '../base_api/api_helper.dart';
import '../base_api/api_response.dart';

class NotificationService {
  final ApiHelper _apiHelper = ApiHelper();

  Future<ApiResponse<List<dynamic>>> getNotifications() async {
    final response = await _apiHelper.get<List<dynamic>>('notifications');
    if (response.success && response.data != null) {
      return ApiResponse.success(response.data!);
    }
    return ApiResponse.error(response.message ?? 'Failed to fetch notifications');
  }

  Future<ApiResponse<void>> markAsRead(String id) async {
    final response = await _apiHelper.put<dynamic>('notifications/$id/read', {});
    if (response.success) {
      return ApiResponse.success(null);
    }
    return ApiResponse.error(response.message ?? 'Failed to update status');
  }

  Future<ApiResponse<void>> markAllAsRead() async {
    final response = await _apiHelper.put<dynamic>('notifications/read-all', {});
    if (response.success) {
      return ApiResponse.success(null);
    }
    return ApiResponse.error(response.message ?? 'Failed to update status');
  }
}
