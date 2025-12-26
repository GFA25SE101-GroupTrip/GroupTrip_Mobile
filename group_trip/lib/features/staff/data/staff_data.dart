class DepartureStaff {
  final String id;
  final String tripId; 
  final String tripName;
  final String startDate;
  final String endDate;
  final String departureStatus;
  final String depositTime;
  final String fullPayTime;
  final int numberMemberIn;
  final List<dynamic> tripCostRanges;
  final List<dynamic> tripMembers;
  final List<String> tripImages;
  DepartureStaff({
    required this.id,
    required this.tripId,
    required this.tripName,
    required this.startDate,
    required this.endDate,
    required this.departureStatus,
    required this.depositTime,
    required this.fullPayTime,
    required this.numberMemberIn,
    required this.tripCostRanges,
    required this.tripMembers,
    this.tripImages = const [],
  });
  factory DepartureStaff.fromJson(Map<String, dynamic> json) {
    return DepartureStaff(
      id: json['id'],
      tripId: json['tripId'],
      tripName: json['tripName'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      departureStatus: json['departureStatus'],
      depositTime: json['depositTime'],
      fullPayTime: json['fullPayTime'],
      numberMemberIn: json['numberMemberIn'],
      tripCostRanges: json['tripCostRanges'] ?? [],
      tripMembers: json['tripMembers'] ?? [],
      tripImages: List<String>.from(json['tripImages'] ?? []),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'tripName': tripName,
      'startDate': startDate,
      'endDate': endDate,
      'departureStatus': departureStatus,
      'depositTime': depositTime,
      'fullPayTime': fullPayTime,
      'numberMemberIn': numberMemberIn,
      'tripCostRanges': tripCostRanges,
      'tripMembers': tripMembers,
      'tripImages': tripImages,
    };
  }
}
 

