import 'package:flutter/material.dart';

class PriceDepartureSection extends StatelessWidget {
  const PriceDepartureSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> fakeDepartures = [
      {
        "date": "15/11/2024",
        "weekday": "Thứ 6 - Thứ 2",
        "price": "8.500.000đ",
        "seats": "Còn 8 chỗ",
      },
      {
        "date": "22/11/2024",
        "weekday": "Thứ 6 - Thứ 2",
        "price": "8.500.000đ",
        "seats": "Còn 12 chỗ",
      },
    ];

    final List<String> included = [
      "Xe du lịch đời mới có máy lạnh",
      "Du thuyền 5 sao tại Hạ Long",
      "Khách sạn 4 sao tại Sapa",
      "Vé tham quan theo chương trình",
      "Bảo hiểm du lịch",
    ];

    return Column(
      key: const ValueKey('price_departure'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...fakeDepartures.map((item) {
          return Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['date'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      item['price'],
                      style: const TextStyle(
                        color: Color(0xFF007AFF),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['weekday'],
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      item['seats'],
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(color: Color(0xFF007AFF)),
                    ),
                    onPressed: () {
                      // TODO: handle select date
                    },
                    child: const Text(
                      "Chọn ngày này",
                      style: TextStyle(
                        color: Color(0xFF007AFF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Giá bao gồm',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              ...included.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 4),
                  child: Text(
                    "• $item",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
