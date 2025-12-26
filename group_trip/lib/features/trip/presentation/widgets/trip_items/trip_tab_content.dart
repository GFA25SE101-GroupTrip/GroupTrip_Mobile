import 'package:flutter/material.dart';
import 'package:group_trip/features/trip/data/trip_rel_model.dart';
import 'package:group_trip/features/trip/presentation/widgets/trip_items/image_section.dart';
import 'package:group_trip/features/trip/presentation/widgets/trip_items/policy_section.dart';
import 'package:group_trip/features/trip/presentation/widgets/trip_items/price_departure_section.dart';
import 'package:group_trip/features/trip/presentation/widgets/trip_items/review_section.dart';
import 'package:group_trip/features/trip/presentation/widgets/trip_items/schedule_section.dart';
import 'package:group_trip/features/trip/presentation/widgets/trip_items/insurance_section.dart';


class TripTabContent extends StatelessWidget {
  final int selectedIndex;
  final TripModel trip;
  final String? selectedInsuranceId;
  final Function(String)? onInsuranceSelected;

  const TripTabContent({
    super.key,
    required this.selectedIndex,
    required this.trip,
    this.selectedInsuranceId,
    this.onInsuranceSelected,
  });

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
        return PriceDepartureSection(
          tripDepartures: trip.tripDepartures,
          tripImage:
              trip.tripImages.isNotEmpty ? trip.tripImages.first.imgUrl : '',
          tripTitle: trip.name,
          selectedInsuranceId: selectedInsuranceId,
        );
      case 2:
        return PolicySection(trip: trip.tripRules);
      case 3:
        return InsuranceSection(
          insurances: trip.insurances,
          onInsuranceSelected: (insurance) {
            onInsuranceSelected?.call(insurance.id);
          },
        );
      case 4:
        return ImageSection(images: trip.tripImages);
      case 5:
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
