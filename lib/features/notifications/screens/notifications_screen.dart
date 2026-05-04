import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy notifications data
    final List<Map<String, dynamic>> notifications = [
      {
        "title": "Price Drop! 📉",
        "message": "The book 'Let Us C' is now available at a lower price. Check it out!",
        "time": "2 hours ago",
        "isRead": false,
        "icon": Icons.local_offer_outlined,
      },
      {
        "title": "New Message 💬",
        "message": "Amit Kumar sent you a message regarding 'Data Structures'.",
        "time": "5 hours ago",
        "isRead": true,
        "icon": Icons.chat_bubble_outline,
      },
      {
        "title": "Ad Approved ✅",
        "message": "Your ad for 'Software Engineering' has been approved and is now live.",
        "time": "Yesterday",
        "isRead": true,
        "icon": Icons.check_circle_outline,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            onPressed: () {
              // Mark all as read logic
            },
            child: const Text("Mark all as read", style: TextStyle(color: AppColors.primary, fontSize: 12)),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return _buildNotificationItem(item);
              },
            ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      color: item['isRead'] ? Colors.white : AppColors.primary.withValues(alpha: 0.03),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Icon(item['icon'], color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['title'],
                      style: TextStyle(
                        fontWeight: item['isRead'] ? FontWeight.w600 : FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    if (!item['isRead'])
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  item['message'],
                  style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 8),
                Text(
                  item['time'],
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
