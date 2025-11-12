class TripMember {
  final String? id;
  final String? name;

  TripMember({this.id, this.name});

  factory TripMember.fromJson(Map<String, dynamic> json) {
    return TripMember(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
