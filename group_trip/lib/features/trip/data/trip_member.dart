class TripMember {
  final String? memberId;
  final String? imageUrl;

  TripMember({this.memberId, this.imageUrl});

  factory TripMember.fromJson(Map<String, dynamic> json) {
    return TripMember(
      memberId: json['memberId'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'imageUrl': imageUrl,
      };
}
