import 'package:group_trip/features/trip/data/trip_cost_range_model.dart';
import 'package:group_trip/features/trip/data/trip_member.dart';

class MyTripDeparture {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String departureStatus;
  final DateTime depositTime;
  final DateTime fullPayTime;
  final String timeRemainToDeposit;
  final String timeRemainToFullPay;
  final int amountToCharge;
  final int numberMemberIn;
  final List<TripCostRange> tripCostRanges;
  final List<TripMember> tripMembers;
  MyTripDeparture({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.departureStatus,
    required this.depositTime,
    required this.fullPayTime,
    required this.timeRemainToDeposit,
    required this.timeRemainToFullPay,
    required this.amountToCharge,
    required this.numberMemberIn,
    required this.tripCostRanges,
    required this.tripMembers,
  });

  factory MyTripDeparture.fromJson(Map<String, dynamic> json) {
  return MyTripDeparture(
    id: json['id']?.toString() ?? '',
    startDate: _parseDate(json['startDate']),
    endDate: _parseDate(json['endDate']),
    departureStatus: json['departureStatus']?.toString() ?? 'Unknown',
    depositTime: _parseDate(json['depositTime']),
    fullPayTime: _parseDate(json['fullPayTime']),
    timeRemainToDeposit: json['timeRemainToDeposit']?.toString() ?? 'Chưa xác định',
    timeRemainToFullPay: json['timeRemainToFullPay']?.toString() ?? 'Chưa xác định',
    amountToCharge: json['amountToCharge'] is num 
        ? json['amountToCharge'] as int 
        : 0,
    numberMemberIn: json['numberMemberIn'] is int 
        ? json['numberMemberIn'] as int 
        : 0,
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

// Helper function để parse DateTime an toàn
static DateTime _parseDate(dynamic value) {
  if (value == null) return DateTime.fromMillisecondsSinceEpoch(0);
  final parsed = DateTime.tryParse(value.toString());
  return parsed ?? DateTime.fromMillisecondsSinceEpoch(0);
}

  Map<String, dynamic> toJson() => {
        'id': id,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'departureStatus': departureStatus,
        'depositTime': depositTime.toIso8601String(),
        'fullPayTime': fullPayTime.toIso8601String(),
        'timeRemainToDeposit': timeRemainToDeposit,
        'timeRemainToFullPay': timeRemainToFullPay,
        'amountToCharge': amountToCharge,
        'numberMemberIn': numberMemberIn,
        'tripCostRanges':
            tripCostRanges.map((e) => e.toJson()).toList(),
        'tripMembers': tripMembers.map((e) => e.toJson()).toList(),
      };

}