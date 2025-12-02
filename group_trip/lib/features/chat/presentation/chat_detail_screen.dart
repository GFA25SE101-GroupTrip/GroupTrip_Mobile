import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:group_trip/core/providers/user_storage_provider.dart';
import 'package:group_trip/core/signalr/signalr_provider.dart';
import 'package:group_trip/core/utils/dataFormat.dart';
import 'package:group_trip/features/chat/data/chat_message.dart';
import 'package:group_trip/features/chat/presentation/widgets/incomingImage.dart';
import 'package:group_trip/features/chat/presentation/widgets/incomingText.dart';
import 'package:group_trip/features/chat/presentation/widgets/incomingTripCard.dart';
import 'package:group_trip/features/chat/presentation/widgets/outgoindImage.dart';
import 'package:group_trip/features/chat/presentation/widgets/outgoingText.dart';
import 'package:group_trip/features/chat/providers/chat_provider.dart';
import 'package:image_picker/image_picker.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final String chatId;
  const ChatDetailScreen({super.key, required this.chatId});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _textController = TextEditingController();
  File? _pickedImage;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _inputBarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _connectSignalR();
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

  Future<void> _connectSignalR() async {
    try {
      final user = await ref.read(userFromStorageProvider.future);
      final token = user?.accessToken;
      if (token != null && token.isNotEmpty) {
        await ref.read(signalRControllerProvider).connect(token, widget.chatId);
      }
    } catch (e) {
      print('SignalR connect error: $e');
    }
  }

  Future<void> _pickImage() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null) {
      setState(() => _pickedImage = File(file.path));
    }
  }

  void _openImagePreview({String? networkUrl, String? filePath}) {
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

  // Với reverse: true → scroll về 0 là xuống dưới cùng
  if (animate) {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  } else {
    _scrollController.jumpTo(0);
  }
}

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatDetailProvider(widget.chatId));
    final currentUserId =
        ref.watch(userFromStorageProvider).asData?.value?.userId;

    // Incoming SignalR messages are handled by ChatDetailNotifier (it listens to the
    // SignalR controller stream). Do not duplicate handling here to avoid
    // duplicate message inserts.

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
          final messages = chat.messages;

          return Column(
            children: [
              Expanded(
                child:
                    messages.isEmpty
                        ? const Center(child: Text("Chưa có tin nhắn"))
                        : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16,
                            bottom: 100, // để chừa chỗ cho input bar + keyboard
                          ),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            // Vì reverse: true → index 0 là tin nhắn mới nhất
                            final m = messages[index];
                            final isMine = m.senderId == currentUserId;

                            return _buildMessageWidget(m, isMine, chat.chatImg);
                          },
                        ),
              ),
              _buildInputBar(currentUserId ?? ''),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageWidget(ChatMessage m, bool isMine, String? groupAvatar) {
    final formattedTime = FormatMessageTime(m.createdTime);
    switch (m.messageType) {
      case 'image':
        return GestureDetector(
          onTap:
              () => _openImagePreview(
                networkUrl: isMine ? null : m.attachmentUrl,
                filePath: isMine ? m.attachmentUrl : null,
              ),
          child:
              isMine
                  ? OutgoingImage(filePath: m.attachmentUrl, time: formattedTime)
                  : IncomingImage(
                    name: m.senderName.isNotEmpty ? m.senderName : 'Người gửi',
                    imageUrl: m.attachmentUrl,
                    time: formattedTime,
                  ),
        );

      case 'Normal':
      default:
        return isMine
            ? OutgoingText(message: m.content, time: formattedTime,)
            : IncomingText(
              avatar:
                  groupAvatar ?? "https://i.pravatar.cc/150?u=${m.senderId}",
              name: m.senderName.isNotEmpty ? m.senderName : 'Người gửi',
              message: m.content,
              time: formattedTime,
            );
    }
  }

  Widget _buildInputBar(String senderId) {
    return SafeArea(
      child: Container(
        key: _inputBarKey,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: _pickImage,
              icon: const Icon(Icons.image_outlined, color: Colors.blue),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_pickedImage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _pickedImage!,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => setState(() => _pickedImage = null),
                              child: const CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.black54,
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Nhập tin nhắn...",
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(senderId),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () => _sendMessage(senderId),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage(String senderId) async {
    final text = _textController.text.trim();
    if (text.isEmpty && _pickedImage == null) return;

    final isImage = _pickedImage != null;

    final localMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // BẮT BUỘC CÓ ID
      chatId: widget.chatId,
      senderId: senderId,
      senderName: "Bạn",
      content: isImage ? '' : text,
      attachmentUrl: isImage ? _pickedImage!.path : '',
      messageType: isImage ? 'image' : 'Normal',
      createdTime: DateTime.now().toUtc().toIso8601String(),
      isMine: true,
      userRead: [],
    );

    // Optimistic UI
    ref
        .read(chatDetailProvider(widget.chatId).notifier)
        .addMessageLocally(localMessage);
    _textController.clear();
    setState(() => _pickedImage = null);
    _scrollToBottom();

    final payload = {
      'content': isImage ? '' : text,
      'messageType': isImage ? 'image' : 'Normal',
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
    Future.delayed(const Duration(milliseconds: 100), () => state._scrollToBottom());  
}
}
