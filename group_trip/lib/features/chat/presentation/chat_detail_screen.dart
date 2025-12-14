import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/config/secure_storage_service.dart';
import 'package:group_trip/core/providers/user_storage_provider.dart';
import 'package:group_trip/core/signalr/signalr_provider.dart';
import 'package:group_trip/features/chat/data/chat_message.dart';
import 'package:group_trip/features/chat/data/chat_model.dart';
import 'package:group_trip/features/chat/providers/chat_provider.dart';
import 'package:group_trip/features/chat/presentation/widgets/chat_message_list.dart';
import 'package:group_trip/features/chat/presentation/widgets/chat_input_bar.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final String chatId;
  const ChatDetailScreen({super.key, required this.chatId});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _textController = TextEditingController();
  File? _pickedImage;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _connectSignalR();
      _markMessagesAsRead(); // 📍 Đánh dấu tin đã đọc
    });
    WidgetsBinding.instance.addObserver(_KeyboardObserver(this));
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(_KeyboardObserver(this));
    super.dispose();
  }

  /// 📍 Gọi server để đánh dấu tin nhắn đã đọc
  Future<void> _markMessagesAsRead() async {
    try {
      final signalR = ref.read(signalRControllerProvider);
      await signalR.markMessagesAsRead(widget.chatId);
      print('✅ Marked messages as read for chat ${widget.chatId}');
    } catch (e) {
      print('❌ Error marking messages as read: $e');
    }
  }

  Future<void> _connectSignalR() async {
    try {
      final user = await ref.read(userFromStorageProvider.future);
      final token = user?.accessToken;
      if (token != null && token.isNotEmpty) {
        final signalR = ref.read(signalRControllerProvider);

        // 🔄 Thêm chatId vào danh sách join
        signalR.addChatId(widget.chatId);

        // Nếu đã connected, join ngay
        if (signalR.isConnected()) {
          await signalR.joinChatDirectly(widget.chatId);
          print('✅ Joined chat ${widget.chatId}');
        }

        await signalR.connect(token, widget.chatId);
      }
    } catch (e) {
      print('SignalR connect error: $e');
    }
  }

  void _openImagePreview(String? networkUrl, String? filePath) {
    showDialog(
      context: context,
      builder:
          (_) => GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.black.withOpacity(0.95),
              child: Center(
                child:
                    networkUrl != null
                        ? Image.network(networkUrl, fit: BoxFit.contain)
                        : Image.file(File(filePath!), fit: BoxFit.contain),
              ),
            ),
          ),
    ).then((_) => setState(() {})); // fix lỗi hình bị mờ khi quay lại
  }

  void _scrollToBottom({bool animate = true}) {
    if (!_scrollController.hasClients) return;
    
    // Đảm bảo có dữ liệu để scroll
    if (_scrollController.position.maxScrollExtent == 0) {
      print('⚠️ No content to scroll');
      return;
    }

    // Với reverse: false → scroll về maxScrollExtent là xuống dưới cùng (tin nhắn mới nhất)
    try {
      if (animate) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    } catch (e) {
      print('⚠️ Scroll error: $e');
    }
  }

  /// 🔄 Refetch tin nhắn khi pull-to-refresh
  Future<void> _refreshMessages() async {
    try {
      // Invalidate provider để force refetch từ server
      ref.refresh(chatDetailProvider(widget.chatId));
      await Future.delayed(const Duration(milliseconds: 500));
      print('✅ Refreshed messages for chat ${widget.chatId}');
    } catch (e) {
      print('❌ Error refreshing messages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatDetailProvider(widget.chatId));
    final currentUserId =
        ref.watch(userFromStorageProvider).asData?.value?.userId;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: chatAsync.when(
          data:
              (chat) => Row(
                children: [
                  CircleAvatar(backgroundImage: NetworkImage(chat.chatImg)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${chat.chatMembers?.length ?? 1} thành viên",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          loading: () => const Text("Đang tải..."),
          error: (_, __) => const Text("Lỗi"),
        ),
      ),
      body: chatAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Lỗi: $err')),
        data: (chat) {
          final messages = chat.messages ?? [];
          print("ORDER:");
          for (var m in messages) print(m.createdTime);
          
          // 🔄 Scroll tới bottom khi có tin nhắn mới
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom(animate: false);
          });

          // Check if user is inactive
          return FutureBuilder<bool>(
            future: _checkUserInactiveStatus(chat),
            builder: (context, snapshot) {
              final isUserInactive = snapshot.data ?? false;

              return Column(
                children: [
                  // Show blocking message if user is inactive
                  if (isUserInactive)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: Colors.orange.shade50,
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.orange.shade700,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Bạn đã rời khỏi tin nhắn này và không cho phép nhắn tin và không cho phép xem tin nhắn mới',
                              style: TextStyle(
                                color: Colors.orange.shade700,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  Expanded(
                    child: ChatMessageList(
                      messages: messages,
                      currentUserId: currentUserId,
                      groupAvatar: chat.chatImg,
                      scrollController: _scrollController,
                      onRefresh: _refreshMessages,
                      onImageTap: _openImagePreview,
                      chatMembers: chat.chatMembers,
                    ),
                  ),
                  
                  // Show input only if user is active
                  if (!isUserInactive)
                    ChatInputBar(
                      senderId: currentUserId ?? '',
                      textController: _textController,
                      pickedImage: _pickedImage,
                      onSendMessage: () => _sendMessage(currentUserId ?? ''),
                      onImagePicked: (file) => setState(() => _pickedImage = file),
                      onTextChanged: (_) {},
                      onRemoveImage: () => setState(() => _pickedImage = null),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<bool> _checkUserInactiveStatus(ChatModel chat) async {
    try {
      final secureStorage = SecureStorageService();
      final user = await secureStorage.getUserResponseFromJson();
      final currentUserId = user?.userId;

      if (currentUserId == null || chat.chatMembers == null || chat.chatMembers!.isEmpty) {
        return false;
      }

      // Check if current user is in chatMembers
      final userMember = chat.chatMembers!.firstWhere(
        (member) => member.travellerId == currentUserId,
        orElse: () => throw Exception('User not found in chat members'),
      );

      print('Member status for user $currentUserId in chat ${chat.id}: ${userMember.memberStatus}');
      return userMember.memberStatus?.toLowerCase() == 'inactive';
    } catch (e) {
      print('Error checking user inactive status: $e');
      return false;
    }
  }

  Future<void> _sendMessage(String senderId) async {
    final text = _textController.text.trim();
    if (text.isEmpty && _pickedImage == null) return;

    final isImage = _pickedImage != null;

    // ⏰ Lấy thời gian hiện tại (UTC format như server gửi)
    final messageTime =
        DateTime.now()
            .toUtc()
            .toIso8601String(); // Ví dụ: "2025-12-10T22:45:11.676284Z"

    _textController.clear();
    setState(() => _pickedImage = null);

    final payload = {
      'content': isImage ? '' : text,
      'messageType': isImage ? 'image' : 'Normal',
      'createdTime': messageTime, // ⏰ Gửi lên UTC format
      if (isImage) 'attachmentUrl': _pickedImage?.path,
    };

    try {
      await ref
          .read(signalRControllerProvider)
          .sendMessage(payload, senderId, widget.chatId);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gửi thất bại: $e")));
    }
  }
}

class _KeyboardObserver extends WidgetsBindingObserver {
  final _ChatDetailScreenState state;
  _KeyboardObserver(this.state);

  @override
  void didChangeMetrics() {
    Future.delayed(
      const Duration(milliseconds: 100),
      () => state._scrollToBottom(),
    );
  }
}
