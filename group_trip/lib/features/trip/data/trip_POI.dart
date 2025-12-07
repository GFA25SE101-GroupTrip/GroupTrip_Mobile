import 'package:group_trip/features/trip/data/trip_poiactivity.dart';

class SegmentPOIs {
  final String id;
  final String segmentId;
  final String name;
  final String? poiLongtitude;
  final String? poiLatitude;
  final int orderInSegment;
  final List<TripPOIActivity> poiActivities;
  SegmentPOIs({
    required this.id,
    required this.segmentId,
    required this.name,
    this.poiLongtitude,
    this.poiLatitude,
    required this.orderInSegment,
    required this.poiActivities,
  });
  factory SegmentPOIs.fromJson(Map<String, dynamic> json) {
    int _toInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is double) return v.toInt();
      try {
        return int.parse(v.toString());
      } catch (_) {
        return 0;
      }
    }

    return SegmentPOIs(
      id: json['id'] as String? ?? '',
      segmentId: json['segmentId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      poiLongtitude: json['poiLongtitude'] as String?,
      poiLatitude: json['poiLatitude'] as String?,
      orderInSegment: _toInt(json['orderInSegment']),
      poiActivities: (json['poiActivities'] as List<dynamic>?)
              ?.map((e) => TripPOIActivity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'segmentId': segmentId,
      'name': name,
      'poiLongtitude': poiLongtitude,
      'poiLatitude': poiLatitude,
      'orderInSegment': orderInSegment,
      'poiActivities': poiActivities.map((e) => e.toJson()).toList(),
    };
  }
 
}