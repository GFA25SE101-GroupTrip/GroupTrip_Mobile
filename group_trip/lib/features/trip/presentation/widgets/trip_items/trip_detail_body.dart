import 'package:flutter/material.dart' hide TabBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/trip/data/trip_rel_model.dart';
import 'package:group_trip/features/trip/presentation/widgets/tab_bar_item.dart';
import 'package:group_trip/features/trip/presentation/widgets/trip_items/trip_tab_content.dart';
import 'package:group_trip/features/trip/providers/tripProvider.dart';
import 'trip_highlight_section.dart';
import 'trip_join_button.dart';


class TripDetailBody extends ConsumerStatefulWidget {
  final String tripId;
  final String title;
  final String price;
  final String description;
  final String duration;
  final String peopleRange;

  const TripDetailBody({
    super.key,
    required this.tripId,
    required this.title,
    required this.price,
    required this.description,
    required this.duration,
    required this.peopleRange,
  });
  @override
  ConsumerState<TripDetailBody> createState() => _TripDetailBodyState();
}

class _TripDetailBodyState extends ConsumerState<TripDetailBody> {
  int _selectedTabIndex = 0;

  final List<String> _tabs = [
    'Lịch trình',
    'Giá & Khởi hành',
    'Quy định',
    'Thư viện ảnh',
    'Review',
  ];

  @override
  Widget build(BuildContext context) {
    final TripdetailContent = ref.watch(TripDetailModelProvider(widget.tripId));
    TripModel TripdetailContentData = TripdetailContent.asData!.value;
    return SingleChildScrollView(
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
              const SizedBox(height: 16),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    widget.price,
                    style: const TextStyle(
                      color: Color(0xFF007AFF),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    ' / người',
                    style: TextStyle(color: Color(0xFF8A8A8E), fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.duration,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.people_alt_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.peopleRange,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TripHighlightSection(tags: TripdetailContentData.tripTagRelations),
              const SizedBox(height: 24),
              // const JoinTripButton(),
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
              const SizedBox(height: 20),
              TripTabContent(selectedIndex: _selectedTabIndex, trip: TripdetailContentData),
            ],
          ),
        ),
      ),
    );
  }
}
