import 'package:flutter/material.dart' hide TabBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:group_trip/features/mytrip/data/mytrip_model.dart';
import 'package:group_trip/features/mytrip/providers/mytrip_provider.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/tab_content.dart';
import 'package:group_trip/core/api/contact.dart';
import '../../tab_bar_item.dart';

class PendingBody extends ConsumerStatefulWidget {
  final String imageUrl;
  final MyTripModel? tripModel;
  final String? departureId;

  const PendingBody({
    super.key,
    required this.imageUrl,
    this.tripModel,
    this.departureId,
  });

  @override
  ConsumerState<PendingBody> createState() => _PendingBodyState();
}

class _PendingBodyState extends ConsumerState<PendingBody> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Hành trình', 'Thành viên đã tham gia'];
  bool _isLoading = false;

  Future<void> _handleCancelBooking(WidgetRef widgetRef) async {
    if (widget.tripModel == null || widget.tripModel!.departureId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Không thể hủy chuyến đi')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await widgetRef.read(
        mytripOutTripProvider(widget.tripModel!.departureId).future,
      );

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hủy đặt chỗ thành công'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );

        // Wait a moment then navigate back
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          // Navigate back to previous screen
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

  Future<void> _handleContactTrip(WidgetRef widgetRef) async {
    if (widget.tripModel == null || widget.tripModel!.departureId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể liên hệ chuyến đi')),
      );
      return;
    }

    try {
      // Call departureChatProvider to get chat ID
      final chatData = await widgetRef.read(
        departureChatProvider(widget.tripModel!.departureId).future,
      );

      if (mounted && chatData != null) {
        // Navigate to ChatDetailScreen with chat ID
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
    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Container(
                  margin: const EdgeInsets.only(top: 280),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F7F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF5D5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.info,
                                  color: Colors.orange,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Chuyến đi sẽ được xác nhận khi đủ số người tham gia.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Tóm tắt đặt chỗ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildSummaryRow(
                            "Ngày khởi hành",
                            _formatDateRange(),
                          ),
                          _buildSummaryRow(
                            "Số người đã tham gia",
                            "${widget.tripModel?.numberMemberIn ?? 0}/${widget.tripModel?.maxUsers ?? 0} người",
                          ),
                          _buildSummaryRow(
                            "Chi phí tạm tính",
                            "Đợi xác nhận",
                            color: const Color(0xFF007AFF),
                          ),
                          _buildSummaryRow(
                            "Phương thức thanh toán",
                            "Thanh toán qua ví hệ thống",
                          ),
                          const SizedBox(height: 24),
                          TabBarItem(
                            tabs: _tabs,
                            selectedIndex: _selectedTabIndex,
                            onTabSelected: (index) {
                              setState(() {
                                _selectedTabIndex = index;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          TabContent(
                            selectedIndex: _selectedTabIndex,
                            tripModel: widget.tripModel,
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
          bottom: -10,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.white,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Color(0xFFE5E5E5), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed:
                            _isLoading ? null : () => _handleCancelBooking(ref),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 18,
                        ),
                        label: Text(
                          _isLoading ? 'Đang xử lý...' : 'Hủy đặt chỗ',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          backgroundColor: const Color(0xFFFFF0F0),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _handleContactTrip(ref),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007AFF),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.chat_bubble,
                              size: 18.0,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              'Liên hệ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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

  String _formatDateRange() {
    if (widget.tripModel == null) return "Chưa cập nhật";

    try {
      final startDate = widget.tripModel!.startDate;
      final endDate = widget.tripModel!.endDate;

      if (startDate == null || endDate == null) {
        return "Chưa cập nhật";
      }

      final formatter = DateFormat('dd MMM yyyy', 'vi_VN');
      final start = formatter.format(startDate);
      final end = formatter.format(endDate);

      return '$start - $end';
    } catch (e) {
      return "Chưa cập nhật";
    }
  }
}
