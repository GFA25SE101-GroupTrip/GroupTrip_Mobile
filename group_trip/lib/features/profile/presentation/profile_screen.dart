import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/user_storage_provider.dart';
import 'package:group_trip/features/auth/providers/user_provider.dart'
    show authNotifierProvider;
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
          "Tài khoản của tôi",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
          ),
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
                          child:
                              (profileView.imageUrl != null &&
                                      profileView.imageUrl!.trim().isNotEmpty)
                                  ? () {
                                    final url = profileView.imageUrl!;
                                    final trimmed = url.trim();
                                    // Log the URL for debugging
                                    // ignore: avoid_print
                                    print('🖼️ profile image url="$trimmed"');
                                    final uri = Uri.tryParse(trimmed);
                                    final isRemote =
                                        uri != null &&
                                        (uri.scheme == 'http' ||
                                            uri.scheme == 'https');
                                    final isFileUri =
                                        uri != null && uri.scheme == 'file';
                                    final looksLikeLocalPath =
                                        !isRemote &&
                                        (trimmed.startsWith('/') ||
                                            RegExp(
                                              r'^[A-Za-z]:\\',
                                            ).hasMatch(trimmed));
                                    if (isRemote) {
                                      return Image.network(
                                        trimmed,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder: (ctx, err, st) {
                                          // ignore: avoid_print
                                          print(
                                            '❌ Image.network failed for $trimmed: $err',
                                          );
                                          return NameAvatar(
                                            name: profileView.displayName,
                                            size: 60,
                                          );
                                        },
                                      );
                                    } else if (isFileUri ||
                                        looksLikeLocalPath) {
                                      var path = trimmed;
                                      if (isFileUri) path = uri.toFilePath();
                                      try {
                                        return Image.file(
                                          File(path),
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        );
                                      } catch (e) {
                                        // ignore: avoid_print
                                        print(
                                          '❌ Image.file failed for $path: $e',
                                        );
                                        return NameAvatar(
                                          name: profileView.displayName,
                                          size: 60,
                                        );
                                      }
                                    } else {
                                      return NameAvatar(
                                        name: profileView.displayName,
                                        size: 60,
                                      );
                                    }
                                  }()
                                  : NameAvatar(
                                    name: profileView.displayName,
                                    size: 60,
                                  ),
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade600,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                // defensive check in case isUpdated is unexpectedly null
                                child: Visibility(
                                  visible: profileView.isUpdated != true,
                                  child: const Text(
                                    "Tài khoản chưa được cập nhật",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
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
              onTap: () {
                // Navigate to wallet screen
                context.push('/profile/wallet');
              },
            ),
            _buildMenuItem(
              icon: Icons.directions_car_filled,
              title: "Chuyến đi của tôi",
              subtitle: "Xem các đánh giá của bạn",
              onTap: () {
                context.push('/mytrip');
              },
            ),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: "Help Center",
              subtitle: "FAQ & hỗ trợ khách hàng",
              onTap: () {
                context.push('/profile/help');
              },
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
                  builder:
                      (ctx) => AlertDialog(
                        title: const Text('Xác nhận'),
                        content: const Text(
                          'Bạn có chắc muốn đăng xuất không?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text('Đăng xuất'),
                          ),
                        ],
                      ),
                );
                if (should != true) return;

                // Call notifier to clear local storage and reset state
                await ref.read(authNotifierProvider.notifier).logout();

                // Invalidate cached user provider so UI updates
                ref.invalidate(userFromStorageProvider);
                // Also clear profile data cached in providers so profile view updates
                ref.invalidate(profileNotifierProvider);
                ref.invalidate(profileViewProvider);

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
