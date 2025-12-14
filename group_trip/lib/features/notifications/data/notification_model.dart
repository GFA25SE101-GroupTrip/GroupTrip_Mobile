import 'dart:convert';

class NotificationModel {
  final String title;
  final String content;
  final bool isRead;
  final DateTime createAt;
  final String objectId;
  final String objectType;
  final String notificationType;
  final Map<String, dynamic> metadata;
  NotificationModel({
    required this.title,
    required this.content,
    required this.isRead,
    required this.createAt,
    required this.objectId,
    required this.objectType,
    required this.notificationType,
    required this.metadata,
  });
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'] as String,
      content: json['content'] as String,
      isRead: json['isRead'] as bool,
      createAt: DateTime.parse(json['createAt'] as String),
      objectId: json['objectId'] as String,
      objectType: json['objectType'] as String,
      notificationType: json['notificationType'] as String,
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(
              jsonDecode(json['metadata'] as String) as Map)
          : {},
    );
  }
}
