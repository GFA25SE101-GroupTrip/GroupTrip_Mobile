class TripPOIActivity {
  final String id;
  final String segmentPOIId;
  final String name;
  final bool isAlternative;
  final String? replaceActivityId;
  final String? createdTime;

  TripPOIActivity({
    required this.id,
    required this.segmentPOIId,
    required this.name,
    required this.isAlternative,
    this.replaceActivityId,
    this.createdTime,
  });

  factory TripPOIActivity.fromJson(Map<String, dynamic> json) {
    return TripPOIActivity(
      id: json['id'] as String? ?? '',
      segmentPOIId: json['segmentPOIId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      isAlternative: (json['isAlternative'] as bool?) ?? false,
      replaceActivityId: json['replaceActivityId'] as String?,
      createdTime: json['createdTime'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'segmentPOIId': segmentPOIId,
      'name': name,
      'isAlternative': isAlternative,
      'replaceActivityId': replaceActivityId,
      'createdTime': createdTime,
    };
  }
}

