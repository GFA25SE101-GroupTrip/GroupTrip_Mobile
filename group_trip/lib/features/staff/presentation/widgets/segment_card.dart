import 'package:flutter/material.dart';
import 'package:group_trip/features/mytrip/data/mytriptracking_model.dart';
import 'package:group_trip/features/staff/presentation/widgets/trip_tracking_helpers.dart';
import 'package:group_trip/features/staff/presentation/widgets/poi_card.dart';
import 'package:intl/intl.dart';

class SegmentCard extends StatefulWidget {
  final SegmentTrackingViews segment;
  final int index;
  final String tripId;
  final String departureId;
  final Function(ActivityTrackingViews) onActivityCheckIn;

  const SegmentCard({
    super.key,
    required this.segment,
    required this.index,
    required this.tripId,
    required this.departureId,
    required this.onActivityCheckIn,
  });

  @override
  State<SegmentCard> createState() => _SegmentCardState();
}

class _SegmentCardState extends State<SegmentCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          color: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${widget.index + 1}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.segment.fromDestination} → ${widget.segment.toDestination}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: TrackingPhaseHelper.getPhaseColor(
                                widget.segment.segmentPhase,
                              ).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              TrackingPhaseHelper.getSegmentPhaseLabel(
                                widget.segment.segmentPhase,
                              ),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: TrackingPhaseHelper.getPhaseColor(
                                  widget.segment.segmentPhase,
                                ),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 13,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Bắt đầu: ${widget.segment.getFormattedStartDate()} | ${widget.segment.getFormattedStartTime()}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 13,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Kết thúc: ${widget.segment.getFormattedEndDate()} | ${widget.segment.getFormattedEndTime()}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
                    ...(widget.segment.poiTrackingViews ?? []).map((poi) {
                      return PoiCard(
                        poi: poi,
                        tripId: widget.tripId,
                        departureId: widget.departureId,
                        onActivityCheckIn: widget.onActivityCheckIn,
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
