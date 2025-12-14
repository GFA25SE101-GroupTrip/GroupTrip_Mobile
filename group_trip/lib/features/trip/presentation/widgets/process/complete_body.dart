import 'package:flutter/material.dart' hide TabBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/mytrip/data/mytrip_model.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/tab_content.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/deposit_paid/deposit_summary_section.dart';
import 'package:group_trip/features/trip/presentation/widgets/tab_bar_item.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/rating_bottom_sheet.dart';

class CompleteBody extends ConsumerStatefulWidget {
  final String imageUrl;
  final MyTripModel? tripModel;

  const CompleteBody({
    super.key,
    required this.imageUrl,
    this.tripModel,
  });

  @override
  ConsumerState<CompleteBody> createState() => _CompleteBodyState();
}

class _CompleteBodyState extends ConsumerState<CompleteBody> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Hành trình', 'Thành viên'];

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
                        // Info banner for completed trips
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFBFDBFE),
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Color(0xFF0284C7),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Chuyến đi đã hoàn thành. Vui lòng đánh giá trải nghiệm của bạn.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF0284C7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Trip summary section
                        DepositSummarySection(tripModel: widget.tripModel),
                        const SizedBox(height: 20),
                        // Schedule section
                        _buildScheduleSection(),
                        const SizedBox(height: 20),
                        // Tab bar
                        TabBarItem(
                          tabs: _tabs,
                          selectedIndex: _selectedTabIndex,
                          onTabSelected: (index) {
                            setState(() {
                              _selectedTabIndex = index;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        // Tab content
                        TabContent(
                          selectedIndex: _selectedTabIndex,
                          tripModel: widget.tripModel,
                        ),
                        const SizedBox(height: 20),
                        // Rating button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _showRatingBottomSheet,
                            icon: const Icon(Icons.star, color: Colors.white),
                            label: const Text('Đánh giá chuyến đi'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF59E0B),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showRatingBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => RatingBottomSheet(
          tripModel: widget.tripModel,
          scrollController: scrollController,
        ),
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lịch trình',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, color: Color(0xFF6B7280), size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ngày bắt đầu',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.tripModel?.startDate?.toString().split(' ')[0] ?? '-',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward, color: Color(0xFFD1D5DB), size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ngày kết thúc',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.tripModel?.endDate?.toString().split(' ')[0] ?? '-',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
