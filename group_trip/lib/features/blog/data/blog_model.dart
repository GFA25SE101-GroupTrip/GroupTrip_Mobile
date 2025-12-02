import 'package:group_trip/features/blog/data/tag_model.dart';

class BlogCreateModel {
  final String title;
  final String content;
  final String publish_date;
  final List<BlogTag> tags;

  BlogCreateModel({
    required this.title,
    required this.content,
    required this.publish_date,
    required this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'publish_date': publish_date,
      'tags': tags.toList().map((tag) => tag.toJson()).toList(),
    };
  }
}

class BlogTag {
  final String blogId;
  final String tagId; 

  BlogTag({required this.blogId, required this.tagId});

  Map<String, dynamic> toJson() {
    return {
      'blogId': blogId,
      'tagId': tagId,
    };
  }
}


class BlogModel {
  final String blogId;
  final String userId;
  final String fullName;
  final String userImage;
  final String? coverImage;
  final String title;
  final String content;
  final List<TagModel> tags;
  final String publish_date;
  final String created_at;

  BlogModel({
    required this.blogId,
    required this.userId,
    required this.fullName,
    required this.userImage,
    this.coverImage,
    required this.title,
    required this.content,
    required this.tags,
    required this.publish_date,
    required this.created_at,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      blogId: json['blogId'],
      userId: json['userId'],
      fullName: json['fullName'],
      userImage: json['userImage'],
      coverImage: json['coverImage'],
      title: json['title'],
      content: json['content'],
      tags: (json['tags'] as List)
          .map((tag) => TagModel.fromJson(tag))
          .toList(),
      publish_date: json['publish_date'],
      created_at: json['created_at'],
    );
  }
}
     



