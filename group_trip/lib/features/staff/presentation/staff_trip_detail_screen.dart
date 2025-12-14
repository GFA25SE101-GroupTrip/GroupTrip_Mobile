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
  late Map<String, bool> _expandedSegments;

  @override
  void initState() {
    super.initState();
    _expandedSegments = {};
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');

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
            _buildContent(context, theme, dateFormat, trackingRoute),
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
    DateFormat dateFormat,
    TrackingRoute? trackingRoute,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header với ảnh
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              child: widget.trip.tripImages.isNotEmpty
                  ? Image.network(
                      widget.trip.tripImages.first,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.photo, size: 80, color: Colors.grey),
                    )
                  : const Icon(Icons.photo, size: 80, color: Colors.grey),
            ),
            // Thông tin chuyến đi
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên chuyến
                  Text(
                    widget.trip.tripName,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Trạng thái
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(widget.trip.departureStatus)
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusLabel(widget.trip.departureStatus),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            _getStatusColor(widget.trip.departureStatus),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Ngày
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        '${dateFormat.format(DateTime.parse(widget.trip.startDate))} - ${dateFormat.format(DateTime.parse(widget.trip.endDate))}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Số người
                  Row(
                    children: [
                      Icon(Icons.people, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.trip.numberMemberIn} người',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Contact button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Liên hệ nhóm ${widget.trip.tripName}',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.phone, color: Colors.white),
                      label: const Text(
                        'Liên hệ nhóm',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Lộ trình
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
      final isExpanded = _expandedSegments[segment.segmentId] ?? false;

      return Column(
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              title: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${segment.fromDestination} → ${segment.toDestination}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getPhaseLabel(segment.segmentPhase),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: _getPhaseColor(segment.segmentPhase),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onExpansionChanged: (expanded) {
                setState(() {
                  _expandedSegments[segment.segmentId] = expanded;
                });
              },
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._buildPOIsList(
                        segment.poiTrackingViews ?? [],
                        theme,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  List<Widget> _buildPOIsList(
    List<PoiTrackingViews> pois,
    ThemeData theme,
  ) {
    return pois.map((poi) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  poi.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getPhaseLabel(poi.poiPhase),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _getPhaseColor(poi.poiPhase),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Activities
          ..._buildActivitiesList(poi.activityTrackingViews ?? [], theme),
          const SizedBox(height: 16),
        ],
      );
    }).toList();
  }

  List<Widget> _buildActivitiesList(
    List<ActivityTrackingViews> activities,
    ThemeData theme,
  ) {
    return activities.map((activity) {
      return Container(
        margin: const EdgeInsets.only(left: 16, bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getPhaseLabel(activity.activityPhase),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _getPhaseColor(activity.activityPhase),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _getActivityButtonColor(
                  activity.activityPhase,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
              ),
              onPressed: () {
                _handleCheckIn(activity.name);
              },
              icon: const Icon(
                Icons.check_circle,
                size: 16,
                color: Colors.white,
              ),
              label: Text(
                _getActivityButtonText(activity.activityPhase),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
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

  String _getStatusLabel(String status) {
    final low = status.toLowerCase();
    if (low.contains('ready') || low.contains('full')) return 'Đợi chốt nhóm';
    if (low.contains('inprogress')) return 'Đang diễn ra';
    if (low.contains('completed')) return 'Hoàn thành';
    if (low.contains('canceled')) return 'Đã hủy';
    if (low.contains('deposit')) return 'Chờ coc';
    if (low.contains('fullpayment')) return 'Chờ thanh toán';
    if (low.contains('pending')) return 'Chờ xác nhận';
    return status;
  }

  Color _getStatusColor(String status) {
    final low = status.toLowerCase();
    if (['ready', 'full', 'fullpayment', 'deposit', 'pending']
        .any((s) => low.contains(s))) {
      return Colors.orange;
    }
    if (low.contains('inprogress')) return Colors.green;
    if (low.contains('completed')) return Colors.grey;
    if (low.contains('canceled')) return Colors.red;
    return Colors.blueGrey;
  }

  String _getPhaseLabel(String phase) {
    final low = phase.toLowerCase();
    if (low.contains('upcomming')) return 'Sắp diễn ra';
    if (low.contains('inprogress') || low.contains('progress'))
      return 'Đang diễn ra';
    if (low.contains('completed')) return 'Đã hoàn thành';
    return phase;
  }

  Color _getPhaseColor(String phase) {
    final low = phase.toLowerCase();
    if (low.contains('upcomming')) return Colors.orange;
    if (low.contains('inprogress') || low.contains('progress'))
      return Colors.blue;
    if (low.contains('completed')) return Colors.green;
    return Colors.grey;
  }

  String _getActivityButtonText(String phase) {
    final low = phase.toLowerCase();
    if (low.contains('upcomming')) return 'Check-in';
    if (low.contains('inprogress') || low.contains('progress'))
      return 'Kết thúc';
    if (low.contains('completed')) return 'Đã hoàn thành';
    return 'Check-in';
  }

  Color _getActivityButtonColor(String phase) {
    final low = phase.toLowerCase();
    if (low.contains('upcomming')) return Colors.blue.shade600;
    if (low.contains('inprogress') || low.contains('progress'))
      return Colors.orange.shade600;
    if (low.contains('completed')) return Colors.green.shade600;
    return Colors.grey.shade600;
  }
}
