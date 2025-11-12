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
    return TripDeparture(
      id: json['id'],
      tripId: json['tripId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      departureStatus: json['departureStatus'],
      depositTime: DateTime.parse(json['depositTime']),
      fullPayTime: DateTime.parse(json['fullPayTime']),
      numberMemberIn: json['numberMemberIn'] ?? 0,
      tripCostRanges: (json['tripCostRanges'] as List<dynamic>?)
              ?.map((e) => TripCostRange.fromJson(e))
              .toList() ??
          [],
      tripMembers: (json['tripMembers'] as List<dynamic>?)
              ?.map((e) => TripMember.fromJson(e))
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
