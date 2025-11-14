class ChatMessage {
  final String senderId;
  final String senderName;
  final String content;
  final String attachmentUrl;
  final String messageType;
  final List<String> userRead;
  ChatMessage({
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.attachmentUrl,
    required this.messageType,
    required this.userRead,
  });
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      content: json['content'] as String,
      attachmentUrl: json['attachmentUrl'] as String,
      messageType: json['messageType'] as String,
      userRead: List<String>.from(json['userRead'] as List<dynamic>),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'content': content,
      'attachmentUrl': attachmentUrl,
      'messageType': messageType,
      'userRead': userRead,
    };
  }

}