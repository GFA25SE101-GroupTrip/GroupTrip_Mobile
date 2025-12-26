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

  Future<Map<String, dynamic>> joinTrip(String tripDepartureId) async {
    return await remoteDataSource.joinTrip(tripDepartureId);
  }

  Future<bool> checkJoin(String tripDepartureId) async {
    return await remoteDataSource.checkJoin(tripDepartureId);
  }

  Future<List<TripModel>> searchTripsByName(String tripName) async {
    return await remoteDataSource.fetchTripsByName(tripName);
  }

  Future<List<TripModel>> searchTripsByDate(String fromDate) async {
    return await remoteDataSource.fetchTripsByDate(fromDate);
  }

  Future<void> addInsuranceToTripDeparture(String tripDepartureId, String insurance) async {
    return await remoteDataSource.userChooseInsurance(tripDepartureId, insurance);
  }
} 