import 'package:flutter/material.dart';
import 'package:group_trip/features/trip/data/cancel_summary_model.dart';

class CancelSummary extends StatelessWidget {
  const CancelSummary({super.key});

  @override
  Widget build(BuildContext context) {
    // Giả lập data – sau này bạn sẽ thay bằng CancelSummaryModel từ API
    final data = CancelSummaryModel.mock();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cancellation Summary',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        ...data.toRows().map(
          (row) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    row.label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8A8A8E),
                    ),
                  ),
                ),
                Text(
                  row.value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: row.color ?? Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
