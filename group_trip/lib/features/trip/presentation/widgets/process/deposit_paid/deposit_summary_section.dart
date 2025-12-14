import 'package:flutter/material.dart';
import 'package:group_trip/features/mytrip/data/mytrip_model.dart';
import 'package:intl/intl.dart';

class DepositSummarySection extends StatelessWidget {
  final MyTripModel? tripModel;

  const DepositSummarySection({super.key, this.tripModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông tin đặt chỗ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        if (tripModel != null) _buildSummaryFromModel() else _buildDefaultSummary(),
      ],
    );
  }

  Widget _buildSummaryFromModel() {
    final model = tripModel!;
    final startDateStr = model.startDate != null
        ? DateFormat('dd/MM/yyyy', 'vi_VN').format(model.startDate!)
        : 'N/A';

    return Column(
      children: [
        _buildSummaryRow("Ngày khởi hành", startDateStr),
        _buildSummaryRow("Số người đã tham gia", '${model.numberMemberIn ?? 0} người'),
        _buildSummaryRow(
          "Chi phí tạm tính",
          model.tripCostRanges.first.price != null
              ? '${(model.tripCostRanges.first.price!)} VND'
              : 'N/A',
          color: const Color(0xFF007AFF),
        ),
        _buildSummaryRow('Thanh toán qua ví', ''),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDefaultSummary() {
    return Column(
      children: [
        _buildSummaryRow("Ngày khởi hành", "20 - 22/12/2025"),
        _buildSummaryRow("Số người", "3 người"),
        _buildSummaryRow(
          "Chi phí tạm tính",
          "2,500,000 VND",
          color: const Color(0xFF007AFF),
        ),
        _buildSummaryRow("Phương thức thanh toán", "Thanh toán qua ví"),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Color(0xFF8A8A8E)),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
