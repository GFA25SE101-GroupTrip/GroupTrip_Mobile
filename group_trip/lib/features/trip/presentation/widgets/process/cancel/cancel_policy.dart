import 'package:flutter/material.dart';

class CancelPolicy extends StatelessWidget {
  const CancelPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        Icons.info_outline,
        const Color(0xFF3B82F6),
        'Hoàn tiền 100% khi trip bị hủy do không đủ số lượng',
      ),
      (
        Icons.access_time,
        const Color(0xFFF97316),
        'Thời gian hoàn tiền: 5–7 ngày làm việc',
      ),
      (
        Icons.verified_user_outlined,
        const Color(0xFF16A34A),
        'Bảo hiểm du lịch được hoàn lại (nếu có)',
      ),
      (
        Icons.phone,
        const Color(0xFF2563EB),
        'Liên hệ hotline để được hỗ trợ nhanh nhất',
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cancellation Policy',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          for (final (icon, color, text) in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                      ),
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
