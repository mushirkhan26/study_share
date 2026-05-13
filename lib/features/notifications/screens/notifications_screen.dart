import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/providers/notification_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);

    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!notificationProvider.hasFetched && !notificationProvider.isLoading) {
        notificationProvider.fetchNotifications();
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (notificationProvider.notifications.any((n) => n['isRead'] == false))
            TextButton(
              onPressed: () => notificationProvider.markAllAsRead(),
              child: const Text("Mark all as read", style: TextStyle(color: AppColors.primary, fontSize: 12)),
            ),
        ],
      ),
      body: notificationProvider.isLoading && notificationProvider.notifications.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : notificationProvider.notifications.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () => notificationProvider.fetchNotifications(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(10),
                    itemCount: notificationProvider.notifications.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    itemBuilder: (context, index) {
                      final item = notificationProvider.notifications[index];
                      return GestureDetector(
                        onTap: () {
                          if (!(item['isRead'] ?? false)) {
                             notificationProvider.markAsRead(item['id'] ?? item['_id']);
                          }
                        },
                        child: _buildNotificationItem(item),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> item) {
    final bool isRead = item['isRead'] ?? false;
    final String? timeStr = item['createdAt'];
    final String formattedTime = timeStr != null 
        ? DateFormat('MMM d, hh:mm a').format(DateTime.parse(timeStr).toLocal())
        : "";

    IconData getIcon(String? type) {
      switch (type) {
        case 'message': return Icons.chat_bubble_outline;
        case 'price_drop': return Icons.local_offer_outlined;
        case 'ad_status': return Icons.check_circle_outline;
        default: return Icons.notifications_none;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      color: isRead ? Colors.white : AppColors.primary.withValues(alpha: 0.03),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Icon(getIcon(item['type']), color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item['title'] ?? "",
                        style: TextStyle(
                          fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (!isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  item['message'] ?? "",
                  style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 8),
                Text(
                  formattedTime,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 15),
          const Text("No notifications yet", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}
