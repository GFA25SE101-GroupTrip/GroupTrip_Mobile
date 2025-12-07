import 'package:group_trip/features/trip/data/trip_cost_range_model.dart';
import 'package:group_trip/features/trip/data/trip_member.dart';

class TripDeparture {
  final String id;
  final String tripId;
  final DateTime startDate;
  final DateTime endDate;
  final String departureStatus;
  final DateTime depositTime;
  final DateTime fullPayTime;
  final int numberMemberIn;
  final List<TripCostRange> tripCostRanges;
  final List<TripMember> tripMembers;

  TripDeparture({
    required this.id,
    required this.tripId,
    required this.startDate,
    required this.endDate,
    required this.departureStatus,
    required this.depositTime,
    required this.fullPayTime,
    required this.numberMemberIn,
    required this.tripCostRanges,
    required this.tripMembers,
  });

  factory TripDeparture.fromJson(Map<String, dynamic> json) {
    int _parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is double) return v.toInt();
      try {
        return int.parse(v.toString());
      } catch (_) {
        return 0;
      }
    }
    DateTime _parseDate(dynamic v) {
      if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
      try {
        if (v is String) return DateTime.parse(v);
        if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
        if (v is double) return DateTime.fromMillisecondsSinceEpoch(v.toInt());
        if (v is Map) {
          // try common keys
          final candidates = ['date', 'startDate', 'value', 'iso', 'time'];
          for (final k in candidates) {
            if (v.containsKey(k) && v[k] != null) {
              final val = v[k];
              if (val is String) return DateTime.parse(val);
              if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
            }
          }
        }
        return DateTime.parse(v.toString());
      } catch (_) {
        return DateTime.fromMillisecondsSinceEpoch(0);
      }
    }

    return TripDeparture(
      id: json['id'] as String? ?? '',
      tripId: json['tripId'] as String? ?? '',
      startDate: _parseDate(json['startDate']),
      endDate: _parseDate(json['endDate']),
      departureStatus: json['departureStatus'] as String? ?? '',
      depositTime: _parseDate(json['depositTime']),
      fullPayTime: _parseDate(json['fullPayTime']),
      numberMemberIn: _parseInt(json['numberMemberIn']),
      tripCostRanges: (json['tripCostRanges'] as List<dynamic>?)
              ?.map((e) => TripCostRange.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      tripMembers: (json['tripMembers'] as List<dynamic>?)
              ?.map((e) => TripMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tripId': tripId,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'departureStatus': departureStatus,
        'depositTime': depositTime.toIso8601String(),
        'fullPayTime': fullPayTime.toIso8601String(),
        'numberMemberIn': numberMemberIn,
        'tripCostRanges': tripCostRanges.map((e) => e.toJson()).toList(),
        'tripMembers': tripMembers.map((e) => e.toJson()).toList(),
      };
}
