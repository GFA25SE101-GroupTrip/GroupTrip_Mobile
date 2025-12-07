import 'package:group_trip/features/chat/data/chat_member.dart';
import 'package:group_trip/features/chat/data/chat_message.dart';

class ChatModel {
  final String id; 
  final String title;
  final bool isGroup;
  final String chatImg;
  final int activeUser;
  final int unreadCount; // Default to 0 in fromJson
  final String? lastMessage;
  final String? lastMessageTime;
  final List<ChatMember>? chatMembers;
  final List<ChatMessage>? messages;

  ChatModel({
    required this.id,
    required this.title,
    required this.isGroup,
    required this.chatImg,
    this.activeUser = 0,
    this.unreadCount = 0,
    this.lastMessage,
    this.lastMessageTime,
    this.chatMembers,
    this.messages,
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

    int activeUser = 0;
    try {
      if (json['activeUser'] is int) {
        activeUser = json['activeUser'];
      } else if (json['activeUser'] is String) {
        activeUser = int.tryParse(json['activeUser']) ?? 0;
      }
    } catch (_) {
      activeUser = 0;
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

    String? lastMessageTime;
    try {
      lastMessageTime = json['lastMessageTime']?.toString();
    } catch (_) {
      lastMessageTime = null;
    }

    List<ChatMember>? chatMembers;
    try {
      if (json['chatMembers'] is List) {
        chatMembers = (json['chatMembers'] as List<dynamic>)
            .map((e) => ChatMember.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
    } catch (_) {
      chatMembers = null;
    }

    List<ChatMessage>? messages;
    try {
      if (json['messages'] is List) {
        messages = (json['messages'] as List<dynamic>)
            .map((e) => ChatMessage.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
    } catch (_) {
      messages = null;
    }

    return ChatModel(
      id: id,
      title: title,
      isGroup: isGroup,
      chatImg: chatImg,
      activeUser: activeUser,
      unreadCount: unreadCount,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
      chatMembers: chatMembers,
      messages: messages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isGroup': isGroup,
      'chatImg': chatImg,
      'activeUser': activeUser,
      'unreadCount': unreadCount,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'chatMembers': chatMembers?.map((e) => e.toJson()).toList(),
      'messages': messages?.map((e) => e.toJson()).toList(),
    };
  }

  ChatModel copyWith({
    String? id,
    String? title,
    bool? isGroup,
    String? chatImg,
    int? activeUser,
    int? unreadCount,
    String? lastMessage,
    String? lastMessageTime,
    List<ChatMember>? chatMembers,
    List<ChatMessage>? messages,
  }) {
    return ChatModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isGroup: isGroup ?? this.isGroup,
      chatImg: chatImg ?? this.chatImg,
      activeUser: activeUser ?? this.activeUser,
      unreadCount: unreadCount ?? this.unreadCount,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      chatMembers: chatMembers ?? this.chatMembers,
      messages: messages ?? this.messages,
    );
  }
}
