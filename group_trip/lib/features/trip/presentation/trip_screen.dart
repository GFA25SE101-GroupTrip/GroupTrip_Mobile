import 'package:flutter/material.dart';
import 'package:group_trip/features/trip/data/trip_model.dart';
import 'package:group_trip/features/trip/presentation/widgets/dropdown_filter.dart';
import 'package:group_trip/features/trip/presentation/widgets/header.dart';
import 'package:group_trip/features/trip/presentation/widgets/travelRepresentative/TravelAgencySection.dart';
import 'package:group_trip/features/trip/presentation/widgets/trip_items/trip_card.dart';


class TripScreen extends StatefulWidget {
  static const routeName = '/trip';
  const TripScreen({super.key});
  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  bool _showFilter = false;
  final List<TripModel> trips = [
    TripModel(
      imageUrl: 'https://picsum.photos/seed/2/800/400',
      label: 'HOT',
      title: 'Hạ Long - Sapa 4N3Đ',
      description:
          'Khám phá vịnh Hạ Long và núi rừng Sapa trong chuyến đi 4 ngày 3 đêm đầy thú vị',
      price: 'Từ 8.500.000đ',
      date: '15/11/2024',
      duration: '4 ngày 3 đêm',
      organizer: 'Saigon Tourist',
      peopleRange: '2–15 người',
    ),
    TripModel(
      imageUrl: 'https://picsum.photos/seed/2/800/400',
      label: 'NEW',
      title: 'Campuchia - Angkor 3N2Đ',
      description: 'Tham quan quần thể đền Angkor Wat',
      price: 'Từ 6.200.000đ',
      date: '20/11/2024',
      duration: '4 ngày 3 đêm',
      organizer: 'Vietravel',
      peopleRange: '2–15 người',
    ),
    TripModel(
      imageUrl: 'https://picsum.photos/seed/2/800/400',
      label: 'SALE',
      title: 'Phú Quốc 3N2Đ',
      description: 'Trải nghiệm biển đảo tuyệt đẹp tại Phú Quốc',
      price: 'Từ 5.500.000đ',
      date: '01/12/2024',
      duration: '4 ngày 3 đêm',
      organizer: 'TST Tourist',
      peopleRange: '2–15 người',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFE5E7EB),
        body: Column(
          children: [
            // Top fixed area: header + search/filter
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 46, bottom: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Header(),
                  const SizedBox(height: 20),
                  // Search row with filter button
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm điểm đến...',
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Filter button toggles the dropdown filter
                      Material(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 1,
                        child: IconButton(
                          icon: const Icon(Icons.filter_list, color: Colors.grey),
                          onPressed: () => setState(() => _showFilter = !_showFilter),
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 8),
                  // Animated drop-down for filter controls
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: const DropdownFilter(),
                    ),
                    crossFadeState: _showFilter ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 200),
                  ),
                ],
              ),
            ),

            // Scrollable content below the fixed top area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    TravelAgencySection(),
                    const SizedBox(height: 24),
                    ...trips.map(
                      (trip) => TripCard(
                        imageUrl: trip.imageUrl,
                        label: trip.label,
                        title: trip.title,
                        description: trip.description,
                        price: trip.price,
                        date: trip.date,
                        duration: trip.duration,
                        organizer: trip.organizer,
                        peopleRange: trip.peopleRange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
