import 'package:group_trip/features/chat/data/chat_member.dart';
import 'package:group_trip/features/chat/data/chat_message.dart';

class ChatModel {
  final String id; 
  final String title;
  final bool isGroup;
  final String chatImg;
  final int unreadCount;
  final String? lastMessage;
  final List<ChatMember>? chatMembers;
  final List<ChatMessage> messages;
  ChatModel({
    required this.id,
    required this.title,
    required this.isGroup,
    required this.chatImg,
    required this.unreadCount,
    this.lastMessage,
    this.chatMembers,
    required this.messages,
  });
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    String id = '';
    try {
      id = json['id']?.toString() ?? '';
    } catch (_) {
      id = '';
    }

    String title = '';
    try {
      title = json['title']?.toString() ?? '';
    } catch (_) {
      title = '';
    }

    bool isGroup = false;
    try {
      isGroup = json['isGroup'] == true;
    } catch (_) {
      isGroup = false;
    }

    String chatImg = '';
    try {
      chatImg = json['chatImg']?.toString() ?? '';
    } catch (_) {
      chatImg = '';
    }

    int unreadCount = 0;
    try {
      if (json['unreadCount'] is int) {
        unreadCount = json['unreadCount'];
      } else if (json['unreadCount'] is String) {
        unreadCount = int.tryParse(json['unreadCount']) ?? 0;
      }
    } catch (_) {
      unreadCount = 0;
    }

    String? lastMessage;
    try {
      lastMessage = json['lastMessage']?.toString();
    } catch (_) {
      lastMessage = null;
    }

    List<dynamic>? chatMembers;
    try {
      if (json['chatMembers'] is List) chatMembers = List<dynamic>.from(json['chatMembers']);
    } catch (_) {
      chatMembers = null;
    }

    List<dynamic> messages = [];
    try {
      if (json['messages'] is List) {
        messages = List<dynamic>.from(json['messages']);
      }
    } catch (_) {
      messages = [];
    }

    return ChatModel(
      id: id,
      title: title,
      isGroup: isGroup,
      chatImg: chatImg,
      unreadCount: unreadCount,
      lastMessage: lastMessage,
      chatMembers: chatMembers?.map((e) => ChatMember.fromJson(Map<String, dynamic>.from(e))).toList(),
      messages: messages.map((e) => ChatMessage.fromJson(Map<String, dynamic>.from(e))).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isGroup': isGroup,
      'chatImg': chatImg,
      'unreadCount': unreadCount,
      'lastMessage': lastMessage,
      'chatMembers': chatMembers,
      'messages': messages,
    };
  }

  ChatModel copyWith({
    String? id,
    String? title,
    bool? isGroup,
    String? chatImg,
    int? unreadCount,
    String? lastMessage,
    List<ChatMember>? chatMembers,
    List<ChatMessage>? messages,
  }) {
    return ChatModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isGroup: isGroup ?? this.isGroup,
      chatImg: chatImg ?? this.chatImg,
      unreadCount: unreadCount ?? this.unreadCount,
      lastMessage: lastMessage ?? this.lastMessage,
      chatMembers: chatMembers ?? this.chatMembers,
      messages: messages ?? this.messages,
    );
  }
}
