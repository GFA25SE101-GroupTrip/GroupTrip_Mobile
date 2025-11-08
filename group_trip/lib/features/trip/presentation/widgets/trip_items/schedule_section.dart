import 'package:flutter/material.dart';

class ScheduleSection extends StatelessWidget {
  const ScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> fakeSchedule = [
      {
        "day": 1,
        "title": "Hà Nội – Hạ Long",
        "activities": [
          "08:00 – Khởi hành từ Hà Nội",
          "12:00 – Đến Hạ Long, lên du thuyền",
          "14:00 – Tham quan Động Thiên Cung",
          "19:00 – Tự do trên du thuyền, ngắm hoàng hôn",
        ],
      },
      {
        "day": 2,
        "title": "Hạ Long – Sapa",
        "activities": [
          "07:00 – Ngắm bình minh trên vịnh",
          "09:00 – Thăm làng chài Cửa Vạn",
          "14:00 – Trở lại Hà Nội, chuẩn bị đi Sapa",
          "20:00 – Tàu đêm khởi hành lên Lào Cai",
        ],
      },
      {
        "day": 3,
        "title": "Sapa – Fansipan",
        "activities": [
          "06:00 – Đến Lào Cai, di chuyển lên Sapa",
          "09:00 – Cáp treo lên đỉnh Fansipan",
          "14:00 – Tham quan bản Cát Cát",
          "19:00 – Nghỉ đêm tại khách sạn ở Sapa",
        ],
      },
    ];

    return Column(
      key: const ValueKey('schedule'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(fakeSchedule.length, (index) {
        final day = fakeSchedule[index];
        return Container(
          key: ValueKey(day['day']),
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
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: const Color(0xFF007AFF),
                    child: Text(
                      '${day['day']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Ngày ${day['day']}: ${day['title']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...List.generate((day['activities'] as List).length, (i) {
                final item = day['activities'][i];
                return Padding(
                  padding: const EdgeInsets.only(left: 28, bottom: 4),
                  child: Text(
                    '• $item',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}
