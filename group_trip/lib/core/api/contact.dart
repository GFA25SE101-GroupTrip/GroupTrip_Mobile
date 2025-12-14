import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

class ChatApi {
  final Dio dio;
  ChatApi(this.dio);

  /// API: GET chat theo departureId
  Future<Map<String, dynamic>> getChatByDepartureId(String departureId) async {
    try {
      final res = await dio.get("/api/chats/get-chat/$departureId");

      final data = res.data?["data"];
      if (data == null) {
        throw Exception("Missing data.result in get-chat");
      }

      return {
        "chatId": data["id"],
        "title": data["title"],
        "isGroup": data["isGroup"],
        "chatImg": data["chatImg"],
        "activeUser": data["activeUser"],
        "lastMessage": data["lastMessage"],
        "lastMessageTime": data["lastMessageTime"],
        "chatMembers": data["chatMembers"] ?? [],
        "messages": data["messages"] ?? [],
        "raw": data,
      };

    } catch (e) {
      print("❌ Error getChatByDepartureId: $e");
      rethrow;
    }
  }

  /// API: check-contact → private → private-chat
  Future<Map<String, dynamic>> checkAndCreatePrivateChat({
    required String userId,
    required String role,
  }) async {
    try {
      // 1. Check contact
      final checkRes = await dio.get('/api/chats/check-contact/$userId');
      final isContact = checkRes.data?['data']?['isContact'] == true;

      print("isContact = $isContact");

      Response res;

      // 2. Existing private chat
      if (isContact) {
        res = await dio.get('/api/chats/private/$userId');
        print("Private chat exists → fetch");
      } 
      // 3. Create new
      else {
        res = await dio.post(
          '/api/chats/private-chat/$userId',
          queryParameters: {'role': role},
        );
        print("Private chat created → new room");
      }

      final result = res.data?['data']?['result'];
      if (result == null) throw Exception("Missing data.result");

      return {
        "chatId": result["id"],
        "title": result["title"],
        "isGroup": result["isGroup"],
        "chatImg": result["chatImg"],
        "activeUser": result["activeUser"],
        "lastMessage": result["lastMessage"],
        "lastMessageTime": result["lastMessageTime"],
        "chatMembers": result["chatMembers"] ?? [],
        "messages": result["messages"] ?? [],
        "raw": result,
      };

    } catch (e) {
      print("❌ Error checkAndCreatePrivateChat: $e");
      rethrow;
    }
  }
}

/// Provider API
final chatApiProvider = Provider<ChatApi>((ref) {
  return ChatApi(
    Dio()..options.baseUrl = 'https://gt-chat.grouptrip.site',
  );
});

/// Provider private chat (dùng userId + role = Traveller)
final privateChatProvider =
    FutureProvider.family.autoDispose<Map<String, dynamic>, String>((ref, userId) async {
  final api = ref.read(chatApiProvider);
  return await api.checkAndCreatePrivateChat(
    userId: userId,
    role: "Traveller",
  );
});


/// Provider lấy chat theo departureId
final departureChatProvider =
    FutureProvider.family.autoDispose<Map<String, dynamic>, String>((ref, departureId) async {
  final api = ref.read(chatApiProvider);
  return await api.getChatByDepartureId(departureId);
});
