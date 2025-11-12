import 'package:group_trip/features/account/representative/data/rep_api.dart';
import 'package:group_trip/features/account/representative/data/rep_model.dart';
import 'package:group_trip/features/trip/data/trip_rel_model.dart';

class RepRepository {
  // Repository methods would go here
  final RepRemoteDataSource remoteDataSource;
  RepRepository({required this.remoteDataSource});
  Future<List<RepModel>> fetchTours() async {
    try {
      print('🔁 [RepRepository] fetchTours()');
      final res = await remoteDataSource.fetchTours();
      print('✅ [RepRepository] fetchTours completed');
      return res;
    } catch (e) {
      print('❌ [RepRepository] fetchTours failed: $e');
      rethrow;
    }
  }

  Future<List<TripModel>> fetchRepresentativeTrips(String repId) async {
    try {
      print('🔁 [RepRepository] fetchRepresentativeTrips(repId: $repId)');
      final res = await remoteDataSource.fetchRepresentativeTrips(repId);
      print('✅ [RepRepository] fetchRepresentativeTrips completed');
      return res;
    } catch (e) {
      print('❌ [RepRepository] fetchRepresentativeTrips failed: $e');
      rethrow;
    }
  }
}
