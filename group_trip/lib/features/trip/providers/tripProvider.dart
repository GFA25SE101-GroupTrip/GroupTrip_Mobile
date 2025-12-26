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
    FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, tripDepartureId) async {
  final tripRepository = ref.watch(tripRepositoryProvider);
  return tripRepository.joinTrip(tripDepartureId);
});

// final JoinTripWithInsuranceProvider =
//     FutureProvider.autoDispose.family<bool, Map<String, dynamic>>((ref, params) async {
//   final tripRepository = ref.watch(tripRepositoryProvider);
//   final tripDepartureId = params['tripDepartureId'] as String;
//   final insuranceId = params['insuranceId'] as String?;
  
//   // Gọi joinTrip
//   final joined = await tripRepository.joinTrip(tripDepartureId);
  
//   // Nếu join thành công và có insuranceId, thêm bảo hiểm
//   if (joined && insuranceId != null && insuranceId.isNotEmpty) {
//     await tripRepository.addInsuranceToTripDeparture(tripDepartureId, insuranceId);
//   }
  
//   return joined;
// });

final CheckJoinTripProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, tripDepartureId) async {
  final tripRepository = ref.watch(tripRepositoryProvider);
  return tripRepository.checkJoin(tripDepartureId);
});


final SearchTripByNameProvider =
    FutureProvider.autoDispose.family<List<TripModel>, String>((ref, tripName) async {
  final tripRepository = ref.watch(tripRepositoryProvider);
  return tripRepository.searchTripsByName(tripName);
});

final SearchTripByDateProvider =
    FutureProvider.autoDispose.family<List<TripModel>, String>((ref, fromDate) async {
  final tripRepository = ref.watch(tripRepositoryProvider);
  return tripRepository.searchTripsByDate(fromDate);
});