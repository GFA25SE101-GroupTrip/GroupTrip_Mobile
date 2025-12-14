import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/mytrip/data/mytriptracking_model.dart';
import 'package:intl/intl.dart';
import 'package:group_trip/features/staff/data/staff_data.dart';
import 'package:group_trip/features/mytrip/providers/mytrip_provider.dart';
import 'package:group_trip/features/staff/presentation/widgets/trip_header_widgets.dart';
import 'package:group_trip/features/staff/presentation/widgets/tracking_widgets.dart';

class StaffTripDetailScreen extends ConsumerStatefulWidget {
  final DepartureStaff trip;

  const StaffTripDetailScreen({
    super.key,
    required this.trip,
  });

  @override
  ConsumerState<StaffTripDetailScreen> createState() =>
      _StaffTripDetailScreenState();
}

class _StaffTripDetailScreenState extends ConsumerState<StaffTripDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Fetch tracking route data using Riverpod provider
    final trackingRouteAsync =
        ref.watch(mytripTrackingRouteProvider(widget.trip.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết chuyến đi'),
        centerTitle: true,
        elevation: 1,
      ),
      body: trackingRouteAsync.when(
        data: (trackingRoute) =>
            _buildContent(context, theme, trackingRoute),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Lỗi: $error'),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    TrackingRoute? trackingRoute,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with image
          TripHeaderWidget(trip: widget.trip),

          // Trip info
          TripInfoWidget(trip: widget.trip, theme: theme),

          // Contact button
          ContactButtonWidget(tripName: widget.trip.tripName),

          // Tracking route
          if (trackingRoute != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lộ trình chuyến đi',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._buildSegmentsList(
                    trackingRoute.segmentTrackingViews ?? [],
                    theme,
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
    ThemeData theme,
  ) {
    return segments.asMap().entries.map((entry) {
      final index = entry.key;
      final segment = entry.value;

      return SegmentCardWidget(
        segment: segment,
        index: index,
        theme: theme,
        onBuildPOIs: (pois) => _buildPOIsList(pois, theme),
      );
    }).toList();
  }

  List<Widget> _buildPOIsList(
    List<PoiTrackingViews> pois,
    ThemeData theme,
  ) {
    return pois.map((poi) {
      return POICardWidget(
        poi: poi,
        theme: theme,
        onBuildActivities: (activities) => _buildActivitiesList(activities, theme),
      );
    }).toList();
  }

  List<Widget> _buildActivitiesList(
    List<ActivityTrackingViews> activities,
    ThemeData theme,
  ) {
    return activities
        .map(
          (activity) => ActivityCardWidget(
            activity: activity,
            theme: theme,
            onCheckIn: () => _handleCheckIn(activity.name),
          ),
        )
        .toList();
  }

  void _handleCheckIn(String activityName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Check-in: $activityName'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
