class TripPOIActivity {
  final String id;
  final String segmentPOIId;
  final String name;
  final bool isAlternative;
  final String? replaceActivityId;

  TripPOIActivity({
    required this.id,
    required this.segmentPOIId,
    required this.name,
    required this.isAlternative,
    this.replaceActivityId,
  });

  factory TripPOIActivity.fromJson(Map<String, dynamic> json) {
    return TripPOIActivity(
      id: json['id'],
      segmentPOIId: json['segmentPOIId'],
      name: json['name'],
      isAlternative: json['isAlternative'],
      replaceActivityId: json['replaceActivityId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'segmentPOIId': segmentPOIId,
      'name': name,
      'isAlternative': isAlternative,
      'replaceActivityId': replaceActivityId,
    };
  }
}

