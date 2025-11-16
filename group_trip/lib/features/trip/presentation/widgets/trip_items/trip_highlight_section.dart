import 'package:flutter/material.dart';
import 'package:group_trip/features/trip/data/trip_tag_relation.dart';
import 'package:group_trip/shared/widgets/atoms/chip_tag.dart';

class TripHighlightSection extends StatelessWidget {
  final List<TripTagRelation> tags;

  const TripHighlightSection({super.key, required this.tags});

  Widget _buildHighlight(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFFA726), size: 20),
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
      child: Wrap(
        spacing: 8, // khoảng cách ngang giữa các chip
        runSpacing: 8, // khoảng cách dọc giữa các dòng
        children: [...tags.map((tag) => buildChip(tag.name)).toList()],
      ),
    );
  }
}
