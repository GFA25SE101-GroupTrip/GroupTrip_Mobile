import 'package:group_trip/features/auth/data/user_api.dart';
import 'package:group_trip/features/auth/data/user_model.dart';

class RoleRepository {
  final RoleRemoteDataSource remoteDataSource;
  RoleRepository({required this.remoteDataSource});

  Future<List<RoleModel>> getRoles() async {
    try {
      return await remoteDataSource.getRoles();
    } catch (e) {
      rethrow;
    }
  }
}
