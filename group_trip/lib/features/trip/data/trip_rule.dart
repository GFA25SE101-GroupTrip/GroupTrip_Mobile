class TripRule {
  final String id;
  final int minAge;
  final int maxAge;
  final String experienceLevel;
  final String specialNote;

  TripRule({
    required this.id,
    required this.minAge,
    required this.maxAge,
    required this.experienceLevel,
    required this.specialNote,
  });

  factory TripRule.fromJson(Map<String, dynamic> json) {
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

    return TripRule(
      id: json['id'] as String? ?? '',
      minAge: _parseInt(json['minAge']),
      maxAge: _parseInt(json['maxAge']),
      experienceLevel: json['experienceLevel'] as String? ?? '',
      specialNote: json['specialNote'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "minAge": minAge,
        "maxAge": maxAge,
        "experienceLevel": experienceLevel,
        "specialNote": specialNote,
      };
}