import 'package:flutter/material.dart';
import 'package:group_trip/features/mytrip/data/mytrip_model.dart';
import 'package:intl/intl.dart';

class DepositPaymentTimelineSection extends StatelessWidget {
  final MyTripModel? tripModel;

  const DepositPaymentTimelineSection({super.key, this.tripModel});

  @override
  Widget build(BuildContext context) {
    // Ẩn nếu departureStatus là "full" (không phải "fullpayment")
    if (tripModel != null && tripModel!.departureStatus != null) {
      final status = tripModel!.departureStatus!.toLowerCase();
      if (status == 'full') {
        return const SizedBox.shrink();
      }
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E5E5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lịch thanh toán',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 12),
          if (tripModel != null) _buildPaymentTimelineFromModel() else _buildDefaultTimeline(),
        ],
      ),
    );
  }

  Widget _buildPaymentTimelineFromModel() {
    final model = tripModel!;
    final currentUserStatus = model.currentUserStatus?.toLowerCase() ?? '';
    final departureStatus = model.departureStatus?.toLowerCase() ?? '';

    double totalCost = model.tripCostRanges.first.price?.toDouble() ?? 0.0;
    final depositAmount = totalCost / 2;
    final remainingAmount = totalCost / 2;

    final depositDateStr = model.depositTime != null
        ? DateFormat('dd/MM/yyyy', 'vi_VN').format(model.depositTime!)
        : 'N/A';
    final fullPayDateStr = model.fullPayTime != null
        ? DateFormat('dd/MM/yyyy', 'vi_VN').format(model.fullPayTime!)
        : 'N/A';

    return Column(
      children: [
        if (currentUserStatus.contains('active') && departureStatus.contains('deposit'))
          _buildPaymentRequest(
            title: 'Yêu cầu đặt cọc',
            amount: depositAmount,
            deadline: depositDateStr,
            remainingTime: model.timeRemainToDeposit ?? 'N/A',
            percentage: '50%',
          )
        else if (currentUserStatus.contains('deposit') && departureStatus.contains('deposit'))
          _buildDepositConfirmed(
            depositDateStr: depositDateStr,
            fullPayDateStr: fullPayDateStr,
            fullPayRemaining: model.timeRemainToFullPay ?? 'N/A',
          )
        else if (currentUserStatus.contains('deposit') && departureStatus.contains('fullpayment'))
          _buildPaymentRequest(
            title: 'Yêu cầu thanh toán toàn bộ',
            amount: remainingAmount,
            deadline: fullPayDateStr,
            remainingTime: model.timeRemainToFullPay ?? 'N/A',
            percentage: '50%',
          )
        else if (currentUserStatus.contains('fullpayment') && departureStatus.contains('fullpayment'))
          _buildPaymentCompleted(fullPayDateStr),
      ],
    );
  }

  Widget _buildDefaultTimeline() {
    return Column(
      children: [
        _buildPaymentTimeline(
          'Ngày đặt cọc',
          '15/12/2025',
          'Đã hoàn thành',
          Colors.green,
        ),
        const SizedBox(height: 8),
        _buildPaymentTimeline(
          'Ngày thanh toán toàn bộ',
          '18/12/2025',
          'Đang xử lý',
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildPaymentRequest({
    required String title,
    required double amount,
    required String deadline,
    required String remainingTime,
    required String percentage,
  }) {
    final formattedAmount = '${amount.toStringAsFixed(0)} VND';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Số tiền', style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8E))),
                  const SizedBox(height: 4),
                  Text(
                    formattedAmount,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Hạn thanh toán', style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8E))),
                  const SizedBox(height: 4),
                  Text(
                    deadline,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                child: Text(
                  'Thanh toán: $percentage',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFF59E0B)),
                ),
              ),
              Text(
                'Còn lại: $remainingTime',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDepositConfirmed({
    required String depositDateStr,
    required String fullPayDateStr,
    required String fullPayRemaining,
  }) {
    return Column(
      children: [
        _buildPaymentTimeline('Ngày đặt cọc', depositDateStr, 'Đã hoàn thành', Colors.green),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chờ đến hạn thanh toán toàn bộ',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hạn thanh toán', style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8E))),
                      const SizedBox(height: 4),
                      Text(fullPayDateStr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Còn lại', style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8E))),
                      const SizedBox(height: 4),
                      Text(
                        fullPayRemaining,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0284C7)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentCompleted(String fullPayDateStr) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        border: Border.all(color: const Color(0x4422C55E)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Đã thanh toán 100%',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.green),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ngày: $fullPayDateStr',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF8A8A8E)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTimeline(String title, String date, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
              const SizedBox(height: 4),
              Text(date, style: const TextStyle(fontSize: 14, color: Color(0xFF8A8A8E))),
            ],
          ),
          Text(status, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: statusColor)),
        ],
      ),
    );
  }
}
