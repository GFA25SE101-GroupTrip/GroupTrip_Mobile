import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/chat/Hub/connection.dart';
import 'package:group_trip/features/chat/data/chat_message.dart';
import 'package:group_trip/core/providers/user_storage_provider.dart';
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

        if (rawContent is Map<String, dynamic>) {
          content = rawContent['content']?.toString() ?? '';
          attachmentUrl = rawContent['attachmentUrl']?.toString() ?? '';
          messageType = rawContent['messageType']?.toString() ?? 'Normal';
        } else if (rawContent is String) {
          content = rawContent;
        }

        // Tạo ID tạm (rất quan trọng để Riverpod rebuild)
        final tempId = DateTime.now().millisecondsSinceEpoch.toString();
        print("ReceiveMessage: chatId=$chatId, senderId=$senderId, content=$content, tempID =$tempId");

        final message = ChatMessage(
          id: tempId, // bắt buộc có id
          chatId: chatId,
          senderId: senderId,
          senderName: 'Đang tải...',
          content: content,
          attachmentUrl: attachmentUrl,
          messageType: messageType,
          createdTime: DateTime.now().toUtc().toIso8601String(),
          isMine: senderId == currentUserId, // quan trọng cho UI
          userRead: [],
        );

        // Phát vào đúng stream của chat đó → UI rebuild ngay lập tức
        _chatMessageControllers.putIfAbsent(
          chatId,
          () => StreamController<ChatMessage>.broadcast(),
        ).add(message);

        print("Tin nhắn mới → Chat: $chatId | Từ: $senderId | Mình: ${message.isMine}");
      } catch (e, s) {
        print("Lỗi parse ReceiveMessage: $e\n$s");
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