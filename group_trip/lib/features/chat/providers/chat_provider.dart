import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/api_client_provider.dart';
import 'package:group_trip/core/signalr/signalr_provider.dart';
import 'package:group_trip/features/chat/data/chat_api.dart';
import 'package:group_trip/features/chat/data/chat_message.dart';
import 'package:group_trip/features/chat/data/chat_model.dart';
import 'package:group_trip/features/chat/domain/chat_repository.dart';

final ChatRemoteDataSourceProvider =
    Provider<ChatRemoteDataSource>((ref) {
  print('✅ ChatRemoteDataSourceProvider initialized');
  final apiClient = ref.watch(apiClientProvider);
  return ChatRemoteDataSource(api: apiClient);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final chatApi = ref.watch(ChatRemoteDataSourceProvider);
  return ChatRepository(remoteDataSource: chatApi);
});

final checkContactExistsProvider =
    FutureProvider.family<bool, String>((ref, userId) async {
  final repo = ref.read(chatRepositoryProvider);
  try {
    final model = await repo.checkContactExists(userId);
    return model;
  } catch (e) {
    // Return null on error so UI can show a sensible fallback.
    return false;
  }
});


final chatListViewProvider =
    FutureProvider.autoDispose<dynamic>((ref) async {
  final repo = ref.read(chatRepositoryProvider);
  try {
    final model = await repo.getChatList();
    return model;
  } catch (e) {
    // Return null on error so UI can show a sensible fallback.
    return null;
  }
});

final chatDetailViewProvider =
    FutureProvider.family.autoDispose<dynamic, String>((ref, chatId) async {
  final repo = ref.read(chatRepositoryProvider);
  try {
    print('Fetching chat details for chatId: $chatId');
    final model = await repo.getChatDetail(chatId);
    print('Fetched chat details for chatId: $chatId');

    return model;
  } catch (e) {
    // Return null on error so UI can show a sensible fallback.
    return null;
  }
});

final chatDetailProvider = StateNotifierProvider.family<ChatDetailNotifier, AsyncValue<ChatModel>, String>(
  (ref, chatId) {
    return ChatDetailNotifier(ref, chatId);
  },
);

class ChatDetailNotifier extends StateNotifier<AsyncValue<ChatModel>> {
  final Ref ref;
  final String chatId;
  StreamSubscription<ChatMessage>? _subscription;

  ChatDetailNotifier(this.ref, this.chatId) : super(const AsyncLoading()) {
    _loadInitialMessages();
    _listenToSignalR();
  }

  int _compareByCreatedTime(ChatMessage a, ChatMessage b) {
    DateTime parseSafe(String iso) {
      try {
        return DateTime.parse(iso).toUtc();
      } catch (_) {
        return DateTime.fromMillisecondsSinceEpoch(0).toUtc();
      }
    }

    final da = parseSafe(a.createdTime);
    final db = parseSafe(b.createdTime);
    return da.compareTo(db);
  }

  Future<void> _loadInitialMessages() async {
    try {
      final chatDetail = await ref.read(chatRepositoryProvider).getChatDetail(chatId);
      state = AsyncData(chatDetail);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void _listenToSignalR() {
    // QUAN TRỌNG: Dùng stream riêng theo chatId → không bị nhầm lẫn
    final signalR = ref.read(signalRControllerProvider);
    _subscription = signalR.messagesStream(chatId).listen((msg) {
      // Nếu là event "đã đọc"
      if (msg.isMarkAsReadEvent == true) {
        _handleMarkAsRead(msg.markedUserId!);
        return;
      }

      // Nếu là tin nhắn mới thật sự
      state = state.whenData((currentChat) {
        // Tránh trùng tin nhắn theo id
        final existsById = currentChat.messages.any((m) => m.id == msg.id && msg.id != null);
        if (existsById) return currentChat;

        // Heuristics: if we have a recent optimistic message (isMine=true) with the
        // same sender and content (or same attachment) within a short time window,
        // treat it as the same message and replace it rather than append a duplicate.
        DateTime parseTime(String iso) {
          try {
            return DateTime.parse(iso);
          } catch (_) {
            return DateTime.now().toUtc();
          }
        }

        final msgTime = parseTime(msg.createdTime);

        final duplicateIndex = currentChat.messages.indexWhere((m) {
          // Only consider optimistic local messages
          if (m.isMine != true) return false;

          // Match by exact attachment path or by content and sender within 5s window
          final mTime = parseTime(m.createdTime);
          final timeDiff = msgTime.difference(mTime).inSeconds.abs();

          final sameAttachment = m.attachmentUrl.isNotEmpty && msg.attachmentUrl.isNotEmpty && m.attachmentUrl == msg.attachmentUrl;
          final sameContent = m.content.isNotEmpty && msg.content.isNotEmpty && m.content == msg.content && m.senderId == msg.senderId;

          return (sameAttachment || sameContent) && timeDiff <= 5;
        });

        if (duplicateIndex != -1) {
          final updated = [...currentChat.messages];
          // Replace the optimistic message with the server message (preserve ordering)
          updated[duplicateIndex] = msg;
          updated.sort((a, b) => _compareByCreatedTime(a, b));
          return currentChat.copyWith(messages: updated);
        }

        // Otherwise append normally
        final updatedMessages = [...currentChat.messages, msg]
          ..sort((a, b) => _compareByCreatedTime(a, b));

        return currentChat.copyWith(messages: updatedMessages);
      });
    });
  }

  // Xử lý khi có người đọc tin
  void _handleMarkAsRead(String userId) {
    state = state.whenData((currentChat) {
      final updatedMessages = currentChat.messages.map((m) {
        // Chỉ thêm userId vào danh sách đã đọc nếu chưa có
        if (m.userRead.contains(userId)) return m;
        return m.copyWith(userRead: [...m.userRead, userId]);
      }).toList();

      return currentChat.copyWith(messages: updatedMessages);
    });
  }

  // Gọi khi gửi tin nhắn thành công (optimistic update)
  void addMessageLocally(ChatMessage msg) {
    state = state.whenData((currentChat) {
      final updatedMessages = [...currentChat.messages, msg]
        ..sort((a, b) => _compareByCreatedTime(a, b));
      return currentChat.copyWith(messages: updatedMessages);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}