import 'package:flutter/material.dart';
import 'package:group_trip/features/chat/data/chat_member.dart';
import 'package:group_trip/features/chat/data/chat_message.dart';
import 'package:group_trip/core/utils/dataFormat.dart';
import 'message_widget.dart';

class ChatMessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final String? currentUserId;
  final String? groupAvatar;
  final ScrollController scrollController;
  final VoidCallback onRefresh;
  final Function(String?, String?) onImageTap;
  final List<ChatMember>? chatMembers;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.currentUserId,
    required this.groupAvatar,
    required this.scrollController,
    required this.onRefresh,
    required this.onImageTap,
    this.chatMembers,
  });

  /// Get traveler info from chatMembers by senderId
  ChatMember? _getTravelerInfo(String senderId) {
    if (chatMembers == null || chatMembers!.isEmpty) {
      return null;
    }
    try {
      return chatMembers!.firstWhere(
        (member) => member.travellerId == senderId,
        orElse: () => throw Exception('Traveler not found'),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const Center(child: Text("Chưa có tin nhắn"));
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        controller: scrollController,
        reverse: false,
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 100, // để chừa chỗ cho input bar + keyboard
        ),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          // reverse: false → index 0 là tin nhắn cũ nhất (index cuối là mới nhất)
          final m = messages[index];
          final isMine = m.senderId == currentUserId;
          final formattedTime = FormatMessageTime(m.createdTime);
          
          // Get traveler info from chatMembers
          final travelerInfo = _getTravelerInfo(m.senderId);
          final senderName = travelerInfo?.travellerName ?? m.senderName;
          final senderAvatar = travelerInfo?.imgUrl ?? groupAvatar;
          
          return MessageWidget(
            message: m,
            isMine: isMine,
            formattedTime: formattedTime,
            groupAvatar: senderAvatar,
            senderName: senderName,
            onImageTap: onImageTap,
          );
        },
      ),
    );
  }
}
