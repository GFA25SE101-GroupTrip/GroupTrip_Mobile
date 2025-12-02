class TripImage {
  final String id;
  final String imgUrl;

  TripImage({
    required this.id,
    required this.imgUrl,
  });

  factory TripImage.fromJson(Map<String, dynamic> json) {
    String _imgFrom(dynamic v) {
      if (v == null) return '';
      if (v is String) return v;
      if (v is Map) {
        final keys = ['url', 'img', 'path', 'img_url', 'file'];
        for (final k in keys) {
          if (v.containsKey(k) && v[k] != null) return v[k].toString();
        }
        return v.values.first.toString();
      }
      return v.toString();
    }

    return TripImage(
      id: json['id']?.toString() ?? '',
      imgUrl: _imgFrom(json['img_url'] ?? json['url'] ?? json['image']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'img_url': imgUrl,
      };
}
