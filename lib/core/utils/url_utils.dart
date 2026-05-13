import '../constants/app_constants.dart';

class UrlUtils {
  static String? normalizeImageUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    
    // If it's already a full URL, return it
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    
    // If it's a relative path, prepend the base URL
    // Ensure we don't have double slashes
    final String baseUrl = AppConstants.socketBaseUrl.endsWith('/') 
        ? AppConstants.socketBaseUrl.substring(0, AppConstants.socketBaseUrl.length - 1) 
        : AppConstants.socketBaseUrl;
        
    final String path = url.startsWith('/') ? url : '/$url';
    
    return '$baseUrl$path';
  }
}
