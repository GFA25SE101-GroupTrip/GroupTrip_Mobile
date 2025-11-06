import 'package:flutter/material.dart';
import 'package:group_trip/shared/widgets/atoms/chip_tag.dart';

class BlogCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String author;
  final String? authorAvatar;
  final List<String> tags;
  final int likes;
  final String category; // ví dụ: agency, traveler
  final VoidCallback? viewDetail;

  const BlogCard({
    super.key,
    this.imageUrl,
    required this.title,
    required this.author,
    this.authorAvatar,
    required this.tags,
    required this.likes,
    required this.category,
    required this.viewDetail,
  });

  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'agency':
        return Colors.blueAccent;
      case 'traveler':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: viewDetail,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: _buildCover(imageUrl, title),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Wrap(
              spacing: 8,
              children: tags
                  .map((t) => buildChip(t))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: _buildAuthorImage(authorAvatar),
                  radius: 14,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(author, style: const TextStyle(fontSize: 13)),
                ),
                
              ],
            ),
          ),
        ],
      ),
    )
    );
  }

  // Helper to build cover image. If imageUrl is null or not http(s), show a
  // random placeholder from picsum using a seed derived from title.
  Widget _buildCover(String? imageUrl, String seedValue) {
    final seed = seedValue.hashCode.abs();
    if (imageUrl != null && imageUrl.trim().isNotEmpty && (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'))) {
      return Image.network(
        imageUrl,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) {
          return Image.network(
            'https://picsum.photos/seed/$seed/800/400',
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        },
      );
    }

    return Image.network(
      'https://picsum.photos/seed/$seed/800/400',
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  ImageProvider _buildAuthorImage(String? avatarUrl) {
    if (avatarUrl != null && avatarUrl.trim().isNotEmpty && (avatarUrl.startsWith('http://') || avatarUrl.startsWith('https://'))) {
      return NetworkImage(avatarUrl);
    }

    // fallback avatar (picsum seeded by author name)
    final seed = author.hashCode.abs();
    return NetworkImage('https://i.pravatar.cc/150?img=${(seed % 70) + 1}');
  }
}
