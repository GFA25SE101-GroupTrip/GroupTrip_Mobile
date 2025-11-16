import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  late HubConnection connection;

  Future<void> initConnection(String token) async {
    final serverUrl = "https://gt-chat.grouptrip.site/api/chats";  // URL Hub

    connection = HubConnectionBuilder()
        .withUrl(
      serverUrl,
      options: HttpConnectionOptions(
        accessTokenFactory: () async => token,
      ),
    ).build();

    // Lắng nghe tin nhắn
    connection.on("ReceiveMessage", (args) {
      final senderId = args?[0];
      final content = args?[1];
      final chatId = args?[2];

      print("📩 New message from $senderId: $content (chat $chatId)");
    });

    // Lắng nghe đã đọc tin nhắn
    connection.on("MessagesMarkedAsRead", (args) {
      final chatId = args?[0];
      final userId = args?[1];

      print("👁 User $userId read messages in chat $chatId");
    });

    // Connect
    await connection.start();
    print("SignalR Connected!");
  }

  Future<void> joinGroup(String chatId) async {
    await connection.invoke("JoinGroup", args: [chatId]);
  }

  Future<void> sendMessage(Map<String, dynamic> message, String senderId, String chatId) async {
    await connection.invoke(
      "SendMessage",
      args: [message, senderId, chatId],
    );
  }

  Future<void> markRead(String chatId, String userId) async {
    await connection.invoke(
      "MarkMessagesAsRead",
      args: [chatId, userId],
    );
  }
}
