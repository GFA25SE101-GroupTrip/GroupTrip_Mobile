class TripFeedback {
  final String userId;
  final String? userName;
  final String? userImg;
  final String comment;
  final int rating;
  final List<ImageData> images;
  TripFeedback({
    required this.userId,
    this.userName,
    this.userImg,
    required this.comment,
    required this.rating,
    required this.images,
  });

  factory TripFeedback.fromJson(Map<String, dynamic> json) {
    String _stringify(dynamic v) {
      if (v == null) return '';
      if (v is String) return v;
      if (v is num) return v.toString();
      if (v is Map) {
        final keys = ['userName', 'user_name', 'name', 'username', 'fullName', 'full_name', 'user'];
        for (final k in keys) {
          if (v.containsKey(k) && v[k] != null) return v[k].toString();
        }
        final imageKeys = ['img_url', 'img', 'url', 'image', 'user_Img'];
        for (final k in imageKeys) {
          if (v.containsKey(k) && v[k] != null) return v[k].toString();
        }
        return v.values.isNotEmpty ? v.values.first.toString() : '';
      }
      return v.toString();
    }

    int _toInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is double) return v.toInt();
      try {
        return int.parse(v.toString());
      } catch (_) {
        return 0;
      }
    }

    final userId = _stringify(json['userId']);
    final userName = _stringify(json['userName'] ?? json['user_name'] ?? json['name'] ?? json['username']);
    final userImg = _stringify(json['userImg'] ?? json['user_Img'] ?? json['avatar'] ?? json['user_image']);
    final comment = _stringify(json['comment'] ?? json['content']);
    final rating = _toInt(json['rating']);

    final rawImages = json['images'] ?? [];
    final images = <ImageData>[];
    if (rawImages is List) {
      for (final e in rawImages) {
        if (e == null) continue;
        if (e is String) {
          images.add(ImageData(id: '', img_url: e));
        } else if (e is Map) {
          images.add(ImageData.fromJson(Map<String, dynamic>.from(e)));
        } else {
          images.add(ImageData(id: '', img_url: e.toString()));
        }
      }
    }

    return TripFeedback(
      userId: userId,
      userName: userName.isNotEmpty ? userName : null,
      userImg: userImg.isNotEmpty ? userImg : null,
      comment: comment,
      rating: rating,
      images: images,
    );
  }  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'userImg': userImg,
        'comment': comment,
        'rating': rating,
        'images': images.map((e) => e.toJson()).toList(),
      };
  

}

class ImageData {
  final String id;
  final String img_url;
  ImageData({
    required this.id,
    required this.img_url,
  });
  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      id: json['id'] as String,
      img_url: json['img_url'] as String,
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'img_url': img_url,
      };
  
}