import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/features/chat/data/chat_model.dart';

class ChatRemoteDataSource {
  // Implementation of remote data source methods
  final ApiClient api;
  ChatRemoteDataSource({required this.api});

  // check contact exists
  Future<bool> checkContactExists(String userId) async {
    final endpoint = '/api/chats/check-contact/${userId}';
    final service = 'chat';
    final startTime = DateTime.now();

    print('🕓 [ChatAPI] Starting request at $startTime');
    print('➡️ [ChatAPI] GET $endpoint?userId=$userId -> service=$service');

    try {
      final response = await api.get(service, endpoint);

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      print(
        '⬅️ [ChatAPI] Response ($service$endpoint) status=${response.statusCode} '
        'after ${duration.inMilliseconds}ms',
      );
      print('📦 Response data: ${response.data}');

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        dynamic payload = response.data;
        if (payload is Map && payload.containsKey('data')) {
          payload = payload['data'];
        }

        if (payload is Map<String, dynamic> &&
            payload.containsKey('isContact')) {
          print('✅ Contact check result: ${payload['isContact']}');
          return payload['isContact'] as bool;
        } else {
          print('⚠️ Unexpected payload shape: $payload');
          throw Exception(
            'Unexpected contact existence payload shape: ${payload.runtimeType}',
          );
        }
      } else {
        print('❌ HTTP error: status=${response.statusCode}');
        throw Exception(
          'Failed to check contact: status=${response.statusCode}',
        );
      }
    } catch (e, stack) {
      print('💥 [ChatAPI] Exception while checking contact: $e');
      print(stack);
      rethrow; // vẫn ném lỗi ra ngoài để UI hoặc logic xử lý tiếp
    }
  }

  Future<List<ChatModel>> getChatList() async {
    final response = await api.get('chat', '/api/chats/user-chat');
    // Giả sử response.data có cấu trúc phù hợp với ChatModel
    print('Chat list fetched: ${response.data}');
    if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        dynamic payload = response.data;
        if (payload is Map && payload.containsKey('data')) {
          payload = payload['data'];
          print('Chat list payload: $payload');
        }
        return (payload as List).map((e) => ChatModel.fromJson(e)).toList();
      } else {
        print('❌ HTTP error: status=${response.statusCode}');
        throw Exception(
          'Failed to check contact: status=${response.statusCode}',
        );
      }

  }
  Future<ChatModel> getChatDetail(String chatId) async {
    final response = await api.get('chat', '/api/chats/$chatId');
    // Giả sử response.data có cấu trúc phù hợp với ChatModel
    print('Chat detail fetched: ${response.data}');
    if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        dynamic payload = response.data;
        if (payload is Map && payload.containsKey('data')) {
          payload = payload['data'];
          print('Chat detail payload: $payload');
        }
        return ChatModel.fromJson(payload as Map<String, dynamic>);
      } else {
        print('❌ HTTP error: status=${response.statusCode}');
        throw Exception(
          'Failed to check contact: status=${response.statusCode}',
        );
      }

  }
}
