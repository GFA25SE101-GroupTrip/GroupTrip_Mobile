import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/api_client_provider.dart';
import 'package:group_trip/features/account/traveller/data/tral_api.dart';
import 'package:group_trip/features/account/traveller/data/tral_model.dart';
import 'package:group_trip/features/account/traveller/domain/tral_repository.dart';

final tralRemoteDataSourceProvider = Provider<TravellerResourceData>(
  (ref) => TravellerResourceData(api: ref.read(apiClientProvider)),
);

final tralRepositoryProvider = Provider<TravellerRepository>(
  (ref) {
    final tralApi = ref.watch(tralRemoteDataSourceProvider);
    return TravellerRepository(remoteDataSource: tralApi);
  },
);

final travellerModelProvider =
    FutureProvider.family<TravellerModel?, String>((ref, userId) async {
  final repo = ref.read(tralRepositoryProvider);
  try {
    final model = await repo.fetchUserProfile(userId);
    return model;
  } catch (e) {
    return null;
  }
});


final travellerBlogsProvider =
    FutureProvider.family<List<BlogsTraveller>?, String>((ref, userId) async {
  final repo = ref.read(tralRepositoryProvider);
  try {
    final blogs = await repo.fetchTravellerBlogs(userId);
    print('Fetched blogs for traveller $userId: $blogs');
    return blogs;
  } catch (e) {
    return null;
  }
});

