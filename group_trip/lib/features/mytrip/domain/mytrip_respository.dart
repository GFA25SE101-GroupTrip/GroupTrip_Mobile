import 'package:group_trip/features/mytrip/data/mytrip_api.dart';
import 'package:group_trip/features/mytrip/data/mytrip_model.dart';

class MyTripRepository {
  final MyTripRemoteDataSource remoteDataSource;
  MyTripRepository({required this.remoteDataSource});
  
  Future<List<MyTripModel>> fetchMyTrips() async {
    return await remoteDataSource.fetchMyTrips();
  }

  // Define methods for fetching and managing trip data
}