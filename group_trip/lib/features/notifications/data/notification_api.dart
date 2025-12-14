import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/core/config/secure_storage_service.dart';
import 'package:group_trip/features/notifications/data/notification_model.dart';

class NotiRemoteDataSource {
  final ApiClient api;
  
  NotiRemoteDataSource({required this.api});

  Future<List<NotificationModel>> getUserNotifications() async {
    final response = await api.get('noti', '/api/notification/user-notify');

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      
      dynamic payload = response.data;
      print('Tracking route payload: $payload');

      // Chuẩn hóa cấu trúc response
      if (payload is Map && payload.containsKey('data')) {
        payload = payload['data'];
      }

      if (payload is List) {
        return payload.map((item) {
          final itemMap = Map<String, dynamic>.from(item as Map);
          return NotificationModel.fromJson(itemMap);
        }).toList();
      } else {
        throw Exception(
          'Unexpected notification payload shape: ${payload.runtimeType}',
        );
      }
    } else {
      throw Exception(
        'Failed to load notifications: status=${response.statusCode}',
      );
    }
  }

  Future<void> markNotificationAsRead() async {
    final response = await api.post(
      'noti',
      '/api/notification/mark-read',
    );

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw Exception(
        'Failed to mark notification as read: status=${response.statusCode}',
      );
    }
  }


  Future<void> deleteNotificationById(String notificationId) async {
    final response = await api.delete(
      'noti',
      '/api/notification/$notificationId',
    );

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw Exception(
        'Failed to delete notification: status=${response.statusCode}',
      );
    }
  }

  Future<void> deleteAllNotifications() async {
    final secureStorage = SecureStorageService();
    final userId = await secureStorage.getUserResponseFromJson().then((user) => user?.userId);
    if (userId == null) {
      throw Exception('User ID not found in storage');
    }
    final response = await api.delete(
      'noti',
      '/api/notification/noti/$userId',
    );

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw Exception(
        'Failed to delete all notifications: status=${response.statusCode}',
      );
    }
  }


}
