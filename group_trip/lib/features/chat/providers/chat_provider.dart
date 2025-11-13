import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/api_client_provider.dart';
import 'package:group_trip/features/chat/data/chat_api.dart';
import 'package:group_trip/features/chat/domain/chat_repository.dart';

final ChatRemoteDataSourceProvider =
    Provider<ChatRemoteDataSource>((ref) {
  print('✅ ChatRemoteDataSourceProvider initialized');
  final apiClient = ref.watch(apiClientProvider);
  return ChatRemoteDataSource(api: apiClient);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final chatApi = ref.watch(ChatRemoteDataSourceProvider);
  return ChatRepository(remoteDataSource: chatApi);
});

final checkContactExistsProvider =
    FutureProvider.family<bool, String>((ref, userId) async {
  final repo = ref.read(chatRepositoryProvider);
  try {
    final model = await repo.checkContactExists(userId);
    return model;
  } catch (e) {
    // Return null on error so UI can show a sensible fallback.
    return false;
  }
});