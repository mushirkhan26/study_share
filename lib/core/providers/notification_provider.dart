import 'package:flutter/material.dart';
import '../api/network/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  List<dynamic> _notifications = [];
  bool _isLoading = false;
  bool _hasFetched = false;

  List<dynamic> get notifications => _notifications;
  bool get isLoading => _isLoading;
  bool get hasFetched => _hasFetched;

  Future<void> fetchNotifications() async {
    if (!_hasFetched) {
      _isLoading = true;
      notifyListeners();
    }

    final response = await _notificationService.getNotifications();
    if (response.success && response.data != null) {
      _notifications = response.data!;
    }
    
    _hasFetched = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> markAllAsRead() async {
    final response = await _notificationService.markAllAsRead();
    if (response.success) {
      await fetchNotifications();
    }
  }

  Future<void> markAsRead(String id) async {
    final response = await _notificationService.markAsRead(id);
    if (response.success) {
      await fetchNotifications();
    }
  }
}
