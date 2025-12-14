import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/chat/Hub/connection.dart';
import 'package:group_trip/features/chat/data/chat_message.dart';
import 'package:group_trip/features/chat/data/chat_model.dart';
import 'package:group_trip/core/providers/user_storage_provider.dart';
import 'package:group_trip/features/chat/providers/chat_provider.dart';
import 'package:signalr_netcore/hub_connection.dart';

class SignalRController {
  final Ref ref;
  final SignalRService _svc = SignalRService();

  // Thay vì 1 stream chung → dùng map để mỗi chat có stream riêng
  final Map<String, StreamController<ChatMessage>> _chatMessageControllers = {};

  SignalRController(this.ref);

  bool _connected = false;
  bool _isConnecting = false;
  bool _handlersAttached = false;

  // Public: lấy stream cho từng chat riêng biệt
  Stream<ChatMessage> messagesStream(String chatId) {
    return _chatMessageControllers.putIfAbsent(
      chatId,
      () => StreamController<ChatMessage>.broadcast(),
    ).stream;
  }

  Future<void> connect(String token, chatIds) async {
    if (_connected || _isConnecting) return;

    print("SignalR connecting...");
    _isConnecting = true;

    try {
      // if caller provides a list of chatIds, set them first so initConnection can join
      if (chatIds != null) {
        _svc.setChatIds(chatIds);
      }
      await _svc.initConnection(token);
      _connected = true;
      print("SignalR connected signalR provider");

      _attachHandlersOnce();
    } catch (e) {
      print("SignalR connect error: $e");
      rethrow;
    } finally {
      _isConnecting = false;
    }
  }

  void _attachHandlersOnce() {
    if (_handlersAttached) return;
    _handlersAttached = true;

    // ReceiveMessage: (senderId, content, chatId)
    _svc.connection!.on("ReceiveMessage", (args) {
      if (args == null || args.length < 3) {
        print("ReceiveMessage: args không đủ → $args");
        return;
      }

      try {
        final senderId = args[0].toString();
        final rawContent = args[1];
        final chatId = args[2].toString();

        // Lấy user hiện tại để biết tin của mình hay người khác
        final currentUserId = ref.read(userFromStorageProvider).asData?.value?.userId;

        String content = '';
        String attachmentUrl = '';
        String messageType = 'Normal';
        String createdTime = DateTime.now().toIso8601String(); // Default: thời gian hiện tại

        if (rawContent is Map<String, dynamic>) {
          content = rawContent['content']?.toString() ?? '';
          attachmentUrl = rawContent['attachmentUrl']?.toString() ?? '';
          messageType = rawContent['messageType']?.toString() ?? 'Normal';
          // 🔄 Lấy createdTime từ server nếu có
          if (rawContent['createdTime'] != null) {
            createdTime = rawContent['createdTime'].toString();
          }
        } else if (rawContent is String) {
          content = rawContent;
        }

        // 🔍 Lấy senderName từ chatMembers đã load trong chatDetailProvider
        // Dùng ref.read để lấy state của chat này
        String senderName = 'Người dùng';
       

        // Tạo ID tạm (rất quan trọng để Riverpod rebuild)
        final tempId = DateTime.now().millisecondsSinceEpoch.toString();
        print("ReceiveMessage: chatId=$chatId, senderId=$senderId, senderName=$senderName, content=$content, createdTime=$createdTime, tempID=$tempId");

        final message = ChatMessage(
          id: tempId, // bắt buộc có id
          chatId: chatId,
          senderId: senderId,
          senderName: senderName, // 🔄 Lấy từ chatMembers của chat này
          content: content,
          attachmentUrl: attachmentUrl,
          messageType: messageType,
          createdTime: createdTime, // 🔄 Dùng thời gian từ server
          isMine: senderId == currentUserId, // quan trọng cho UI
          userRead: [],
        );

        // Phát vào đúng stream của chat đó → UI rebuild ngay lập tức
        _chatMessageControllers.putIfAbsent(
          chatId,
          () => StreamController<ChatMessage>.broadcast(),
        ).add(message);

        print("✅ Tin nhắn mới → Chat: $chatId | Từ: $senderName ($senderId) | Mình: ${message.isMine}");
      } catch (e, s) {
        print("❌ Lỗi parse ReceiveMessage: $e\n$s");
      }
    });

    // Đã xem
    _svc.connection!.on("MessagesMarkedAsRead", (args) {
      if (args == null || args.length < 2) return;
      final chatId = args[0].toString();
      final userId = args[1].toString();

      // Gửi event đặc biệt để ChatScreen xử lý "seen"
      final event = ChatMessage.markAsRead(
        chatId: chatId,
        userId: userId,
      );

      _chatMessageControllers.putIfAbsent(
        chatId,
        () => StreamController<ChatMessage>.broadcast(),
      ).add(event);

      print("Đã xem → Chat: $chatId | User: $userId");
    });

    // 📱 UpdateConversationPreview: cập nhật preview tin nhắn cuối
    _svc.connection!.on("UpdateConversationPreview", (args) {
      if (args == null || args.isEmpty) return;
      
      try {
        final preview = args[0];
        if (preview == null) return;
        
        if (preview is! Map) return;
        
        final previewMap = preview as Map<dynamic, dynamic>;
        final chatId = previewMap['chatId']?.toString() ?? '';
        final lastMessage = previewMap['lastMessage']?.toString() ?? '';
        final senderName = previewMap['senderName']?.toString() ?? '';
        final unreadCount = previewMap['UserunreadCount'] ?? 0;
        
        print("📬 UpdateConversationPreview → ChatId: $chatId | LastMsg: $lastMessage | Unread: $unreadCount");
        // TODO: Cập nhật UI danh sách chat (chatListViewProvider)
      } catch (e) {
        print("Lỗi parse UpdateConversationPreview: $e");
      }
    });

    // 📍 ReceiveReadNotification: khi người khác đã đọc tin
    _svc.connection!.on("ReceiveReadNotification", (args) {
      if (args == null || args.length < 2) return;
      
      final chatId = args[0].toString();
      final userId = args[1].toString();
      
      print("👁️ ReceiveReadNotification → Chat: $chatId | User: $userId");
      // TODO: Cập nhật UI "đã xem" cho tin nhắn
    });

    print("SignalR handlers attached");
  }

