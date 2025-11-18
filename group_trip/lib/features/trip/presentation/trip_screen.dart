import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/utils/dataFormat.dart';
import 'package:group_trip/features/trip/data/trip_model.dart';
import 'package:group_trip/features/trip/presentation/widgets/dropdown_filter.dart';
import 'package:group_trip/features/trip/presentation/widgets/header.dart';
import 'package:group_trip/features/trip/presentation/widgets/travelRepresentative/TravelAgencySection.dart';
import 'package:group_trip/features/trip/presentation/widgets/trip_items/trip_card.dart';
import 'package:group_trip/features/trip/providers/tripProvider.dart';


class TripScreen extends ConsumerStatefulWidget {
  static const routeName = '/trip';
  const TripScreen({super.key});

  @override
  ConsumerState<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends ConsumerState<TripScreen> {
  bool _showFilter = false;

  @override
  Widget build(BuildContext context) {
    // watch trips from provider
    final tripsAsync = ref.watch(TripModelProvider);

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
              child: tripsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      TravelAgencySection(),
                      const SizedBox(height: 24),
                      Center(child: Text('Lỗi khi tải chuyến đi: $e')),
                    ],
                  ),
                ),
                data: (trips) => SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      TravelAgencySection(),
                      const SizedBox(height: 24),
                      if (trips.isEmpty)
                        const Center(child: Text('Không có chuyến nào'))
                      else
                        ...trips.map((trip) {
                          // map TripModel (relational) -> UI TripCard fields
                          final imageUrl = trip.tripImages.isNotEmpty ? trip.tripImages.first.imgUrl : 'https://res.cloudinary.com/db18zz55c/image/upload/v1762439871/uploads/scaled_38.jpg';
                          final label = trip.status.toString().toUpperCase();
                          final title = trip.name;
                          final description = trip.description;

                          String price = '';
                          String date = '';
                          String duration = '';
                          if (trip.tripDepartures.isNotEmpty) {
                            final d = trip.tripDepartures.first;
                            if (d.tripCostRanges.isNotEmpty) {
                              final p = d.tripCostRanges.first.price;
                              price = 'Từ ${formatIntCurrency(p)}';
                            }
                            try {
                              final sd = d.startDate;
                              date = '${sd.day.toString().padLeft(2, '0')}/${sd.month.toString().padLeft(2, '0')}/${sd.year}';
                              final diff = d.endDate.difference(d.startDate).inDays;
                              if (diff > 0) {
                                duration = '$diff ngày';
                              }
                            } catch (_) {
                              // ignore parsing errors
                            }
                          }

                          final organizer = trip.creatorName ?? trip.creatorId;
                          final peopleRange = '${trip.minUsers}-${trip.maxUsers} người';

                          return TripCard(
                            imageUrl: imageUrl,
                            label: label,
                            title: title,
                            description: description,
                            price: price,
                            date: date,
                            duration: duration,
                            organizer: organizer,
                            peopleRange: peopleRange,
                            tripId: trip.id,
                            trip: trip,
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
