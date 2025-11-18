import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:group_trip/features/account/traveller/presentation/traveller_profile_screen.dart';
import 'package:group_trip/features/blog/data/blog_model.dart';
// import 'package:group_trip/shared/widgets/atoms/chip_tag.dart';
import 'package:group_trip/core/providers/user_storage_provider.dart';
import 'package:group_trip/features/blog/providers/blog_provider.dart';

class BlogDetailScreen extends ConsumerWidget {
  final BlogModel blog;
  const BlogDetailScreen({super.key, required this.blog});
  // Accept blogId explicitly to avoid any accidental capture/stale state.
  Future<void> _deleteBlog(BuildContext context, WidgetRef ref, String blogId) async {
    final blogNotifier = ref.read(blogNotifierProvider.notifier);
    try {
      // Log the id we're about to delete so you can compare with server logs
      print('Deleting blog with ID (from _deleteBlog param): $blogId');
      await blogNotifier.deleteBlog(blogId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Xóa bài viết thành công')),
      );
      ref.refresh(blogListProvider);
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xóa bài viết: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
  // Log blog id on build so we can verify which blog detail is shown.
  print('BlogDetailScreen build for blogId=${blog.blogId}');
  final storedUser = ref.watch(userFromStorageProvider).asData?.value;
  final isOwner = storedUser != null && storedUser.userId == blog.userId;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Chi tiết bài viết", style: TextStyle(color: Colors.black, fontSize: 20)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh bìa + tag
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                blog.coverImage ?? 'https://res.cloudinary.com/db18zz55c/image/upload/v1762439871/uploads/scaled_38.jpg2/800/400',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Tiêu đề & thông tin tác giả
            Text(
              blog.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
            ),
            const SizedBox(height: 8),

            GestureDetector(
              onTap: () {
                // Navigate to traveller profile screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TravellerProfileScreen(travellerId: blog.userId),
                  ),
                );
              },
              child: Row(
                children: [
                 CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(blog.userImage),
                  ),
                  const SizedBox(width: 8),
                  Text(blog.fullName,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const Spacer(),
                 
                ],
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              children: blog.tags
                  .map((tag) => _buildTag(tag.name, Colors.blueAccent))
                  .toList(),
            ),
            const SizedBox(height: 16),

            Text(
              blog.content,
              style: TextStyle(fontSize: 14, height: 1.6),
            ),

            const SizedBox(height: 20),
            // Nút hành động (chỉ hiển thị nếu người đang đăng nhập là chủ bài)
            Row(
              children: [
                const SizedBox(width: 12),
                if (isOwner)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // Simple confirmation dialog before delete. Actual delete
                        // implementation should call repository/api.
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Xác nhận'),
                            content: const Text('Bạn có chắc muốn xóa bài viết này?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Hủy')),
                              TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Xóa')),
                            ],
                          ),
                        );
                        if (ok == true) {
                          // pass blogId explicitly
                          _deleteBlog(context, ref, blog.blogId);
                        }
                      },
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text("Xóa bài"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),

            const SizedBox(height: 16),

            // Like + Share
            
            const Divider(height: 32),

            // Bài viết liên quan
            const Text(
              "Bài viết liên quan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 14),
            _relatedPost(
              "Hội An – Thành phố cổ kính trong ánh hoàng hôn",
              "https://res.cloudinary.com/db18zz55c/image/upload/v1762439871/uploads/scaled_38.jpg",
            ),
            const SizedBox(height: 14),
            _relatedPost(
              "Khám phá ẩm thực Phú Yên, vùng đất đầy hương vị biển cả",
              "https://res.cloudinary.com/db18zz55c/image/upload/v1762439871/uploads/scaled_38.jpg",
            ),
             const SizedBox(height: 14),

          ],
        ),
      ),
    );
  }

  // Widget tag
  Widget _buildTag(String tag, Color color) {
    return Chip(
      label: Text(tag, style: const TextStyle(fontSize: 12)),
      backgroundColor: color.withOpacity(0.6),
      side: BorderSide.none,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  // Widget bài viết liên quan
  Widget _relatedPost(String title, String imageUrl) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(imageUrl, width: 70, height: 50, fit: BoxFit.cover),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
        ),
      ],
    );
  }
}
