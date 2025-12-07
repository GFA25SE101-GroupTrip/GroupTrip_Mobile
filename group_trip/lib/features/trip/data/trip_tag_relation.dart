class TripTagRelation {
  final String id;
  final String name;

  TripTagRelation({
    required this.id,
    required this.name,
  });

  factory TripTagRelation.fromJson(Map<String, dynamic> json) {
    return TripTagRelation(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
