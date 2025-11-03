
class ProfileModel {
  final String userProfileId;
  final String userId;
  final String bio;
  final String imageUrl;
  final List<String>? tags;
  final DateTime createdTime;
  ProfileModel({
    required this.userProfileId,
    required this.userId,
    required this.bio,
    required this.imageUrl,
    this.tags,
    required this.createdTime,
  });
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userProfileId: json['userProfileId'] as String,
      userId: json['userId'] as String,
      bio: json['bio'] as String,
      imageUrl: json['image_url'] as String,
      tags: json['tags'] != null
          ? List<String>.from(json['tags'] as List<dynamic>)
          : null,
      createdTime: DateTime.parse(json['created_time'] as String),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userProfileId': userProfileId,
      'userId': userId,
      'bio': bio,
      'image_url': imageUrl,
      'tags': tags,
      'created_time': createdTime.toIso8601String(),
    };
  }
}