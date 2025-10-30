import 'package:flutter/material.dart';
import 'package:group_trip/shared/widgets/atoms/chip_tag.dart';

class BlogCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final String authorAvatar;
  final List<String> tags;
  final int likes;
  final String category; // ví dụ: agency, traveler

  const BlogCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.authorAvatar,
    required this.tags,
    required this.likes,
    required this.category,
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
    return Card(
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
                child: Image.network(
                  imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
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
                  backgroundImage: NetworkImage(authorAvatar),
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
    );
  }
}
