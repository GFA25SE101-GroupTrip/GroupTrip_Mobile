import 'package:group_trip/features/trip/data/trip_cost_range_model.dart';
import 'package:group_trip/features/trip/data/trip_member.dart';

class MyTripModel {
  final String tripId;
  final String name;
  final String tripStatus;
  final String img;
  final String departureId;
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
  MyTripModel({
    required this.tripId,
    required this.name,
    required this.tripStatus,
    required this.img,
    required this.departureId,
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


  factory MyTripModel.fromJson(Map<String, dynamic> json) {
    return MyTripModel(
      tripId: json['tripId'],
      name: json['name'],
      tripStatus: json['tripStatus'],
      img: json['img'],
      departureId: json['departureId'],
      startDate: (() {
        try {
          final s = json['startDate'];
          if (s == null) return DateTime.fromMillisecondsSinceEpoch(0);
          final parsed = DateTime.tryParse(s.toString());
          return parsed ?? DateTime.fromMillisecondsSinceEpoch(0);
        } catch (_) {
          return DateTime.fromMillisecondsSinceEpoch(0);
        }
      })(),
      endDate: (() {
        try {
          final s = json['endDate'];
          if (s == null) return DateTime.fromMillisecondsSinceEpoch(0);
          final parsed = DateTime.tryParse(s.toString());
          return parsed ?? DateTime.fromMillisecondsSinceEpoch(0);
        } catch (_) {
          return DateTime.fromMillisecondsSinceEpoch(0);
        }
      })(),
      departureStatus: json['departureStatus'],
      depositTime: (() {
        try {
          final s = json['depositTime'];
          if (s == null) return DateTime.fromMillisecondsSinceEpoch(0);
          final parsed = DateTime.tryParse(s.toString());
          return parsed ?? DateTime.fromMillisecondsSinceEpoch(0);
        } catch (_) {
          return DateTime.fromMillisecondsSinceEpoch(0);
        }
      })(),
      fullPayTime: (() {
        try {
          final s = json['fullPayTime'];
          if (s == null) return DateTime.fromMillisecondsSinceEpoch(0);
          final parsed = DateTime.tryParse(s.toString());
          return parsed ?? DateTime.fromMillisecondsSinceEpoch(0);
        } catch (_) {
          return DateTime.fromMillisecondsSinceEpoch(0);
        }
      })(),
      timeRemainToDeposit: json['timeRemainToDeposit'],
      timeRemainToFullPay: json['timeRemainToFullPay'],
      amountToCharge: json['amountToCharge'],
      numberMemberIn: json['numberMemberIn'],
      tripCostRanges: (json['tripCostRanges'] as List<dynamic>)
          .map((e) => TripCostRange.fromJson(e))
          .toList(),
      tripMembers: (json['tripMembers'] as List<dynamic>)
          .map((e) => TripMember.fromJson(e))
          .toList(),
    );  

  }
  Map<String, dynamic> toJson() => {
        'tripId': tripId,
        'name': name,
        'tripStatus': tripStatus,
        'img': img,
        'departureId': departureId,
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
