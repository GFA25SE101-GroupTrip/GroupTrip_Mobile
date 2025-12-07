import 'package:group_trip/features/trip/data/trip_POI.dart';

class TripSegment {
  final String id;
  final String fromDestination;
  final String? fromLongtitude;
  final String? fromLatitude;
  final String toDestination;
  final String? toLongtitude;
  final String? toLatitude;
  final int orderInTrip;
  final String transport;
  final List<SegmentPOIs> segmentPOIs;

  TripSegment({
    required this.id,
    required this.fromDestination,
    this.fromLongtitude,
    this.fromLatitude,
    required this.toDestination,
    this.toLongtitude,
    this.toLatitude,
    required this.orderInTrip,
    required this.transport,
    required this.segmentPOIs,
  });
  factory TripSegment.fromJson(Map<String, dynamic> json) {
    return TripSegment(
      id: json['id'] as String? ?? '',
      fromDestination: json['fromDestination'] as String? ?? '',
      fromLongtitude: json['fromLongtitude'] as String?,
      fromLatitude: json['fromLatitude'] as String?,
      toDestination: json['toDestination'] as String? ?? '',
      toLongtitude: json['toLongtitude'] as String?,
      toLatitude: json['toLatitude'] as String?,
      orderInTrip: (json['orderInTrip'] as num?)?.toInt() ?? 0,
      transport: json['transport'] as String? ?? '',
      segmentPOIs: (json['segmentPOIs'] as List<dynamic>?)
              ?.map((e) => SegmentPOIs.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromDestination': fromDestination,
      'fromLongtitude': fromLongtitude,
      'fromLatitude': fromLatitude,
      'toDestination': toDestination,
      'toLongtitude': toLongtitude,
      'toLatitude': toLatitude,
      'orderInTrip': orderInTrip,
      'transport': transport,
      'segmentPOIs': segmentPOIs.map((e) => e.toJson()).toList(),
    };
  }
}