import 'package:group_trip/features/account/representative/data/rep_api.dart';
import 'package:group_trip/features/account/representative/data/rep_model.dart';

class RepRepository {
  // Repository methods would go here
  final RepRemoteDataSource remoteDataSource;
  RepRepository({required this.remoteDataSource});
  Future<List<RepModel>> fetchTours() async {
    try {
      // ignore: avoid_print
      print('🔁 [RepRepository] fetchTours()');
      final res = await remoteDataSource.fetchTours();
      // ignore: avoid_print
      print('✅ [RepRepository] fetchTours completed');
      return res;
    } catch (e) {
      // ignore: avoid_print
      print('❌ [RepRepository] fetchTours failed: $e');
      rethrow;
    }
  }
}
