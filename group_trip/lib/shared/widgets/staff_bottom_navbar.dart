import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/notifications/providers/notificationProvider.dart';

final unreadNotificationCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final notificationsAsync = ref.watch(getNotification);
  return notificationsAsync.when(
    data: (notifications) => notifications.where((n) => !n.isRead).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

class StaffBottomNavBar extends ConsumerWidget {
  final int currentIndex;
  final Function(int) onTap;

  const StaffBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    return Container(
      height: 100.0,
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      transform: Matrix4.identity()..scale(1.05),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 87, 87, 166),
        unselectedItemColor: Colors.grey.shade400,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        iconSize: 28,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 0 ? Icons.work : Icons.work_outline,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 1 ? Icons.chat : Icons.chat_outlined,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildNotificationIcon(unreadCount, currentIndex),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 3 ? Icons.person : Icons.account_circle_outlined,
            ),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon(AsyncValue<int> unreadCount, int currentIndex) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Icon(
          currentIndex == 2 ? Icons.notifications : Icons.notifications_none,
        ),
        unreadCount.when(
          data: (count) => count > 0
              ? Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
