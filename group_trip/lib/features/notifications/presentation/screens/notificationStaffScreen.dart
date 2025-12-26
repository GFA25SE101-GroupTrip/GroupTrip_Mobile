import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:group_trip/core/providers/secure_storage_provider.dart';
import 'package:intl/intl.dart';
import 'package:group_trip/features/notifications/data/notification_model.dart';
import 'package:group_trip/features/notifications/providers/notificationProvider.dart';

class NotificationStaffScreen extends ConsumerWidget {
  const NotificationStaffScreen({super.key});

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Vừa xong';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(getNotification);

    return notificationsAsync.when(
      data: (notifications) {
        // Sort notifications by latest time first
        final sortedNotifications = List<NotificationModel>.from(
          notifications.where((n) => n.notificationType != 'MessageReceive'),
        )..sort((a, b) => b.createAt.compareTo(a.createAt));
        
        final unreadCount = sortedNotifications.where((n) => !n.isRead).length;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
           
            title: const Text(
              'Thông báo',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              if (unreadCount > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        final markAsRead = ref.read(markNotificationsAsReadProvider);
                        markAsRead();
                      },
                      child: Text(
                        'Đánh dấu tất cả',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              if (sortedNotifications.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Xóa tất cả thông báo'),
                            content: const Text('Bạn có chắc muốn xóa tất cả thông báo?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Hủy'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  final deleteAll = ref.read(deleteAllNotificationsProvider);
                                  await deleteAll();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Tất cả thông báo đã bị xóa')),
                                    );
                                  }
                                },
                                child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(
                        'Xóa tất cả',
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              ref.refresh(getNotification);
            },
            child: sortedNotifications.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: sortedNotifications.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return NotificationItemWidget(
                        notification: sortedNotifications[index],
                        formattedTime: _formatTime(sortedNotifications[index].createAt),
                      );
                    },
                  ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => context.go('/'),
          ),
          title: const Text(
            'Thông báo',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => context.go('/'),
          ),
          title: const Text(
            'Thông báo',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Lỗi: $error'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Không có thông báo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bạn sẽ nhận được thông báo khi có cập nhật mới',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationItemWidget extends ConsumerWidget {
  final NotificationModel notification;
  final String formattedTime;

  const NotificationItemWidget({
    super.key,
    required this.notification,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        // Handle notification tap
      },
      child: Container(
        color: notification.isRead ? Colors.white : Colors.blue.shade50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      notification.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Content
              Text(
                notification.content,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              // View details
            
            ],
          ),
        ),
      ),
    );
  }
}
