import 'package:flutter/material.dart';

class ReviewSection extends StatelessWidget {
  const ReviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> fakeReviews = [
      {
        "name": "Minh Anh",
        "avatar": null,
        "rating": 5.0,
        "timeAgo": "2 tuần trước",
        "content":
            "Chuyến đi tuyệt vời! Hạ Long thật sự hùng vĩ, du thuyền sang trọng. Sapa thì không khí mát mẻ, cảnh đẹp như tranh. Hướng dẫn viên nhiệt tình, lịch trình hợp lý.",
        "images": [
          "https://picsum.photos/seed/2/800/400",
          "https://picsum.photos/seed/3/800/400",
        ],
      },
      {
        "name": "Hoàng Nam",
        "avatar": null,
        "rating": 4.5,
        "timeAgo": "1 tháng trước",
        "content":
            "Fansipan thật sự ấn tượng! Cáp treo hiện đại, view đỉnh núi tuyệt đẹp. Thăm bản Cát Cát cũng rất thú vị, được tìm hiểu văn hóa dân tộc. Khách sạn sạch sẽ, ăn ngon.",
        "images": [],
      },
      {
        "name": "Thu Hương",
        "avatar": null,
        "rating": 5.0,
        "timeAgo": "3 tuần trước",
        "content":
            "Tour tổ chức rất chuyên nghiệp. Xe đời mới, tài xế lái xe cẩn thận. Du thuyền trên vịnh Hạ Long sang trọng, phòng nghỉ thoải mái. Sẽ giới thiệu cho bạn bè.",
        "images": [],
      },
      {
        "name": "Quang Minh",
        "avatar": null,
        "rating": 4.0,
        "timeAgo": "1 tháng trước",
        "content":
            "Lần đầu đi Sapa, cảnh đẹp quá! Bản Cát Cát rất thú vị, người dân thân thiện. Chỉ có điều thời tiết hơi lạnh nên nhớ mang đồ ấm. Nhìn chung tour rất đáng tiền.",
        "images": [],
      },
    ];

    return Column(
      key: const ValueKey('review'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 12),
        ...fakeReviews.map((review) => _buildReviewCard(review)),
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
              onPressed: () {},
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

  Widget _buildHeader() {
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
            children: const [
              Text(
                'Đánh giá chuyến đi ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '4.8 ',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF007AFF),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.star, color: Colors.amber, size: 24),
              Icon(Icons.star, color: Colors.amber, size: 24),
              Icon(Icons.star, color: Colors.amber, size: 24),
              Icon(Icons.star, color: Colors.amber, size: 24),
              Icon(Icons.star_half, color: Colors.amber, size: 24),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Dựa trên 142 đánh giá",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(review["avatar"]),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review["name"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        _buildStars(review["rating"]),
                        const SizedBox(width: 4),
                        Text(
                          review["timeAgo"],
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review["content"],
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          if ((review["images"] as List).isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: (review["images"] as List).map<Widget>((imgUrl) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    // Nếu trong API bạn em có trả về image trong API thì đổi qua dùng .network nhé
                    child: Image.network(
                      imgUrl,
                      width: 80,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
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
    int fullStars = rating.floor();
    bool hasHalf = (rating - fullStars) >= 0.5;

    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 14));
    }
    if (hasHalf) {
      stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 14));
    }
    return Row(children: stars);
  }
}
