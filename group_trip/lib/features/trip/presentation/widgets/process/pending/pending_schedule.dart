import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/mytrip/providers/mytrip_provider.dart';

class PendingSchedule extends ConsumerWidget {
  final String? departureId;

  const PendingSchedule({super.key, this.departureId});

  Color _getStatusColor(String status) {
    final lowerStatus = status.toLowerCase();
    if (lowerStatus.contains('completed')) {
      return Colors.green;
    } else if (lowerStatus.contains('inprogress')) {
      return Colors.orange;
    } else if (lowerStatus.contains('upcomming')) {
      return Colors.blue;
    }
    return Colors.grey;
  }

  String _getVietnameseStatus(String status) {
    final lowerStatus = status.toLowerCase();
    if (lowerStatus.contains('completed')) {
      return 'Đã hoàn thành';
    } else if (lowerStatus.contains('inprogress')) {
      return 'Đang diễn ra';
    } else if (lowerStatus.contains('upcomming')) {
      return 'Sắp diễn ra';
    }
    return status;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (departureId == null || departureId!.isEmpty) {
      return Center(
        child: Text(
          'Không có dữ liệu lịch trình',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    final trackingRoute = ref.watch(mytripTrackingRouteProvider(departureId!));

    return trackingRoute.when(
      data: (route) {
        if (route.segmentTrackingViews.isEmpty) {
          return Center(
            child: Text(
              'Không có đoạn nào',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            route.segmentTrackingViews.length,
            (segmentIndex) {
              final segment = route.segmentTrackingViews[segmentIndex];
              final isLastSegment =
                  segmentIndex == route.segmentTrackingViews.length - 1;
              final statusColor = _getStatusColor(segment.segmentPhase);

              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: isLastSegment ? 0 : 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Đoạn ${segment.orderInTrip}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF8A8A8E),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${segment.fromDestination} → ${segment.toDestination}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _getVietnameseStatus(segment.segmentPhase),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (segment.poiTrackingViews.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Divider(height: 1, color: Color(0xFFF0F0F0)),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                segment.poiTrackingViews.length,
                                (poiIndex) {
                                  final poi =
                                      segment.poiTrackingViews[poiIndex];
                                  final isLastPoi = poiIndex ==
                                      segment.poiTrackingViews.length - 1;

                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: isLastPoi ? 0 : 16,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          poi.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        if (poi.activityTrackingViews
                                            .isNotEmpty) ...[
                                          const SizedBox(height: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: List.generate(
                                              poi.activityTrackingViews
                                                  .length,
                                              (actIndex) {
                                                final activity = poi
                                                    .activityTrackingViews[
                                                        actIndex];

                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    bottom: 6,
                                                  ),
                                                  child: Text(
                                                    activity.name,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors
                                                          .grey.shade700,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text(
          'Lỗi tải lịch trình: $error',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}