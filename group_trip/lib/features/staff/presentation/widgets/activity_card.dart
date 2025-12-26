import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/mytrip/data/mytriptracking_model.dart';
import 'package:group_trip/features/staff/presentation/widgets/trip_tracking_helpers.dart';

class ActivityCard extends ConsumerWidget {
  final ActivityTrackingViews activity;
  final String tripId;
  final String departureId;
  final VoidCallback onCheckIn;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.tripId,
    required this.departureId,
    required this.onCheckIn,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(left: 16, bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade50,
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
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${activity.duration ?? 0} phút',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  TrackingPhaseHelper.getPhaseLabel(activity.activityPhase),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: TrackingPhaseHelper.getPhaseColor(
                      activity.activityPhase,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: TrackingPhaseHelper.getActivityButtonColor(
                activity.activityPhase,
              ),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            onPressed: onCheckIn,
            icon: const Icon(Icons.check_circle, size: 16),
            label: Text(
              TrackingPhaseHelper.getActivityButtonText(activity.activityPhase),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
