import 'package:flutter/material.dart';
import 'package:group_trip/features/trip/data/trip_segment.dart';

class ScheduleSection extends StatelessWidget {
  final List<TripSegment> trip;
  const ScheduleSection({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> _buildScheduleFromTrip(List<TripSegment> segments) {
      final out = <Map<String, dynamic>>[];

      if (segments.isNotEmpty) {
        int day = 1;
        for (final seg in segments) {
          String title = 'Đến ${seg.toDestination}';
          if (seg.transport.isNotEmpty) {
            title += ' bằng ${seg.transport}';
          }

          final pois = <Map<String, dynamic>>[];
          if (seg.segmentPOIs.isNotEmpty) {
            for (final poi in seg.segmentPOIs) {
              final activities = <String>[];
              if (poi.poiActivities.isNotEmpty) {
                for (final act in poi.poiActivities) {
                  if (act.isAlternative == false) {
                    activities.add(act.name);
                  }
                }
              }

              pois.add({
                'name': poi.name,
                'activities': activities,
              });
            }
          }

          out.add({
            'day': day++,
            'title': title,
            'pois': pois,
          });
        }
      }

      return out.isNotEmpty
          ? out
          : [
              {
                'day': 1,
                'title': 'Lịch trình đang cập nhật',
                'pois': [
                  {'name': 'Thông tin sẽ được bổ sung sớm.', 'activities': []}
                ]
              }
            ];
    }

    final schedule = _buildScheduleFromTrip(trip);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lịch trình chi tiết',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C1C1E),
          ),
        ),
        const SizedBox(height: 16),

        ...schedule.map((day) {
          final pois = day['pois'] as List<Map<String, dynamic>>;

          return Container(
            key: ValueKey(day['day']),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header ngày
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: const Color(0xFF007AFF),
                        child: Text(
                          '${day['day']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Ngày ${day['day']}: ${day['title']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1C1C1E),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  const Divider(height: 1, thickness: 0.8),

                  // Danh sách POI
                  ...pois.map((poi) {
                    final activities = (poi['activities'] as List).cast<String>();
                    return Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 18,
                                color: Color(0xFF007AFF),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  poi['name'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 28, top: 6),
                            child: activities.isNotEmpty
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: activities.map((act) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.check_circle,
                                              size: 14,
                                              color: Color(0xFF34C759),
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                act,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF3A3A3C),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  )
                                : Row(
                                    children: [
                                      const Icon(
                                        Icons.info_outline,
                                        size: 14,
                                        color: Color(0xFF8E8E93),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'Không có hoạt động nào',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF8E8E93),
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
