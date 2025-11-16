import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:group_trip/core/config/secure_storage_service.dart';
import 'package:group_trip/core/providers/user_storage_provider.dart';
import 'package:group_trip/core/signalr/signalr_provider.dart';
import 'package:group_trip/features/chat/data/chat_message.dart';
// import 'package:group_trip/features/chat/presentation/widgets/dateTitle.dart';
import 'package:group_trip/features/chat/presentation/widgets/incomingImage.dart';
import 'package:group_trip/features/chat/presentation/widgets/incomingText.dart';
import 'package:group_trip/features/chat/presentation/widgets/incomingTripCard.dart';
import 'package:group_trip/features/chat/presentation/widgets/outgoindImage.dart';
import 'package:group_trip/features/chat/presentation/widgets/outgoingText.dart';
import 'package:group_trip/features/chat/providers/chat_provider.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:group_trip/features/chat/data/chat_model.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final String chatId;
  const ChatDetailScreen({super.key, required this.chatId});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _textController = TextEditingController();
  List<ChatMessage> _messages = [];
  File? _pickedImage;

  // Simple in-memory messages for UI demonstration


  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final user = await ref.read(userFromStorageProvider.future);
        final token = user?.accessToken ?? '';
        if (token.isNotEmpty) {
          print('🔗 Connecting to SignalR with token: $token');
          await ref.read(signalRControllerProvider).connect(token);
          ref.read(signalRControllerProvider).incoming.listen((msg) {
            setState(() {
              _messages.add(msg);
            });
          });
        }
      } catch (e) {
        // ignore: avoid_print
        print('⚠️ SignalR connect error: $e');
      }
    });
  }



  Future<void> _pickImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file != null) {
      setState(() {
        _pickedImage = File(file.path);
      });
    }
  }

  // void _sendMessage() {
  //   final text = _textController.text.trim();
  //   if (_pickedImage != null) {
  //     setState(() {
  //       _messages.add({'type': 'outgoing_image', 'filePath': _pickedImage!.path, 'time': 'Vừa xong'});
  //       _pickedImage = null;
  //       _textController.clear();
  //     });
  //     return;
  //   }

  //   if (text.isEmpty) return;

  //   setState(() {
  //     _messages.add({'type': 'outgoing_text', 'text': text, 'time': 'Vừa xong'});
  //     _textController.clear();
  //   });
  // }

  void _openImagePreview({String? networkUrl, String? filePath}) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Colors.black.withOpacity(0.9),
            child: Container(
              child: networkUrl != null
                  ? Image.network(networkUrl, fit: BoxFit.contain)
                  : filePath != null
                      ? Image.file(File(filePath), fit: BoxFit.contain)
                      : const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }



  Widget _buildNormalizedMessageWidget(ChatMessage m) {
    final type = m.messageType;
    final user = ref.read(userFromStorageProvider);
    final userID = user.asData?.value?.userId;
    final isMine = m.senderId == userID;
    switch (type) {
      // case 'date':
      //   return DateTitle(text: m. ?? '');
      case 'Normal':
        if (isMine) return OutgoingText(message: m.content);
        return IncomingText(name: m.senderName.isNotEmpty ? m.senderName : 'Người gửi', message: m.content);
      case 'image':
        if (isMine) {
          return GestureDetector(
            onTap: () => _openImagePreview(filePath: m.attachmentUrl, networkUrl: m.attachmentUrl),
            child: OutgoingImage(filePath: m.attachmentUrl ?? ''),
          );
        }
        return GestureDetector(
          onTap: () => _openImagePreview(networkUrl: m.attachmentUrl, filePath: m.attachmentUrl),
          child: IncomingImage(name: m.senderName.isNotEmpty ? m.senderName : 'Người gửi', imageUrl: m.attachmentUrl),
        );
      case 'trip':
        return IncomingTripCard(name: m.senderName.isNotEmpty ? m.senderName : 'Người gửi');
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatDetailAsyncValue = ref.watch(chatDetailViewProvider(widget.chatId));
    // Prepare messages: prefer loaded chat detail when available
    List<ChatMessage> sourceMessages = _messages;
    chatDetailAsyncValue.maybeWhen(
      data: (val) {
        try {
          if (val != null && val.messages != null && (val.messages as List).isNotEmpty) {
            // val.messages is already a List<ChatMessage> from ChatModel.fromJson
            sourceMessages = List<ChatMessage>.from(val.messages as List);
          }
        } catch (e) {
          print('⚠️ chat detail normalize error: $e');
        }
      },
      loading: () {
        print('⏳ chatDetailViewProvider loading for chatId=${widget.chatId}');
      },
      error: (err, st) {
        print('❌ chatDetailViewProvider error: $err');
      },
      orElse: () {},
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            chatDetailAsyncValue.maybeWhen(
              data: (chatDetail) =>
              
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    chatDetail?.chatImg ??
                    "https://i.pravatar.cc/150?img=5",
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chatDetail?.title ?? "Trip to Đà Lạt 2025",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          (chatDetail?.chatMembers.length ?? 0).toString() + " Thành viên",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
              orElse: () => const SizedBox.shrink(),
            ),
            Container(
              margin: const EdgeInsets.only(right: 0),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                onTap: () {
                  context.push('/chat/info');
                },
                child: const Icon(Icons.more_vert_outlined, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // CHAT LIST
          if (sourceMessages.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  chatDetailAsyncValue.isLoading ? 'Đang tải tin nhắn...' : 'Chưa có tin nhắn',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: sourceMessages.length,
                itemBuilder: (context, index) {
                  final m = sourceMessages[index];
                  return _buildNormalizedMessageWidget(m);
                },
              ),
            ),

          // INPUT BAR
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image_outlined),
                    onPressed: _pickImage,
                    color: Colors.blue,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_pickedImage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(_pickedImage!, height: 80),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => setState(() => _pickedImage = null),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close, color: Colors.white, size: 18),
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
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.blue,
                    child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () async {
                          final text = _textController.text.trim();
                          final storedUser = await ref.read(userFromStorageProvider.future);
                          final senderId = storedUser?.userId ?? '';

                          if (_pickedImage != null) {
                            final messageMap = {
                              'content': '',
                              'messageType': 'image',
                              'attachmentUrl': _pickedImage!.path,
                            };
                            await ref.read(signalRControllerProvider).sendMessage(messageMap, senderId, widget.chatId);
                            setState(() {
                              _messages.add(ChatMessage(senderId: senderId, senderName: storedUser?.userName ?? '', content: '', attachmentUrl: _pickedImage!.path, messageType: 'image', userRead: []));
                              _pickedImage = null;
                            });
                            _textController.clear();
                            return;
                          }

                          if (text.isEmpty) return;
                          final messageMap = {
                            'content': text,
                            'messageType': 'Normal',
                            'attachmentUrl': '',
                          };
                          await ref.read(signalRControllerProvider).sendMessage(messageMap, senderId, widget.chatId);
                          setState(() {
                            _messages.add(ChatMessage(senderId: senderId, senderName: storedUser?.userName ?? '', content: text, attachmentUrl: '', messageType: 'Normal', userRead: []));
                            _textController.clear();
                          });
                        },
                      ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
