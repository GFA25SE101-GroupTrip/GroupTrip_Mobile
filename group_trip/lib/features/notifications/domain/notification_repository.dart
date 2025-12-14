import 'package:group_trip/features/notifications/data/notification_api.dart';
import 'package:group_trip/features/notifications/data/notification_model.dart';

class NotificationRepository {
  final NotiRemoteDataSource api;
  NotificationRepository({required this.api});
  Future<List<NotificationModel>> getUserNotifications() {
    return api.getUserNotifications();
  }
  Future<void> markNotificationAsRead() {
    return api.markNotificationAsRead();
  }

  Future<void> deleteNotificationById(String notificationId) {
    return api.deleteNotificationById(notificationId);
  }

  Future<void> deleteAllNotifications() {
    return api.deleteAllNotifications();
  }
  
}