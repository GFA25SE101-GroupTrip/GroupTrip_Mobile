import 'package:group_trip/features/trip/data/trip_insurance.dart';

class InsuranceUser {
  final String tripId;
  final String tripName;
  final String departureId;
  final String startDate;
  final TripInsurance? insurance;

  InsuranceUser({
    required this.tripId,
    required this.tripName,
    required this.departureId,
    required this.startDate,
    this.insurance,
  });
  factory InsuranceUser.fromJson(Map<String, dynamic> json) {
    return InsuranceUser(
      tripId: json['tripId'] as String,
      tripName: json['tripName'] as String,
      departureId: json['departureId'] as String,
      startDate: json['startDate'] as String,
      insurance: json['insurance'] != null
          ? TripInsurance.fromJson(json['insurance'] as Map<String, dynamic>)
          : null,
    );
  }
  Map<String, dynamic> toJson() => {
        'tripId': tripId,
        'tripName': tripName,
        'departureId': departureId,
        'startDate': startDate,
        'insurance': insurance?.toJson(),
      };
    
}