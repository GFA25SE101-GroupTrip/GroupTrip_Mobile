import 'dart:io';
import 'package:flutter/material.dart';
import 'package:group_trip/features/chat/data/chat_message.dart';
import 'package:group_trip/features/chat/presentation/widgets/incomingImage.dart';
import 'package:group_trip/features/chat/presentation/widgets/incomingText.dart';
import 'package:group_trip/features/chat/presentation/widgets/outgoindImage.dart';
import 'package:group_trip/features/chat/presentation/widgets/outgoingText.dart';

class MessageWidget extends StatelessWidget {
  final ChatMessage message;
  final bool isMine;
  final String formattedTime;
  final String? groupAvatar;
  final Function(String?, String?) onImageTap;
  final String? senderName;

  const MessageWidget({
    super.key,
    required this.message,
    required this.isMine,
    required this.formattedTime,
    required this.groupAvatar,
    required this.onImageTap,
    this.senderName,
  });

  @override
  Widget build(BuildContext context) {
    switch (message.messageType) {
      case 'image':
        return _buildImageMessage();

      case 'Normal':
      default:
        return _buildTextMessage();
    }
  }

  Widget _buildTextMessage() {
    if (isMine) {
      return OutgoingText(message: message.content, time: formattedTime);
    } else {
      final displayName = senderName?.isNotEmpty == true 
        ? senderName! 
        : (message.senderName.isNotEmpty ? message.senderName : 'Người gửi');
      
      return IncomingText(
        avatar: groupAvatar ?? "https://i.pravatar.cc/150?u=${message.senderId}",
        name: displayName,
        message: message.content,
        time: formattedTime,
      );
    }
  }

  Widget _buildImageMessage() {
    final displayName = senderName?.isNotEmpty == true 
      ? senderName! 
      : (message.senderName.isNotEmpty ? message.senderName : 'Người gửi');
    
    return GestureDetector(
      onTap: () => onImageTap(
        isMine ? null : message.attachmentUrl,
        isMine ? message.attachmentUrl : null,
      ),
      child: isMine
          ? OutgoingImage(
              filePath: message.attachmentUrl,
              time: formattedTime,
            )
          : IncomingImage(
              name: displayName,
              imageUrl: message.attachmentUrl,
              time: formattedTime,
            ),
    );
  }
}
