class TripTagRelation {
  final String id;
  final String name;

  TripTagRelation({
    required this.id,
    required this.name,
  });

  factory TripTagRelation.fromJson(Map<String, dynamic> json) {
    return TripTagRelation(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
