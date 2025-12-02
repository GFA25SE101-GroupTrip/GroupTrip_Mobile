import 'package:flutter/material.dart';

class CancelNotice extends StatelessWidget {
  const CancelNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.warning, color: Color(0xFFDC2626), size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trip Canceled',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF991B1B),
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Chuyến đi đã bị hủy do không đủ số lượng người tham gia tối thiểu.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFB00020),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Số tiền đã thanh toán sẽ được hoàn lại trong 5–7 ngày làm việc.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFB00020),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
