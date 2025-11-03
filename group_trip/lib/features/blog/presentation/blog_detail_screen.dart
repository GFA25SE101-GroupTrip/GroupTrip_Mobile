import 'package:flutter/material.dart';
import 'package:group_trip/shared/widgets/atoms/chip_tag.dart';

class BlogDetailScreen extends StatelessWidget {
  const BlogDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            
            const SizedBox(height: 16),

            // Tiêu đề & thông tin tác giả
            const Text(
              "Khám phá vẻ đẹp hùng vĩ của Sapa trong mùa lúa chín",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage("https://i.pravatar.cc/100?img=1"),
                ),
                const SizedBox(width: 8),
                const Text("Saigon Tourist",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const Spacer(),
               
              ],
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              children: [
                buildChip(" #nature"),
                buildChip(" #mountain"),  
                buildChip(" #sapa"),
              ],
            ),
            const SizedBox(height: 16),

            // Nội dung bài viết
            const Text(
              "Sapa luôn là điểm đến hấp dẫn với những du khách yêu thích vẻ đẹp thiên nhiên, "
              "mùa lúa chín mang đến một phong cảnh rực rỡ sắc vàng trải dài khắp các thung lũng.",
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "https://picsum.photos/600/300?1",
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            
            const SizedBox(height: 16),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(12),
            //   child: Image.network(
            //     "https://images.unsplash.com/photo-1523875194681-bedd468c58bf?w=800",
            //     fit: BoxFit.cover,
            //   ),
            // ),
            const SizedBox(height: 16),
            const Text(
              "Người dân nơi đây luôn nồng hậu, những thửa ruộng bậc thang trải dài như những dải lụa vàng óng ánh khiến du khách không thể rời mắt.",
              style: TextStyle(fontSize: 14, height: 1.6),
            ),

            const SizedBox(height: 20),
            // Nút hành động
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text("Chỉnh sửa"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text("Xóa bài"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
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
              "https://picsum.photos/600/300?1",
            ),
            const SizedBox(height: 14),
            _relatedPost(
              "Khám phá ẩm thực Phú Yên, vùng đất đầy hương vị biển cả",
              "https://picsum.photos/600/300?2",
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
