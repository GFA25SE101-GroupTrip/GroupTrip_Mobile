import 'package:flutter/material.dart';
import 'package:group_trip/features/trip/data/trip_feedback.dart';

class ReviewSection extends StatelessWidget {
  final List<TripFeedback> feedbacks;
  const ReviewSection({super.key, required this.feedbacks});

  @override
  Widget build(BuildContext context) {
    final bool hasFeedback = feedbacks.isNotEmpty;

    return Column(
      key: const ValueKey('review_section'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(hasFeedback ? feedbacks : null),
        const SizedBox(height: 12),
        if (hasFeedback)
          ...feedbacks.map((f) => _buildReviewCard(f)).toList()
        else
          _buildEmptyState(),
        const SizedBox(height: 16),
        Center(
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: const BorderSide(color: Color(0xFF007AFF)),
              ),
              onPressed: () {
                // TODO: Xử lý "xem thêm đánh giá"
              },
              child: const Text(
                "Xem thêm đánh giá",
                style: TextStyle(
                  color: Color(0xFF007AFF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(List<TripFeedback>? data) {
    double avgRating = 0;
    int total = 0;

    if (data != null && data.isNotEmpty) {
      total = data.length;
      avgRating =
          data.map((e) => e.rating).reduce((a, b) => a + b) / total.toDouble();
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Đánh giá chuyến đi ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                avgRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 24,
                  color: Color(0xFF007AFF),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.star, color: Colors.amber, size: 22),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            total > 0
                ? "Dựa trên $total đánh giá"
                : "Chưa có đánh giá nào",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(TripFeedback f) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Avatar + name + rating ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(f.userImg),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      f.userName ?? "Người dùng",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    _buildStars(f.rating.toDouble()),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // --- Nội dung bình luận ---
          Text(
            f.comment,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),

          // --- Hình ảnh kèm theo ---
          if (f.images.isNotEmpty) ...[
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: f.images.map((url) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        url.img_url,
                        width: 80,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Center(
        child: Text(
          "Chưa có đánh giá nào cho chuyến đi này",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildAvatar(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CircleAvatar(radius: 18, backgroundImage: NetworkImage(imageUrl));
    } else {
      return const CircleAvatar(
        radius: 18,
        backgroundColor: Color(0xFFE0E0E0),
        child: Icon(Icons.person, color: Colors.white),
      );
    }
  }

  Widget _buildStars(double rating) {
    final stars = <Widget>[];
    int full = rating.floor();
    bool half = (rating - full) >= 0.5;

    for (int i = 0; i < full; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 14));
    }
    if (half) stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 14));
    return Row(children: stars);
  }
}
