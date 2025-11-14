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
    return TripRule(
      id: json['id'],
      minAge: json['minAge'],
      maxAge: json['maxAge'],
      experienceLevel: json['experienceLevel'],
      specialNote: json['specialNote'],
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