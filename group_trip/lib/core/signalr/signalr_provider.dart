import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/chat/Hub/connection.dart';
import 'package:group_trip/features/chat/data/chat_message.dart';
import 'package:group_trip/core/providers/user_storage_provider.dart';
import 'package:signalr_netcore/hub_connection.dart';

class SignalRController {
  final Ref ref;
  final SignalRService _svc = SignalRService();
  final StreamController<ChatMessage> _incoming = StreamController.broadcast();

  Stream<ChatMessage> get incoming => _incoming.stream;

  SignalRController(this.ref);

  bool _connected = false;
  bool _isConnecting = false;
  bool _handlersAttached = false; // 👈 Thêm cờ để chỉ attach handler 1 lần

  Future<void> connect(String token) async {
    if (_connected || _isConnecting) return;

    print("🔗 SignalR connecting...");
    _isConnecting = true;

    try {
      await _svc.initConnection(token);
      _connected = true;

      print("✅ SignalR connected");

      // attach handler đúng 1 lần duy nhất
      _attachHandlers();
    } catch (e) {
      print("❌ SignalR connect error: $e");
      rethrow;
    } finally {
      _isConnecting = false;
    }
  }

  void _attachHandlers() {
    if (_handlersAttached) return; // Không attach trùng

    _handlersAttached = true;

    _svc.connection!.on("ReceiveMessage", (args) {
      try {
        final senderId = args != null && args.isNotEmpty ? args[0] as String? : null;
        final rawContent = args != null && args.length > 1 ? args[1] : null;

        String content = '';
        String attachmentUrl = '';
        String messageType = 'Normal';

        if (rawContent is Map) {
          content = rawContent['content']?.toString() ?? '';
          attachmentUrl = rawContent['attachmentUrl']?.toString() ?? '';
          messageType = rawContent['messageType']?.toString() ?? 'Normal';
        } else if (rawContent != null) {
          content = rawContent.toString();
        }

        _incoming.add(ChatMessage(
          senderId: senderId ?? '',
          senderName: '',
          content: content,
          attachmentUrl: attachmentUrl,
          messageType: messageType,
          userRead: [],
        ));
      } catch (e) {
        print('⚠️ SignalR receive parsing error: $e');
      }
    });

    _svc.connection!.on("MessagesMarkedAsRead", (args) {
      print("👁 Read message event: $args");
    });

    print("📌 Handlers attached");
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
      print("⚠️ SignalR send failed: $e");
      rethrow;
    }
  }

  Future<void> markRead(String chatId, String userId) async {
    await _svc.markRead(chatId, userId);
  }

  Future<void> dispose() async {
    try {
      final state = _svc.connection!.state;
      if (state == HubConnectionState.Connected ||
          state == HubConnectionState.Reconnecting) {
        await _svc.connection!.stop();
      }
    } catch (_) {}

    await _incoming.close();
  }
}

final signalRControllerProvider = Provider<SignalRController>((ref) {
  final ctrl = SignalRController(ref);
  ref.onDispose(ctrl.dispose);
  return ctrl;
});

