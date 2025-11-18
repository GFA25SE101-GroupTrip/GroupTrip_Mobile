import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/api_client_provider.dart';
import 'package:group_trip/features/mytrip/data/mytrip_api.dart';
import 'package:group_trip/features/mytrip/data/mytrip_model.dart';
import 'package:group_trip/features/mytrip/domain/mytrip_respository.dart';

final MytripRemoteDataSourceProvider = Provider((ref) {
  print('✅ MytripRemoteDataSourceProvider initialized');
  return MyTripRemoteDataSource(api: ref.watch(apiClientProvider));
});
final mytripRepositoryProvider = Provider((ref) {
  print('✅ mytripRepositoryProvider initialized');
  return MyTripRepository(
      remoteDataSource: ref.watch(MytripRemoteDataSourceProvider));
});

final mytripNotifierProvider =
    StateNotifierProvider<MyTripNotifier, AsyncValue<List<MyTripModel>>>((ref) {
  print('✅ mytripNotifierProvider initialized');
  return MyTripNotifier(ref.watch(mytripRepositoryProvider));
});
class MyTripNotifier extends StateNotifier<AsyncValue<List<MyTripModel>>> {
  final MyTripRepository repository;

  MyTripNotifier(this.repository) : super(const AsyncData([]));

  Future<void> fetchMyTrips() async {
    state = const AsyncLoading();
    try {
      final myTrips = await repository.fetchMyTrips();
      print('Fetched ${myTrips.length} my trips');
      state = AsyncData(myTrips);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

