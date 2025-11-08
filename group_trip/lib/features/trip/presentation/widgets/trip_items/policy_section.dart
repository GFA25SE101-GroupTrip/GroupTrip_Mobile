import 'package:flutter/material.dart';

class PolicySection extends StatelessWidget {
  const PolicySection({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<String>> fakePolicy = {
      "Chính sách hủy tour": [
        "Hủy trước 15 ngày: Hoàn 100% tiền",
        "Hủy trước 7–14 ngày: Hoàn 70% tiền",
        "Hủy trước 3–6 ngày: Hoàn 50% tiền",
        "Hủy trong 2 ngày: Không hoàn tiền",
      ],
      "Yêu cầu tham gia": [
        "CMND/CCCD còn hạn sử dụng",
        "Sức khỏe tốt, không có bệnh truyền nhiễm",
        "Trẻ em dưới 12 tuổi phải có người lớn đi cùng",
        "Tuân thủ lịch trình và quy định của hướng dẫn viên",
      ],
      "Lưu ý": [
        "Thời tiết có thể ảnh hưởng đến lịch trình",
        "Mang theo quần áo ấm khi đi Sapa",
        "Giữ gìn tài sản cá nhân cẩn thận",
      ],
    };
    return Column(
      key: const ValueKey('policy'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fakePolicy.entries.map((section) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section.key,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              ...section.value.map(
                (rule) => Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 4),
                  child: Text(
                    "• $rule",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
