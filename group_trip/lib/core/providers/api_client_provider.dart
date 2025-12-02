import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/api/api_client.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  // đảm bảo dotenv đã load trong main trước khi provider được đọc
  return ApiClient.fromEnv();
});