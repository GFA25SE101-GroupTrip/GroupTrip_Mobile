import 'package:flutter/material.dart';

class DepositSchedule extends StatelessWidget {
  const DepositSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> fakeSchedule = [
      {
        "day": 1,
        "title": "Khởi hành",
        "activities": [
          "6:00 – Tập trung tại điểm hẹn, khởi hành đi Tà Năng",
          "10:00 – Bắt đầu trek, chinh phục đỉnh Tà Năng",
        ],
      },
      {
        "day": 2,
        "title": "Trekking",
        "activities": [
          "5:30 – Ngắm bình minh trên đỉnh núi",
          "8:00 – Tiếp tục hành trình đến Phan Dũng",
        ],
      },
      {
        "day": 3,
        "title": "Kết thúc",
        "activities": [
          "6:00 – Hoàn thành trek, trở về điểm xuất phát",
          "18:00 – Về đến TP.HCM",
        ],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(fakeSchedule.length, (index) {
        final day = fakeSchedule[index];
        final bool isLast = index == fakeSchedule.length - 1;

        return Container(
          margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ngày ${day['day']}: ${day['title']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...List.generate((day['activities'] as List).length, (
                          i,
                        ) {
                          final item = day['activities'][i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
