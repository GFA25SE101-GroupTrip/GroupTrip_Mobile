import 'package:flutter/material.dart';
import 'package:group_trip/features/trip/data/trip_tag_relation.dart';

class TripHighlightSection extends StatelessWidget {
  final List<TripTagRelation> tags;

  const TripHighlightSection({super.key, required this.tags});

  Widget _buildHighlight(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.star_rounded,
            color: Color(0xFFFFA726),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151), // text màu xám đậm
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Loại hình nổi bật',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          ...tags.map((tag) => _buildHighlight(tag.name)).toList(),
        ],
      ),
    );
  }
}
