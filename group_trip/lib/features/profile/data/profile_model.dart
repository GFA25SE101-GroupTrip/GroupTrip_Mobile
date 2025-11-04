
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
    // Support multiple possible key names and tolerate nulls from backend.
    String _getString(dynamic v) => v == null ? '' : v.toString();

    final userProfileId = _getString(json['userProfileId'] ?? json['user_profile_id']);
    final userId = _getString(json['userId'] ?? json['user_id']);
    final bio = _getString(json['bio']);
    final imageUrl = _getString(json['imageUrl'] ?? json['image_url'] ?? json['avatar']);

    List<String>? tags;
    if (json['tags'] != null) {
      try {
        tags = List<String>.from((json['tags'] as List).map((e) => e.toString()));
      } catch (_) {
        tags = null;
      }
    }

    DateTime createdTime;
    try {
      final ct = json['created_time'] ?? json['createdTime'] ?? json['createdAt'];
      if (ct != null) {
        createdTime = DateTime.parse(ct.toString());
      } else {
        createdTime = DateTime.now();
      }
    } catch (_) {
      createdTime = DateTime.now();
    }

    return ProfileModel(
      userProfileId: userProfileId,
      userId: userId,
      bio: bio,
      imageUrl: imageUrl,
      tags: tags,
      createdTime: createdTime,
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

