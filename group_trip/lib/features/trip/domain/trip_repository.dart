import 'package:group_trip/features/trip/data/trip_api.dart';
import 'package:group_trip/features/trip/data/trip_rel_model.dart';

class TripRepository {
  final TripRemoteDataSource remoteDataSource;
  TripRepository({required this.remoteDataSource});
  Future<List<TripModel>> getTrips() async {
    return await remoteDataSource.fetchTrips();
  }
  Future<TripModel> getTripById(String tripId) async {
    return await remoteDataSource.fetchTripById(tripId);
  }

  Future<bool> joinTrip(String tripDepartureId) async {
    return await remoteDataSource.joinTrip(tripDepartureId);
  }
} 