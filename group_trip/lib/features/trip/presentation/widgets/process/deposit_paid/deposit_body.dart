import 'package:flutter/material.dart' hide TabBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/mytrip/data/mytrip_model.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/tab_content.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/deposit_paid/deposit_summary_section.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/deposit_paid/deposit_payment_timeline_section.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/deposit_paid/deposit_action_buttons.dart';

import '../../tab_bar_item.dart';

class DepositBody extends ConsumerStatefulWidget {
  final String imageUrl;
  final MyTripModel? tripModel;

  const DepositBody({super.key, required this.imageUrl, this.tripModel});

  @override
  ConsumerState<DepositBody> createState() => _DepositBodyState();
}

class _DepositBodyState extends ConsumerState<DepositBody> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Hành trình', 'Thành viên'];

  @override
Widget build(BuildContext context) {
  return Container(
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

          if (widget.tripModel == null ||
              (!(widget.tripModel!.departureStatus
                      ?.toLowerCase()
                      .contains('full') ??
                  false) &&
               !(widget.tripModel!.departureStatus
                      ?.toLowerCase()
                      .contains('ready') ??
                  false)))
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5D5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info,
                      color: Colors.orange, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Vui lòng thanh toán trước thời hạn thanh toán.',
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
          DepositSummarySection(tripModel: widget.tripModel),
          const SizedBox(height: 16),
          DepositPaymentTimelineSection(tripModel: widget.tripModel),
          const SizedBox(height: 24),

          TabBarItem(
            tabs: _tabs,
            selectedIndex: _selectedTabIndex,
            onTabSelected: (index) {
              setState(() => _selectedTabIndex = index);
            },
          ),

          const SizedBox(height: 16),
          SizedBox(
            child: TabContent(
              selectedIndex: _selectedTabIndex,
              tripModel: widget.tripModel,
            ),
          ),

        ],
      ),
    ),
  );
}







}
