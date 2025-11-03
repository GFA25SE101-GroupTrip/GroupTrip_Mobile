import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/user_storage_provider.dart';
import 'package:group_trip/features/auth/providers/user_provider.dart' show authNotifierProvider;
import 'package:go_router/go_router.dart';
import 'package:group_trip/features/profile/providers/profile_provider.dart';
import 'package:group_trip/shared/widgets/atoms/named_avartar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final profileView = ref.watch(profileViewProvider);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              // Navigate to profile detail/edit screen
              context.push('/profile/detail');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- Thông tin người dùng ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      if (profileView != null)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: (profileView.imageUrl != null)
                                  ? Image.network(
                                      profileView.imageUrl!,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    )
                                  : NameAvatar(name: profileView.displayName, size: 60),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profileView.displayName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    profileView.subtitle,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade600,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    // defensive check in case isUpdated is unexpectedly null
                                    child: (profileView.isUpdated == true)
                                        ? const Text(
                                            "Tài khoản đã được cập nhật",
                                            style: TextStyle(color: Colors.white, fontSize: 12),
                                          )
                                        : const Text(
                                            "Tài khoản chưa được cập nhật",
                                            style: TextStyle(color: Colors.white, fontSize: 12),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      else
                        const Text(
                          'Đang tải...',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                ],
              ),
              ),
            const SizedBox(height: 20),
            // --- Các tùy chọn ---
            _buildMenuItem(
              icon: Icons.account_balance_wallet_outlined,
              title: "My Wallet",
              subtitle: "Quản lý số dư & thanh toán",
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.star_border,
              title: "My Reviews",
              subtitle: "Xem các đánh giá của bạn",
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: "Help Center",
              subtitle: "FAQ & hỗ trợ khách hàng",
              onTap: () {},
            ),
          
            _buildMenuItem(
              icon: Icons.logout,
              title: "Log out",
              subtitle: "Đăng xuất tài khoản",
              color: Colors.red,
              onTap: () async {
                // Confirm then logout
                final should = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Xác nhận'),
                    content: const Text('Bạn có chắc muốn đăng xuất không?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Hủy')),
                      TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Đăng xuất')),
                    ],
                  ),
                );
                if (should != true) return;

                // Call notifier to clear local storage and reset state
                await ref.read(authNotifierProvider.notifier).logout();

                // Invalidate cached user provider so UI updates
                ref.invalidate(userFromStorageProvider);

                // Navigate to login
                context.push('/');
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget item menu ---
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.blueAccent),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: color ?? Colors.black,
          ),
        ),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
