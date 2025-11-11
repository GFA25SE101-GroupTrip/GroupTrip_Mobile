import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/api_client_provider.dart';
import 'package:group_trip/features/account/representative/data/rep_api.dart';
import 'package:group_trip/features/account/representative/domain/rep_repository.dart';
import 'package:group_trip/features/account/representative/data/rep_model.dart';

final repRemoteDataSourceProvider = Provider<RepRemoteDataSource>((ref) {
  return RepRemoteDataSource(apiClient: ref.watch(apiClientProvider));
});

final repRepositoryProvider = Provider<RepRepository>((ref) {
  final remoteDataSource = ref.read(repRemoteDataSourceProvider);
  return RepRepository(remoteDataSource: remoteDataSource);
});

final repNotifierProvider =
    StateNotifierProvider<RepNotifier, AsyncValue<void>>((ref) {
  print('✅ repNotifierProvider initialized');
  return RepNotifier(ref.watch(repRepositoryProvider));
});
class RepNotifier extends StateNotifier<AsyncValue<void>> {
  final RepRepository repository;

  RepNotifier(this.repository) : super(const AsyncData(null));

  Future<void> fetchTours() async {
    state = const AsyncLoading();
    try {
      await repository.fetchTours();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

// Future provider that exposes the list of representatives fetched from repository
final repListProvider = FutureProvider.autoDispose<List<RepModel>>(
  (ref) async {
    final repo = ref.watch(repRepositoryProvider);
    final res = await repo.fetchTours();
    return res;
  },
);