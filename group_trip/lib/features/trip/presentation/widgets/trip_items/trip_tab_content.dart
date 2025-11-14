import 'package:flutter/material.dart';
import 'package:group_trip/features/trip/data/trip_rel_model.dart';
import 'package:group_trip/features/trip/presentation/widgets/trip_items/policy_section.dart';
import 'package:group_trip/features/trip/presentation/widgets/trip_items/price_departure_section.dart';
import 'package:group_trip/features/trip/presentation/widgets/trip_items/review_section.dart';
import 'package:group_trip/features/trip/presentation/widgets/trip_items/schedule_section.dart';


class TripTabContent extends StatelessWidget {
  final int selectedIndex;
  final TripModel trip; // TripModel? avoided import here to keep loose coupling

  const TripTabContent({super.key, required this.selectedIndex, required this.trip});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0.0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: _buildContentByIndex(),
    );
  }

  Widget _buildContentByIndex() {
    switch (selectedIndex) {
      case 0:
        return ScheduleSection(trip: trip.tripSegments);
      case 1:
        return PriceDepartureSection(tripDepartures: trip.tripDepartures);
      case 2:
        return PolicySection(trip: trip.tripRules!);
      case 3:
        return ReviewSection(feedbacks: trip.tripFeedbacks);
      default:
        return const Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Text(
              'Nội dung đang được cập nhật...',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        );
    }
  }
}