  Future<void> sendMessage(
    Map<String, dynamic> message,
    String senderId,
    String chatId,
  ) async {
    try {
      final user = await ref.read(userFromStorageProvider.future);
      final token = user?.accessToken ?? '';
      await _svc.sendMessage(message, senderId, chatId, token);
    } catch (e) {
      print("Send message failed: $e");
      rethrow;
    }
  }

  /// Replace the list of chat IDs the user is a member of. If already connected,
  /// the service will join those groups immediately.
  void setChatIds(List<String> ids) {
    _svc.setChatIds(ids);
  }

  /// Thêm một chatId vào danh sách
  void addChatId(String chatId) {
    if (!_svc.chatIds.contains(chatId)) {
      _svc.chatIds.add(chatId);
    }
  }

  /// Kiểm tra xem đã connected chưa
  bool isConnected() {
    return _connected && _svc.connection?.state == HubConnectionState.Connected;
  }

  /// Gọi JoinChat trực tiếp nếu đã connected
  Future<void> joinChatDirectly(String chatId) async {
    if (isConnected()) {
      await _svc.joinChat(chatId);
    }
  }

  /// Mark tin nhắn là đã đọc
  Future<void> markMessagesAsRead(String chatId) async {
    try {
      final user = await ref.read(userFromStorageProvider.future);
      final token = user?.accessToken ?? '';
      await _svc.markRead(chatId, user?.userId ?? '');
    } catch (e) {
      print("Mark read failed: $e");
      rethrow;
    }
  }

  Future<void> dispose() async {
    await Future.wait(_chatMessageControllers.values.map((c) => c.close()));
    _chatMessageControllers.clear();

    if (_svc.connection?.state == HubConnectionState.Connected) {
      await _svc.connection?.stop();
    }
  }
}

// Provider
final signalRControllerProvider = Provider<SignalRController>((ref) {
  final controller = SignalRController(ref);
  ref.onDispose(controller.dispose);
  return controller;
});