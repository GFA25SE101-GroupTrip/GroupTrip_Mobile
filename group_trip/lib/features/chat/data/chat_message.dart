class UserReadInfo {
  final String userId;
  final String userName;
  final String imgUrl;

  UserReadInfo({
    required this.userId,
    required this.userName,
    required this.imgUrl,
  });

  factory UserReadInfo.fromJson(Map<String, dynamic> json) {
    return UserReadInfo(
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      imgUrl: json['img_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'img_url': imgUrl,
      };
}

class ChatMessage {
  final String? id; // bắt buộc có (dù tạm thời)
  final String chatId;
  final String senderId;
  final String senderName;
  final String content;
  final String attachmentUrl;
  final String messageType;
  final String createdTime; // ✅ ISO8601 string format
  final bool isMine;
  final List<UserReadInfo> userRead;
  
  // Getter: parse createdTime để sử dụng khi cần DateTime
  DateTime get createdAt => DateTime.parse(createdTime).toUtc();

  // Thêm 2 field cho event "đã đọc"
  final bool isMarkAsReadEvent;
  final String? markedUserId;

  const ChatMessage({
    this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.attachmentUrl,
    required this.messageType,
    required this.createdTime,
    required this.isMine,
    required this.userRead,
    this.isMarkAsReadEvent = false,
    this.markedUserId,
  });

  // Constructor cho event đã đọc
  factory ChatMessage.markAsRead({
    required String chatId,
    required String userId,
  }) {
    return ChatMessage(
      chatId: chatId,
      senderId: '',
      senderName: '',
      content: '',
      attachmentUrl: '',
      messageType: '',
      createdTime: DateTime.now().toUtc().toIso8601String(), // ✅ ISO8601 string
      isMine: false,
      userRead: const [],
      isMarkAsReadEvent: true,
      markedUserId: userId,
    );
  }

  ChatMessage copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? senderName,
    String? content,
    String? attachmentUrl,
    String? messageType,
    String? createdTime,
    bool? isMine,
    List<UserReadInfo>? userRead,
    bool? isMarkAsReadEvent,
    String? markedUserId,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      content: content ?? this.content,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      messageType: messageType ?? this.messageType,
      createdTime: createdTime ?? this.createdTime,
      isMine: isMine ?? this.isMine,
      userRead: userRead ?? this.userRead,
      isMarkAsReadEvent: isMarkAsReadEvent ?? this.isMarkAsReadEvent,
      markedUserId: markedUserId ?? this.markedUserId,
    );
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    String? id;
    try {
      id = json['id']?.toString();
    } catch (_) {
      id = null;
    }

    String chatId = '';
    try {
      chatId = json['chatId']?.toString() ?? '';
    } catch (_) {
      chatId = '';
    }

    String senderId = '';
    try {
      senderId = json['senderId']?.toString() ?? '';
    } catch (_) {
      senderId = '';
    }

    String senderName = '';
    try {
      senderName = json['senderName']?.toString() ?? '';
    } catch (_) {
      senderName = '';
    }

    String content = '';
    try {
      content = json['content']?.toString() ?? '';
    } catch (_) {
      content = '';
    }

    String attachmentUrl = '';
    try {
      attachmentUrl = json['attachmentUrl']?.toString() ?? '';
    } catch (_) {
      attachmentUrl = '';
    }

    String messageType = 'Normal';
    try {
      messageType = json['messageType']?.toString() ?? 'Normal';
    } catch (_) {
      messageType = 'Normal';
    }

    String createdTime = DateTime.now().toUtc().toIso8601String();
    try {
      createdTime = json['createdTime']?.toString() ?? createdTime;
    } catch (_) {
      createdTime = DateTime.now().toUtc().toIso8601String();
    }

    bool isMine = false;
    try {
      isMine = json['isMine'] == true;
    } catch (_) {
      isMine = false;
    }

    List<UserReadInfo> userRead = [];
    try {
      if (json['userRead'] is List) {
        userRead = (json['userRead'] as List<dynamic>)
            .map((e) => UserReadInfo.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
    } catch (_) {
      userRead = [];
    }

    return ChatMessage(
      id: id,
      chatId: chatId,
      senderId: senderId,
      senderName: senderName,
      content: content,
      attachmentUrl: attachmentUrl,
      messageType: messageType,
      createdTime: createdTime,
      isMine: isMine,
      userRead: userRead,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'senderName': senderName,
      'content': content,
      'attachmentUrl': attachmentUrl,
      'messageType': messageType,
      'createdTime': createdTime,
      'isMine': isMine,
      'userRead': userRead.map((e) => e.toJson()).toList(),
    };
  }
}