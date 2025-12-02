class TravellerModel {
  final String userProfileId;
  final String? userName;
  final String fullName;
  final String status;
  final String userId;
  final String bio;
  final int tripCount;
  final int blogCount;
  final int proposalCount;
  final String imageUrl;
  final List<String>? tags;
  final DateTime? createdTime;
  TravellerModel({
    required this.userProfileId,
    this.userName,
    required this.fullName,
    required this.status,
    required this.userId,
    required this.bio,
    required this.tripCount,
    required this.blogCount,
    required this.proposalCount,
    required this.imageUrl,
    this.tags,
    this.createdTime,
  });
  factory TravellerModel.fromJson(Map<String, dynamic> json) {
    String userProfileId = json['userProfileId'] ?? '';
    String? userName = json['userName'];
    String fullName = json['fullName'] ?? '';
    String status = json['status'] ?? '';
    String userId = json['userId'] ?? '';
    String bio = json['bio'] ?? '';
    int tripCount = json['tripCount'] ?? 0;
    int blogCount = json['blogCount'] ?? 0;
    int proposalCount = json['proposalCount'] ?? 0;
    String imageUrl = json['image_url'] ?? '';
    List<String>? tags;
    if (json['tags'] != null) {
      try {
        tags = List<String>.from((json['tags'] as List).map((e) => e.toString()));
      } catch (_) {
        tags = null;
      }
    }
    DateTime? createdTime;
    try {
      final ct = json['created_time'] ?? json['createdTime'] ?? json['createdAt'];
      if (ct != null) {
        createdTime = DateTime.parse(ct.toString());
      } else {
        createdTime = null;
      }
    } catch (_) {
      createdTime = null;
    }
    return TravellerModel(
      userProfileId: userProfileId,
      userName: userName,
      fullName: fullName,
      status: status,
      userId: userId,
      bio: bio,
      tripCount: tripCount,
      blogCount: blogCount,
      proposalCount: proposalCount,
      imageUrl: imageUrl,
      tags: tags,
      createdTime: createdTime,
    );
  }

}



class BlogsTraveller {
  final String blogId;
  final String userId;
  final String fullName;
  final String userImage;
  final List<Tag> tags;
  final List<BlogImage> images;
  final String title;
  final String content;
  final DateTime publishDate;
  final DateTime createdAt;
  BlogsTraveller({
    required this.blogId,
    required this.userId,
    required this.fullName,
    required this.userImage,
    required this.tags,
    required this.images,
    required this.title,
    required this.content,
    required this.publishDate,
    required this.createdAt,
  });
  factory BlogsTraveller.fromJson(Map<String, dynamic> json) {
    String blogId = json['blogId'] ?? '';
    String userId = json['userId'] ?? '';
    String fullName = json['fullName'] ?? '';
    String userImage = json['userImage'] ?? '';
    List<Tag> tags = [];
    if (json['tags'] != null) {
      try {
        tags = (json['tags'] as List)
            .map((e) => Tag.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        tags = [];
      }
    }
    List<BlogImage> images = [];
    if (json['images'] != null) {
      try {
        images = (json['images'] as List)
            .map((e) => BlogImage.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        images = [];
      }
    }
    String title = json['title'] ?? '';
    String content = json['content'] ?? '';
    DateTime publishDate;
    try {
      final pd = json['publish_date'] ?? json['publishDate'];
      if (pd != null) {
        publishDate = DateTime.parse(pd.toString());
      } else {
        publishDate = DateTime.now();
      }
    } catch (_) {
      publishDate = DateTime.now();
    }
    DateTime createdAt;
    try {
      final ca = json['created_at'] ?? json['createdAt'];
      if (ca != null) {
        createdAt = DateTime.parse(ca.toString());
      } else {
        createdAt = DateTime.now();
      }
    } catch (_) {
      createdAt = DateTime.now();
    }
    return BlogsTraveller(
      blogId: blogId,
      userId: userId,
      fullName: fullName,
      userImage: userImage,
      tags: tags,
      images: images,
      title: title,
      content: content,
      publishDate: publishDate,
      createdAt: createdAt,
    );
  }
 
}

class Tag {
  final String id; 
  final String name;
  final String description;
  Tag({required this.id, required this.name, required this.description});
  factory Tag.fromJson(Map<String, dynamic> json) {
    String id = json['id'] ?? '';
    String name = json['name'] ?? '';
    String description = json['description'] ?? '';
    return Tag(id: id, name: name, description: description);
  }
}

class BlogImage {
  final String blogId;
  final String? tripId;
  final String imgUrl;
  final String id;
  final String createdBy;
  final String? lastUpdatedBy;
  final String? deletedBy;
  final DateTime createdTime;
  final DateTime lastUpdatedTime;
  final DateTime? deletedTime;
  BlogImage({
    required this.blogId,
    this.tripId,
    required this.imgUrl,
    required this.id,
    required this.createdBy,
    this.lastUpdatedBy,
    this.deletedBy,
    required this.createdTime,
    required this.lastUpdatedTime,
    this.deletedTime,
  });

  factory BlogImage.fromJson(Map<String, dynamic> json) {
    String blogId = json['blogId'] ?? '';
    String? tripId = json['tripId'];
    String imgUrl = json['img_url'] ?? '';
    String id = json['id'] ?? '';
    String createdBy = json['createdBy'] ?? '';
    String? lastUpdatedBy = json['lastUpdatedBy'];
    String? deletedBy = json['deletedBy'];
    DateTime createdTime;
    try {
      final ct = json['createdTime'] ?? json['created_time'];
      if (ct != null) {
        createdTime = DateTime.parse(ct.toString());
      } else {
        createdTime = DateTime.now();
      }
    } catch (_) {
      createdTime = DateTime.now();
    }
    DateTime lastUpdatedTime;
    try {
      final lut = json['lastUpdatedTime'] ?? json['last_updated_time'];
      if (lut != null) {
        lastUpdatedTime = DateTime.parse(lut.toString());
      } else {
        lastUpdatedTime = DateTime.now();
      }
    } catch (_) {
      lastUpdatedTime = DateTime.now();
    }
    DateTime? deletedTime;
    try {
      final dt = json['deletedTime'] ?? json['deleted_time'];
      if (dt != null) {
        deletedTime = DateTime.parse(dt.toString());
      } else {
        deletedTime = null;
      }
    } catch (_) {
      deletedTime = null;
    }
    return BlogImage(
      blogId: blogId,
      tripId: tripId,
      imgUrl: imgUrl,
      id: id,
      createdBy: createdBy,
      lastUpdatedBy: lastUpdatedBy,
      deletedBy: deletedBy,
      createdTime: createdTime,
      lastUpdatedTime: lastUpdatedTime,
      deletedTime: deletedTime,
    );
  }

}
