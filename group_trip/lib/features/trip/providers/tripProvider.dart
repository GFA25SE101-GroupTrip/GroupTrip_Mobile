import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/api_client_provider.dart';
import 'package:group_trip/features/trip/data/trip_api.dart';
import 'package:group_trip/features/trip/data/trip_rel_model.dart';
import 'package:group_trip/features/trip/domain/trip_repository.dart';

final TripRemoteDataSourceProvider = Provider<TripRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TripRemoteDataSource(apiClient: apiClient);
});

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final remoteDataSource = ref.watch(TripRemoteDataSourceProvider);
  return TripRepository(remoteDataSource: remoteDataSource);
});

final TripModelProvider = FutureProvider.autoDispose<List<TripModel>>((ref) async {
  final tripRepository = ref.watch(tripRepositoryProvider);
  return tripRepository.getTrips();
});

final TripDetailModelProvider =
    FutureProvider.autoDispose.family<TripModel, String>((ref, tripId) async {
  final tripRepository = ref.watch(tripRepositoryProvider);
  return tripRepository.getTripById(tripId);
});

final JoinTripProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, tripDepartureId) async {
  final tripRepository = ref.watch(tripRepositoryProvider);
  return tripRepository.joinTrip(tripDepartureId);
});

final CheckJoinTripProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, tripDepartureId) async {
  final tripRepository = ref.watch(tripRepositoryProvider);
  return tripRepository.checkJoin(tripDepartureId);
});