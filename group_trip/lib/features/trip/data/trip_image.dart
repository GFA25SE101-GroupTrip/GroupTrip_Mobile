class TripImage {
  final String id;
  final String imgUrl;

  TripImage({
    required this.id,
    required this.imgUrl,
  });

  factory TripImage.fromJson(Map<String, dynamic> json) {
    return TripImage(
      id: json['id'],
      imgUrl: json['img_url'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'img_url': imgUrl,
      };
}
