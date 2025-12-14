import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/api_client_provider.dart';
import 'package:group_trip/features/mytrip/data/mytrip_api.dart';
import 'package:group_trip/features/mytrip/data/mytrip_model.dart';
import 'package:group_trip/features/mytrip/data/mytriptracking_model.dart';
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

  Future<void> fetchMyTrips({String status = 'UpComming'}) async {
    state = const AsyncLoading();
    try {
      final myTrips = await repository.fetchMyTrips(status: status);
      print('Fetched ${myTrips.length} my trips with status: $status');
      state = AsyncData(myTrips);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final mytripTrackingRouteProvider =
    FutureProvider.family<TrackingRoute, String>((ref, departureId) async {
  print('✅ mytripTrackingRouteProvider initialized for departureId: $departureId');
  final repository = ref.watch(mytripRepositoryProvider);
  return await repository.fetchTrackingRoute(departureId);
});

final mytripOutTripProvider =
    FutureProvider.family<void, String>((ref, tripDepartureId) async {
  print('✅ mytripOutTripProvider initialized for tripDepartureId: $tripDepartureId');
  final repository = ref.watch(mytripRepositoryProvider);
  return await repository.outTrip(tripDepartureId);
});

final mytripRejoinTripProvider =
    FutureProvider.family<void, String>((ref, tripDepartureId) async {
  print('✅ mytripRejoinTripProvider initialized for tripDepartureId: $tripDepartureId');
  final repository = ref.watch(mytripRepositoryProvider);
  return await repository.rejoinTrip(tripDepartureId);
});

final mytripPayToTripProvider =
    FutureProvider.family<void, String>((ref, tripDepartureId) async {
  print('✅ mytripPayToTripProvider initialized for tripDepartureId: $tripDepartureId');
  final repository = ref.watch(mytripRepositoryProvider);
  return await repository.payToTrip(tripDepartureId);
});

class EvaluateTripParams {
  final String tripId;
  final int rating;
  final String comment;
  final List<File> images;

  EvaluateTripParams({
    required this.tripId,
    required this.rating,
    required this.comment,
    required this.images,
  });
}


final mytripEvaluateTripProvider =
    FutureProvider.family<void, EvaluateTripParams>((ref, params) async {
  print('✅ mytripEvaluateTripProvider initialized for tripId: ${params.tripId}');
  final repository = ref.watch(mytripRepositoryProvider);
  return await repository.evaluateTrip(
    params.tripId,
    params.rating,
    params.comment,
    params.images,
  );
});