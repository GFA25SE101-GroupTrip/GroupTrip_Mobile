// lib/core/signalr/signalr_message_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/signalr/signalr_provider.dart';
import 'package:group_trip/features/chat/data/chat_message.dart';

/// ĐÚNG: Dùng StreamProvider.family → ref.listen nhận được!
final signalRMessageProvider = StreamProvider.family<ChatMessage, String>((ref, chatId) {
  final controller = ref.watch(signalRControllerProvider);
  
  // Giữ kết nối sống mãi mãi cho đến khi screen bị dispose
  ref.keepAlive();

  return controller.messagesStream(chatId);
});