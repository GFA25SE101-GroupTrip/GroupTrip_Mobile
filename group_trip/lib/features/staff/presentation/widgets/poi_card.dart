import 'package:flutter/material.dart';
import 'package:group_trip/features/mytrip/data/mytriptracking_model.dart';
import 'package:group_trip/features/staff/presentation/widgets/trip_tracking_helpers.dart';
import 'package:group_trip/features/staff/presentation/widgets/activity_card.dart';
import 'package:intl/intl.dart';

class PoiCard extends StatelessWidget {
  final PoiTrackingViews poi;
  final String tripId;
  final String departureId;
  final Function(ActivityTrackingViews) onActivityCheckIn;

  const PoiCard({
    super.key,
    required this.poi,
    required this.tripId,
    required this.departureId,
    required this.onActivityCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.blue.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue.shade200.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                poi.name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: TrackingPhaseHelper.getPhaseColor(
                    poi.poiPhase,
                  ).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  TrackingPhaseHelper.getPhaseLabel(poi.poiPhase),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: TrackingPhaseHelper.getPhaseColor(poi.poiPhase),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 13,
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Bắt đầu: ${poi.getFormattedStartDate()} | ${poi.getFormattedStartTime()}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade700,
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
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Kết thúc: ${poi.getFormattedEndDate()} | ${poi.getFormattedEndTime()}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade700,
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
        const SizedBox(height: 12),
        // Activities
        ...(poi.activityTrackingViews ?? []).map((activity) {
          return ActivityCard(
            activity: activity,
            tripId: tripId,
            departureId: departureId,
            onCheckIn: () => onActivityCheckIn(activity),
          );
        }).toList(),
        const SizedBox(height: 16),
      ],
    );
  }
}
