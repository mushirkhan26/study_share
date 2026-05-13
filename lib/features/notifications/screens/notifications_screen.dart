import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/providers/notification_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final notificationProvider = Provider.of<NotificationProvider>(context);

    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!notificationProvider.hasFetched && !notificationProvider.isLoading) {
        notificationProvider.fetchNotifications();
      }
    });
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.notifications, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.brightness == Brightness.dark ? Colors.white : Colors.black),
        actions: [
          if (notificationProvider.notifications.any((n) => n['isRead'] == false))
            TextButton(
              onPressed: () => notificationProvider.markAllAsRead(),
              child: Text(l10n.markAllAsRead, style: const TextStyle(color: AppColors.primary, fontSize: 12)),
            ),
        ],
      ),
      body: notificationProvider.isLoading && notificationProvider.notifications.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : notificationProvider.notifications.isEmpty
              ? _buildEmptyState(theme, l10n)
              : RefreshIndicator(
                  onRefresh: () => notificationProvider.fetchNotifications(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(10),
                    itemCount: notificationProvider.notifications.length,
                    separatorBuilder: (context, index) => Divider(height: 1, color: theme.dividerColor),
                    itemBuilder: (context, index) {
                      final item = notificationProvider.notifications[index];
                      return GestureDetector(
                        onTap: () {
                          if (!(item['isRead'] ?? false)) {
                             notificationProvider.markAsRead(item['id'] ?? item['_id']);
                          }
                        },
                        child: _buildNotificationItem(item, theme),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> item, ThemeData theme) {
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
      color: isRead ? theme.scaffoldBackgroundColor : AppColors.primary.withValues(alpha: 0.03),
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
                  style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7), fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 8),
                Text(
                  formattedTime,
                  style: TextStyle(color: theme.hintColor, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_outlined, size: 80, color: theme.dividerColor),
          const SizedBox(height: 15),
          Text(l10n.noNotifications, style: TextStyle(color: theme.hintColor, fontSize: 16)),
        ],
      ),
    );
  }
}
