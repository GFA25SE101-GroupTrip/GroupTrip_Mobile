import 'package:flutter/material.dart';

class TripHighlightSection extends StatelessWidget {
  const TripHighlightSection({super.key});

  Widget _buildHighlight(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Điểm nổi bật',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          _buildHighlight('Du thuyền qua đêm tại vịnh Hạ Long'),
          _buildHighlight('Trekking núi Fansipan'),
          _buildHighlight('Thăm bản làng dân tộc'),
        ],
      ),
    );
  }
}
