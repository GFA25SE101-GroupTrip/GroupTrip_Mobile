import 'package:group_trip/core/api/api_client.dart';

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
    final response = await api.get(
      service,
      endpoint,
    );

    final endTime = DateTime.now();
    final duration = endTime.difference(startTime);

    print(
        '⬅️ [ChatAPI] Response ($service$endpoint) status=${response.statusCode} '
        'after ${duration.inMilliseconds}ms');
    print('📦 Response data: ${response.data}');

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      dynamic payload = response.data;
      if (payload is Map && payload.containsKey('data')) {
        payload = payload['data'];
      }

      if (payload is Map<String, dynamic> && payload.containsKey('isContact')) {
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
      throw Exception('Failed to check contact: status=${response.statusCode}');
    }
  } catch (e, stack) {
    print('💥 [ChatAPI] Exception while checking contact: $e');
    print(stack);
    rethrow; // vẫn ném lỗi ra ngoài để UI hoặc logic xử lý tiếp
  }


  
}
}