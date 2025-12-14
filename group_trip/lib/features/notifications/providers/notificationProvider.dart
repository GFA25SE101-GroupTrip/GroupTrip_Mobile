import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/api_client_provider.dart';
import 'package:group_trip/features/notifications/data/notification_api.dart';
import 'package:group_trip/features/notifications/domain/notification_repository.dart';

final notificationRemoteDataSourceProvider = Provider((ref) {
  print('✅ notificationRemoteDataSourceProvider initialized');
  return NotiRemoteDataSource(api: ref.watch(apiClientProvider));
});


final notificationRepositoryProvider = Provider((ref) {
  print('✅ notificationRepositoryProvider initialized');
  return NotificationRepository(
      api: ref.watch(notificationRemoteDataSourceProvider));
});

 
final getNotification = FutureProvider.autoDispose((ref) async {
  print('✅ getNotification Provider initialized');
  final repository = ref.watch(notificationRepositoryProvider);
  return repository.getUserNotifications();
});

// Provider to count unread notifications
final unreadNotificationCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final notificationsAsync = ref.watch(getNotification);
  return notificationsAsync.when(
    data: (notifications) => notifications.where((n) => !n.isRead).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

// Provider to mark notifications as read
final markNotificationsAsReadProvider = Provider.autoDispose((ref) {
  return () async {
    final repository = ref.watch(notificationRepositoryProvider);
    await repository.markNotificationAsRead();
    // Invalidate the getNotification provider to refresh data
    ref.invalidate(getNotification);
  };
});

// Provider to delete a specific notification
final deleteNotificationProvider = Provider.autoDispose((ref) {
  return (String notificationId) async {
    final repository = ref.watch(notificationRepositoryProvider);
    await repository.deleteNotificationById(notificationId);
    // Invalidate the getNotification provider to refresh data
    ref.invalidate(getNotification);
  };
});

// Provider to delete all notifications
final deleteAllNotificationsProvider = Provider.autoDispose((ref) {
  return () async {
    final repository = ref.watch(notificationRepositoryProvider);
    await repository.deleteAllNotifications();
    // Invalidate the getNotification provider to refresh data
    ref.invalidate(getNotification);
  };
});