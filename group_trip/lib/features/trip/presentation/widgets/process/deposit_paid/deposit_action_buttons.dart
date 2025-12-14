import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:group_trip/features/mytrip/data/mytrip_model.dart';
import 'package:group_trip/features/mytrip/providers/mytrip_provider.dart';
import 'package:group_trip/core/api/contact.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/deposit_paid/payment_sheet.dart';

class DepositActionButtons extends ConsumerStatefulWidget {
  final MyTripModel? tripModel;

  const DepositActionButtons({super.key, this.tripModel});

  @override
  ConsumerState<DepositActionButtons> createState() => _DepositActionButtonsState();
}

class _DepositActionButtonsState extends ConsumerState<DepositActionButtons> {
  bool _isLoading = false;

  Future<void> _handleCancelBooking() async {
    if (widget.tripModel == null || widget.tripModel!.departureId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể hủy chuyến đi')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(mytripOutTripProvider(widget.tripModel!.departureId).future);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hủy đặt chỗ thành công'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleContactTrip() async {
    if (widget.tripModel == null || widget.tripModel!.departureId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể liên hệ chuyến đi')),
      );
      return;
    }

    try {
      final chatData = await ref.read(
        departureChatProvider(widget.tripModel!.departureId).future,
      );

      if (mounted && chatData != null) {
        final chatId = chatData['chatId'] ?? chatData['id'] ?? '';
        if (chatId.isNotEmpty) {
          context.push('/chat/$chatId');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không tìm thấy thông tin chat')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row 1: Cancel + Contact
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isLoading ? null : _handleCancelBooking,
                icon: const Icon(Icons.close, color: Colors.red, size: 18),
                label: Text(
                  _isLoading ? 'Đang xử lý...' : 'Hủy đặt chỗ',
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  backgroundColor: const Color(0xFFFFF0F0),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _handleContactTrip,
                icon: const Icon(Icons.chat_bubble, size: 18, color: Colors.white),
                label: const Text(
                  'Liên hệ',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007AFF),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 2: Payment Button
        _buildPaymentButtonRow(),
      ],
    );
  }

  Widget _buildPaymentButtonRow() {
    if (widget.tripModel == null) {
      return SizedBox.shrink();
    }

    final currentUserStatus = widget.tripModel!.currentUserStatus?.toLowerCase() ?? '';
    final departureStatus = widget.tripModel!.departureStatus?.toLowerCase() ?? '';
    final totalAmount = widget.tripModel!.tripCostRanges.isNotEmpty 
        ? widget.tripModel!.tripCostRanges.first.price 
        : 0;
    final deposit = totalAmount ~/ 2;
    final departureDateStr = DateFormat('dd/MM/yyyy', 'vi_VN').format(widget.tripModel!.startDate);
    final tripTitle = widget.tripModel!.name;
    final tripImage = widget.tripModel!.img;
    final departureId = widget.tripModel!.departureId;
    final numberMembers = widget.tripModel!.numberMemberIn;

    // Active + Deposit: Hiển thị nút thanh toán cọc
    if (currentUserStatus.contains('active') && departureStatus.contains('deposit')) {
      return ElevatedButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (_) => PaymentSheet(
            tripImage: tripImage,
            tripTitle: tripTitle,
            tripDepartureDate: departureDateStr,
            totalAmount: totalAmount,
            deposit: deposit,
            tripDepartureId: departureId,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF59E0B),
          padding: const EdgeInsets.symmetric(vertical: 14),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Thanh toán đặt cọc',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      );
    }

    // Deposit + FullPayment: Hiển thị nút thanh toán toàn bộ
    if (currentUserStatus.contains('deposit') && departureStatus.contains('fullpayment')) {
      return ElevatedButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (_) => PaymentSheet(
            tripImage: tripImage,
            tripTitle: tripTitle,
            tripDepartureDate: departureDateStr,
            totalAmount: totalAmount,
            deposit: deposit,
            tripDepartureId: departureId,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF007AFF),
          padding: const EdgeInsets.symmetric(vertical: 14),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Thanh toán toàn bộ',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      );
    }

    // Deposit + Deposit hoặc FullPayment + FullPayment: Không hiển thị nút thanh toán
    return const SizedBox.shrink();
  }
}
