import 'package:flutter/material.dart' hide TabBar;
import 'package:group_trip/features/trip/presentation/widgets/process/confirm/payment_sheet.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/tab_content.dart';

import '../../tab_bar_item.dart';

class ConfirmBody extends StatefulWidget {
  final String imageUrl;

  const ConfirmBody({super.key, required this.imageUrl});

  @override
  State<ConfirmBody> createState() => _ConfirmBodyState();
}

class _ConfirmBodyState extends State<ConfirmBody> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Itinerary', 'Departure', 'Rules', 'Gallery'];

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
                          child: Row(
                            children: const [
                              Icon(Icons.info, color: Colors.orange, size: 18),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Vui lòng đặt cọc trước thời hạn thanh toán.',
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
                          'Booking Summary',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Bạn đã đặt 3 người, tổng tiền dự kiến là 5.500.000 VND.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF8A8A8E),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildSummaryRow("Ngày khởi hành", "20 - 22/12/2025"),
                        _buildSummaryRow("Số người", "3 người"),
                        _buildSummaryRow(
                          "Chi phí tạm tính",
                          "5.500.000 VND",
                          color: const Color(0xFF007AFF),
                        ),
                        _buildSummaryRow(
                          "Phương thức thanh toán",
                          "Chuyển khoản",
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
                        TabContent(selectedIndex: _selectedTabIndex),
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
                        onPressed: () {
                          // TODO: Cancel booking
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 18,
                        ),
                        label: const Text(
                          'Cancel Booking',
                          style: TextStyle(
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
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const PaymentSheet(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007AFF),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Đặt cọc',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
}
