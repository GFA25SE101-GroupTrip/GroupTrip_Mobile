import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  HubConnection? connection;

  Future<void> initConnection(String token) async {
    if (connection != null) return;

    final serverUrl = "https://gt-chat.grouptrip.site/chathub";

    connection = HubConnectionBuilder()
        .withUrl(
      serverUrl,
      options: HttpConnectionOptions(
        accessTokenFactory: () async => token,
        transport: HttpTransportType.WebSockets,
        skipNegotiation: true,
      ),
    ).withAutomaticReconnect().build();

    connection!.on("ReceiveMessage", (args) {
      print("📩 New message: $args");
    });

    connection!.on("MessagesMarkedAsRead", (args) {
      print("👁 Read: $args");
    });

    try {
      await connection!.start();
      print("✅ SignalR Connected!");
    } catch (e, st) {
      print("❌ SignalR start error: $e");
      print(st);
    }
  }

  /// FIXED: thêm token vào args
  Future<void> sendMessage(
    Map<String, dynamic> message,
    String senderId,
    String chatId,
    String token,
  ) async {
    await connection!.invoke(
      "SendMessage",
      args: [message, senderId, chatId, token],
    );
  }

  Future<void> markRead(String chatId, String userId) async {
    await connection!.invoke("MarkMessagesAsRead", args: [chatId, userId]);
  }
}
