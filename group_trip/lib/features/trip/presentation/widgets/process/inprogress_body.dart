import 'package:flutter/material.dart' hide TabBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/mytrip/data/mytrip_model.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/tab_content.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/deposit_paid/deposit_summary_section.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/inprogress_action_buttons.dart';
import 'package:group_trip/features/trip/presentation/widgets/tab_bar_item.dart';

class InProgressBody extends ConsumerStatefulWidget {
  final String imageUrl;
  final MyTripModel? tripModel;

  const InProgressBody({super.key, required this.imageUrl, this.tripModel});

  @override
  ConsumerState<InProgressBody> createState() => _InProgressBodyState();
}

class _InProgressBodyState extends ConsumerState<InProgressBody> {
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
                        // Info banner for in-progress trips
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.info, color: Color(0xFF007AFF), size: 18),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Chuyến đi đang diễn ra. Hãy giữ liên lạc với hướng dẫn viên.',
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
                        // Trip summary
                        DepositSummarySection(tripModel: widget.tripModel),
                        const SizedBox(height: 16),
                        // Schedule/Timeline
                        _buildScheduleSection(),
                        const SizedBox(height: 24),
                        // Tabs
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
                        TabContent(selectedIndex: _selectedTabIndex, tripModel: widget.tripModel),
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
                child: InProgressActionButtons(tripModel: widget.tripModel),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleSection() {
    if (widget.tripModel == null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E5E5)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lịch trình',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: 12),
            Text(
              'Chưa có thông tin lịch trình',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      );
    }

    final model = widget.tripModel!;
    final startDate = model.startDate;
    final endDate = model.endDate;

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
            'Lịch trình',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ngày khởi hành',
                    style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8E)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    startDate.toString().split(' ')[0],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Ngày kết thúc',
                    style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8E)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    endDate.toString().split(' ')[0],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
