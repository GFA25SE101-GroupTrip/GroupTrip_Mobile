import 'package:flutter/material.dart';
import 'package:group_trip/features/mytrip/data/mytriptracking_model.dart';

class SegmentCardWidget extends StatefulWidget {
  final SegmentTrackingViews segment;
  final int index;
  final ThemeData theme;
  final Function(List<PoiTrackingViews>) onBuildPOIs;

  const SegmentCardWidget({
    super.key,
    required this.segment,
    required this.index,
    required this.theme,
    required this.onBuildPOIs,
  });

  @override
  State<SegmentCardWidget> createState() => _SegmentCardWidgetState();
}

class _SegmentCardWidgetState extends State<SegmentCardWidget> {
  bool _isExpanded = false;

  Color _getPhaseColor(String phase) {
    final low = phase.toLowerCase();
    if (low.contains('upcomming'))
      return Colors.orange;
    if (low.contains('inprogress') || low.contains('progress'))
      return Colors.blue;
    if (low.contains('completed')) return Colors.green;
    return Colors.grey;
  }

  String _getPhaseLabel(String phase) {
    final low = phase.toLowerCase();
    if (low.contains('upcomming'))
      return 'Sắp diễn ra';
    if (low.contains('inprogress') || low.contains('progress'))
      return 'Đang diễn ra';
    if (low.contains('completed')) return 'Đã hoàn thành';
    return phase;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        collapsedBackgroundColor: Colors.blue.shade50,
        backgroundColor: Colors.blue.shade50,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade600.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${widget.index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
                    '${widget.segment.fromDestination} → ${widget.segment.toDestination}',
                    style: widget.theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getPhaseColor(widget.segment.segmentPhase)
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getPhaseLabel(widget.segment.segmentPhase),
                      style: widget.theme.textTheme.bodySmall?.copyWith(
                        color: _getPhaseColor(widget.segment.segmentPhase),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
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
                ...widget.onBuildPOIs(
                  widget.segment.poiTrackingViews ?? [],
                ).map(
                  (poi) => POICardWidget(
                    poi: poi,
                    theme: widget.theme,
                    onBuildActivities: (activities) => activities,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class POICardWidget extends StatelessWidget {
  final PoiTrackingViews poi;
  final ThemeData theme;
  final Function(List<ActivityTrackingViews>) onBuildActivities;

  const POICardWidget({
    super.key,
    required this.poi,
    required this.theme,
    required this.onBuildActivities,
  });

  Color _getPhaseColor(String phase) {
    final low = phase.toLowerCase();
    if (low.contains('upcomming'))
      return Colors.orange;
    if (low.contains('inprogress') || low.contains('progress'))
      return Colors.blue;
    if (low.contains('completed')) return Colors.green;
    return Colors.grey;
  }

  String _getPhaseLabel(String phase) {
    final low = phase.toLowerCase();
    if (low.contains('upcomming'))
      return 'Sắp diễn ra';
    if (low.contains('inprogress') || low.contains('progress'))
      return 'Đang diễn ra';
    if (low.contains('completed')) return 'Đã hoàn thành';
    return phase;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.green.shade200,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.green.shade600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      poi.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getPhaseColor(poi.poiPhase).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getPhaseLabel(poi.poiPhase),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _getPhaseColor(poi.poiPhase),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...(onBuildActivities(poi.activityTrackingViews ?? []))
            .map(
              (activity) => ActivityCardWidget(
                activity: activity,
                theme: theme,
                onCheckIn: () {},
              ),
            ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class ActivityCardWidget extends StatelessWidget {
  final ActivityTrackingViews activity;
  final ThemeData theme;
  final VoidCallback onCheckIn;

  const ActivityCardWidget({
    super.key,
    required this.activity,
    required this.theme,
    required this.onCheckIn,
  });

  Color _getPhaseColor(String phase) {
    final low = phase.toLowerCase();
    if (low.contains('upcomming'))
      return Colors.orange;
    if (low.contains('inprogress') || low.contains('progress'))
      return Colors.blue;
    if (low.contains('completed')) return Colors.green;
    return Colors.grey;
  }

  String _getPhaseLabel(String phase) {
    final low = phase.toLowerCase();
    if (low.contains('upcomming'))
      return 'Sắp diễn ra';
    if (low.contains('inprogress') || low.contains('progress'))
      return 'Đang diễn ra';
    if (low.contains('completed')) return 'Đã hoàn thành';
    return phase;
  }

  String _getActivityButtonText(String phase) {
    final low = phase.toLowerCase();
    if (low.contains('upcomming'))
      return 'Check-in';
    if (low.contains('inprogress') || low.contains('progress'))
      return 'Kết thúc';
    if (low.contains('completed')) return 'Đã hoàn thành';
    return 'Check-in';
  }

  Color _getActivityButtonColor(String phase) {
    final low = phase.toLowerCase();
    if (low.contains('upcomming'))
      return Colors.blue.shade600;
    if (low.contains('inprogress') || low.contains('progress'))
      return Colors.orange.shade600;
    if (low.contains('completed')) return Colors.green.shade600;
    return Colors.grey.shade600;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 4,
          color: _getActivityButtonColor(activity.activityPhase),
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getActivityButtonColor(activity.activityPhase)
                  .withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.directions_walk,
              size: 18,
              color: _getActivityButtonColor(activity.activityPhase),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getPhaseColor(activity.activityPhase)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _getPhaseLabel(activity.activityPhase),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: _getPhaseColor(activity.activityPhase),
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _getActivityButtonColor(activity.activityPhase),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: onCheckIn,
            icon: const Icon(
              Icons.check_circle,
              size: 14,
            ),
            label: Text(
              _getActivityButtonText(activity.activityPhase),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
