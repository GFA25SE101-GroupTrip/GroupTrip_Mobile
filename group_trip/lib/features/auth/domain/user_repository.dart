import 'package:group_trip/features/auth/data/user_api.dart';
import 'package:group_trip/features/auth/data/user_model.dart';

class UserRepository { 
  final UserRemoteDataSource remoteDataSource;
  UserRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> register(UserModel user) async {
    try {
      return await remoteDataSource.registerUser(user);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserResponse> login(String userName, String password) async {
    try {
      return await remoteDataSource.loginUser(userName, password);
    } catch (e) {
      rethrow;
    }
  }
}