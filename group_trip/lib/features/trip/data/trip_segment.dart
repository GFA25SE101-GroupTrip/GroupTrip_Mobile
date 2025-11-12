class TripSegment {
  final String? id;
  final String? name;

  TripSegment({this.id, this.name});

  factory TripSegment.fromJson(Map<String, dynamic> json) {
    return TripSegment(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
