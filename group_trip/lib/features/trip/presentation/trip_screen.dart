import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String? _searchQuery;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Refresh trips data khi user kéo xuống
  Future<void> _onRefresh() async {
    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      await ref.refresh(SearchTripByNameProvider(_searchQuery!).future);
    } else if (_selectedDate != null) {
      await ref.refresh(SearchTripByDateProvider(
          _selectedDate!.toIso8601String().split('T')[0]).future);
    } else {
      await ref.refresh(TripModelProvider.future);
    }
  }

  @override
  Widget build(BuildContext context) {
    // watch trips from provider - use search results if available
    final displayAsync = _searchQuery != null && _searchQuery!.isNotEmpty
        ? ref.watch(SearchTripByNameProvider(_searchQuery!))
        : _selectedDate != null
            ? ref.watch(SearchTripByDateProvider(
                _selectedDate!.toIso8601String().split('T')[0]))
            : ref.watch(TripModelProvider);

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
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm điểm đến...',
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
                      const SizedBox(width: 8),
                      // Search button
                      Material(
                        color: const Color(0xFF007AFF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: IconButton(
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: () {
                            final query = _searchController.text.trim();
                            if (query.isNotEmpty) {
                              setState(() {
                                _searchQuery = query;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
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
                      child: DropdownFilter(
                        onDateSelected: (selectedDate) {
                          if (selectedDate != null) {
                            setState(() {
                              _selectedDate = selectedDate;
                              _searchQuery = null;
                              _searchController.clear();
                            });
                          }
                        },
                      ),
                    ),
                    crossFadeState: _showFilter ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 200),
                  ),
                ],
              ),
            ),

            // Scrollable content below the fixed top area
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: displayAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        if (_searchQuery == null || _searchQuery!.isEmpty)
                          if (_selectedDate == null)
                            TravelAgencySection(),
                        const SizedBox(height: 24),
                        Center(child: Text('Lỗi khi tải chuyến đi: $e')),
                      ],
                    ),
                  ),
                  data: (trips) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        if (_searchQuery == null || _searchQuery!.isEmpty)
                          if (_selectedDate == null)
                            TravelAgencySection(),
                        const SizedBox(height: 24),
                        if (_searchQuery != null && _searchQuery!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Kết quả tìm kiếm: "${_searchQuery!}" (${trips.length})',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF999999),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _searchQuery = null;
                                      _searchController.clear();
                                    });
                                  },
                                  child: const Text('Xóa'),
                                ),
                              ],
                            ),
                          )
                        else if (_selectedDate != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Chuyến đi ngày: ${DateFormat('dd/MM/yyyy', 'vi_VN').format(_selectedDate!)} (${trips.length})',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF999999),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedDate = null;
                                    });
                                  },
                                  child: const Text('Xóa'),
                                ),
                              ],
                            ),
                          ),
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
            ),
          ],
        ),
      ),
    );
  }
}
