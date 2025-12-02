// lib/features/chat/Hub/connection.dart (hoặc SignalRService.dart)

import 'package:group_trip/features/chat/providers/chat_provider.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  HubConnection? connection;

  String chatId = "";
  void setChatIds(chatIds) {
    if (chatIds != null && chatIds is String) {
      chatId = chatIds;
    }
  }
 

  
  
  Future<void> initConnection(String token) async {
    if (connection?.state == HubConnectionState.Connected) {
      print("SignalR: ĐÃ KẾT NỐI SẴN – không cần connect lại");
      return;
    }

    if (connection != null) {
      print("SignalR: Đang tái sử dụng connection cũ...");
    }

    final serverUrl = "https://gt-chat.grouptrip.site/chathub";

    connection =
        HubConnectionBuilder()
            .withUrl(
              serverUrl,
              options: HttpConnectionOptions(
                accessTokenFactory: () async => token,
                transport: HttpTransportType.WebSockets,
                skipNegotiation: false,
              ),
            )
            .withAutomaticReconnect(
              retryDelays: [0, 2000, 10000, 30000],
            ) // retry sau 0s, 2s, 10s, 30s
            .build();

    // THÊM CÁC LOG TRẠNG THÁI SIÊU RÕ RÀNG
    connection!.onclose(({error}) {
      print("SIGNALR NGẮT KẾT NỐI!!!");
      if (error != null) print("Lỗi: $error");
    });

    connection!.onreconnecting(({error}) {
      print("ĐANG THỬ KẾT NỐI LẠI SignalR...");
      if (error != null) print("Lý do mất kết nối: $error");
    });

    connection!.onreconnected(({connectionId}) {
      print("ĐÃ KẾT NỐI LẠI THÀNH CÔNG! ConnectionId: $connectionId");
    });

    // Log khi nhận tin (dù đã xử lý ở controller, nhưng giữ lại để debug)
    connection!.on("ReceiveMessage", (args) {
      print("RAW ReceiveMessage từ server: $args");
    });

    connection!.on("MessagesMarkedAsRead", (args) {
      print("RAW MessagesMarkedAsRead từ server: $args");
    });

    try {
      await connection!.start();
      await joinChat(chatId);
      
      print("SIGNALR KẾT NỐI THÀNH CÔNG! State: ${connection!.state}");
      print("Connection ID: ${connection!.connectionId}");
    } catch (e, st) {
      print("KHÔNG THỂ KẾT NỐI SIGNALR: $e");
      print(st);
      rethrow;
    }
  }

  Future<void> sendMessage(
    Map<String, dynamic> message,
    String senderId,
    String chatId,
    String token,
  ) async {
    if (connection?.state != HubConnectionState.Connected) {
      print("CẢNH BÁO: SignalR CHƯA KẾT NỐI – không thể gửi tin nhắn!");
      throw Exception("SignalR not connected");
    }

    print(
      "ĐANG GỬI TIN NHẮN → ChatId: $chatId | Từ: $senderId | Nội dung: ${message['content']}",
    );
    await connection!.invoke(
      "SendMessage",
      args: [message, senderId, chatId, token],
    );
    print("ĐÃ GỬI TIN NHẮN THÀNH CÔNG QUA SIGNALR");
  }

  Future<void> markRead(String chatId, String userId) async {
    if (connection?.state != HubConnectionState.Connected) {
      print("CẢNH BÁO: SignalR chưa kết nối – không thể mark read");
      return;
    }

    print("ĐÁNH DẤU ĐÃ ĐỌC → ChatId: $chatId | User: $userId");
    await connection!.invoke("MarkMessagesAsRead", args: [chatId, userId]);
  }

  Future<void> joinChat(String chatId) async {
    if (connection?.state != HubConnectionState.Connected) {
      print("CẢNH BÁO: SignalR chưa kết nối – không thể join group");
      return;
    }

    try {
      await connection!.invoke("JoinChat", args: [chatId]);
      print("Đã tham gia group chatId: $chatId");
    } catch (e) {
      print("Lỗi join group chatId $chatId: $e");
    }
  }
}
