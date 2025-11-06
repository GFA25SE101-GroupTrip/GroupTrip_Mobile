import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/api_client_provider.dart';
import 'package:group_trip/features/blog/data/tag_api.dart';
import 'package:group_trip/features/blog/data/tag_model.dart';
import 'package:group_trip/features/blog/domain/tag_respository.dart';

final tagRemoteDataSourceProvider = Provider((ref) {
  print('✅ tagRemoteDataSourceProvider initialized');
  final apiClient = ref.watch(apiClientProvider);
  return TagRemoteDataSource(api: apiClient);
});

final tagRepositoryProvider = Provider((ref) {
  print('✅ tagRepositoryProvider initialized');
  return TagRespository(
    remoteDataSource: ref.watch(tagRemoteDataSourceProvider),
  );
});

final tagNotifierProvider =
    StateNotifierProvider<TagNotifier, AsyncValue<void>>((ref) {
  print('✅ tagNotifierProvider initialized');
  final repository = ref.watch(tagRepositoryProvider);
  return TagNotifier(repository: repository);
});


class TagNotifier extends StateNotifier<AsyncValue<void>> {
  final TagRespository repository;

  TagNotifier({required this.repository}) : super(const AsyncValue.data(null));

  Future<void> addTag(String name, String description) async {
    state = const AsyncValue.loading();
    try {
      await repository.addTag(name, description);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<List<TagModel>> fetchTags() async {
    try {
      final tags = await repository.getTags();
      return tags;
    } catch (e) {
      rethrow;
    }
  }
}
