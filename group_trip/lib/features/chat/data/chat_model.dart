class ChatModel {
  final String id; 
  final String title;
  final bool isGroup;
  final String chatImg;
  final int unreadCount;
  final List<dynamic>? chatMembers;
  final List<dynamic> messages;
  ChatModel({
    required this.id,
    required this.title,
    required this.isGroup,
    required this.chatImg,
    required this.unreadCount,
    this.chatMembers,
    required this.messages,
  });
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String,
      title: json['title'] as String,
      isGroup: json['isGroup'] as bool,
      chatImg: json['chatImg'] as String,
      unreadCount: json['unreadCount'] as int,
      chatMembers: json['chatMembers'] as List<dynamic>?,
      messages: json['messages'] as List<dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isGroup': isGroup,
      'chatImg': chatImg,
      'unreadCount': unreadCount,
      'chatMembers': chatMembers,
      'messages': messages,
    };
  }
}
