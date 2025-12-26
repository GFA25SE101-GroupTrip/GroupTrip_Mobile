import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:group_trip/features/auth/providers/user_provider.dart';
import 'package:group_trip/core/providers/user_storage_provider.dart';
import 'package:group_trip/features/notifications/presentation/screens/notification.dart';
import 'package:group_trip/features/notifications/presentation/screens/notificationStaffScreen.dart';
import 'package:group_trip/features/notifications/providers/notificationProvider.dart';
import 'package:group_trip/features/staff/presentation/staff_screen.dart';
import 'package:group_trip/features/chat/presentation/chat_screen.dart';
import 'package:group_trip/shared/widgets/staff_bottom_navbar.dart';
import 'package:group_trip/features/profile/providers/profile_provider.dart';
import 'package:group_trip/features/wallet/providers/wallet_provider.dart';
import 'package:group_trip/features/chat/providers/chat_provider.dart';
import 'package:group_trip/features/mytrip/providers/mytrip_provider.dart';
import 'package:group_trip/features/invite/provider/invite_provider.dart';
import 'package:group_trip/features/staff/presentation/providers/staff_provider.dart';

class StaffLayout extends StatefulWidget {
  const StaffLayout({super.key});

  @override
  State<StaffLayout> createState() => _StaffLayoutState();
}

class _StaffLayoutState extends State<StaffLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const StaffScreen(), // Công việc
    const ChatScreen(), // Chat
    const NotificationStaffScreen(), // Thông báo
    const StaffProfilePage(), // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: StaffBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class StaffProfilePage extends ConsumerWidget {
  const StaffProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch auth state to get current user
    final authState = ref.watch(authNotifierProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ'),
        centerTitle: true,
        elevation: 1,
      ),
      body: authState.when(
        data: (user) {
          final userName = user?.userName ?? 'Nhân viên';
          
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue.shade600,
                  child: const Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () async {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Đăng xuất'),
                        content: const Text('Bạn có chắc muốn đăng xuất?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () async {
                              // Invalidate cached data BEFORE logout
                              ref.invalidate(userFromStorageProvider);
                              
                              // Clear profile data
                              ref.invalidate(profileNotifierProvider);
                              ref.invalidate(profileViewProvider);
                              ref.invalidate(userInformationNotifierProvider);
                              // Clear chat data
                              ref.invalidate(chatListViewProvider);

                              // Clear notification data
                              ref.invalidate(getNotification);
                              
                              // Call logout AFTER invalidating providers
                              await ref
                                  .read(authNotifierProvider.notifier)
                                  .logout();
                              
                              if (context.mounted) {
                                Navigator.pop(context); // Close dialog
                                context.go('/'); // Navigate to login
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Đã đăng xuất thành công'),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Đăng xuất',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    'Đăng xuất',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Text('Lỗi: $error'),
        ),
      ),
    );
  }
}
