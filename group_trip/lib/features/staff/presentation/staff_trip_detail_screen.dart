import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/mytrip/data/mytriptracking_model.dart';
import 'package:intl/intl.dart';
import 'package:group_trip/features/staff/data/staff_data.dart';
import 'package:group_trip/features/mytrip/providers/mytrip_provider.dart';
import 'package:group_trip/features/staff/presentation/widgets/trip_header_widgets.dart';
// import 'package:group_trip/features/staff/presentation/widgets/tracking_widgets.dart';
import 'package:group_trip/features/staff/presentation/providers/staff_provider.dart';
import 'package:group_trip/features/staff/presentation/widgets/trip_header_info.dart';
import 'package:group_trip/features/staff/presentation/widgets/segment_card.dart';
import 'package:group_trip/features/staff/providers/staff_providers.dart';
import 'package:group_trip/features/Map/presentation/map_screen.dart';

class StaffTripDetailScreen extends ConsumerWidget {
  final DepartureStaff trip;

  const StaffTripDetailScreen({super.key, required this.trip});

  String _getStatusLabel(String? status) {
    if (status == null) return 'N/A';
    switch (status.toLowerCase()) {
      case 'ready':
        return 'Sẵn sàng';
      case 'full':
        return 'Đợi chốt nhóm';
      case 'completed':
        return 'Đã hoàn thành';
      case 'inprogress':
        return 'Đang diễn ra';
      case 'cancelled':
        return 'Đã hủy';
      case 'pending':
        return 'Chờ bắt đầu';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    // Fetch tracking route data using Riverpod provider
    final trackingRouteAsync = ref.watch(mytripTrackingRouteProvider(trip.id));
    
    // ✅ Test tripLocationsProvider - gọi để extract tất cả vị trí
    final tripLocationsAsync = ref.watch(tripLocationsProvider(trip.tripId));
    
    // Debug: in danh sách vị trí
    tripLocationsAsync.when(
      data: (locations) {
        print('📍 Trip Locations (${locations.length}):');
        for (final loc in locations) {
          print('   - ${loc.name} (${loc.type}): ${loc.latitude}, ${loc.longitude}');
        }
      },
      loading: () => print('⏳ Loading trip locations...'),
      error: (err, st) => print('❌ Error loading locations: $err'),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: trackingRouteAsync.when(
        data:
            (trackingRoute) =>
                _buildContent(context, ref, dateFormat, trackingRoute),
        loading:
            () => const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
        error:
            (error, stack) => Center(
              child: Text(
                'Lỗi: $error',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            onPressed: () {
              // ✅ Navigate tới MapScreen với trip locations
              tripLocationsAsync.when(
                data: (locations) {
                  if (locations.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Không có dữ liệu vị trí cho chuyến đi này'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapScreen(
                        locations: locations,
                        title: trip.tripName ?? 'Bản đồ chuyến đi',
                      ),
                    ),
                  );
                },
                loading: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đang tải dữ liệu bản đồ...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                error: (err, st) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lỗi tải bản đồ: $err'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.map, size: 20),
            label: const Text(
              'Xem bản đồ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    DateFormat dateFormat,
    TrackingRoute? trackingRoute,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trip header info
          TripHeaderInfo(trip: trip, dateFormat: dateFormat),
          // Date and status info section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF007AFF).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF007AFF).withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ngày khởi hành',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dateFormat.format(DateTime.parse(trip.startDate)),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF007AFF),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF22C55E).withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trạng thái',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _getStatusLabel(trip.departureStatus),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF22C55E),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Routing section
          if (trackingRoute != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lộ trình chuyến đi',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ..._buildSegmentsList(
                    trackingRoute.segmentTrackingViews ?? [],
                    ref,
                    context,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildSegmentsList(
    List<SegmentTrackingViews> segments,
    WidgetRef ref,
    BuildContext context,
  ) {
    return segments.asMap().entries.map((entry) {
      final index = entry.key;
      final segment = entry.value;

      return SegmentCard(
        segment: segment,
        index: index,
        tripId: trip.id,
        departureId: trip.id,
        onActivityCheckIn: (activity) {
          _handleCheckIn(
            activity: activity,
            tripId: trip.id,
            departureId: trip.id,
            ref: ref,
            context: context,
          );
        },
      );
    }).toList();
  }

  void _handleCheckIn({
    required ActivityTrackingViews activity,
    required String tripId,
    required String departureId,
    required WidgetRef ref,
    required BuildContext context,
  }) {
    final params = {
      'activityId': activity.activityId,
      'tripId': tripId,
      'departureId': departureId,
      'activityPhase': 'completed',
    };

    // Call the provider to update activity status
    // ignore: avoid_print
    print('📍 Cập nhật trạng thái hoạt động: $params');

    ref
        .read(staffUpdateCheckingProvider(params).future)
        .then((_) {
          // Invalidate the provider to reload the tracking route data
          ref.invalidate(mytripTrackingRouteProvider(trip.id));

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Cập nhật thành công: ${activity.name}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        })
        .catchError((error) {
          // Extract error message
          String errorMessage = '❌ Lỗi cập nhật';
          if (error is Exception) {
            String errorStr = error.toString();
            // Remove 'Exception: ' prefix
            if (errorStr.startsWith('Exception: ')) {
              errorMessage = errorStr.replaceFirst('Exception: ', '❌ ');
            } else {
              errorMessage = '❌ $errorStr';
            }
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
          // ignore: avoid_print
          print('❌ Lỗi cập nhật: $error');
        });
  }
}
