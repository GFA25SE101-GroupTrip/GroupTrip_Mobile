import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/features/auth/data/user_model.dart';
import 'package:logger/logger.dart';

class UserRemoteDataSource {
    final ApiClient api;
    UserRemoteDataSource({required this.api});
    Future<UserModel> registerUser(UserModel user) async {
      final response = await api.post('/api/auth/register', data: user.toJson());
      Logger().d('User registered: ${response.data}');
      // đã chưa được gọi đến đây
      return UserModel.fromJson(response.data);
    }

    Future<UserModel> loginUser(String userName, String password) async {
      final response = await api.post('/api/auth/login', data: {
        'userName': userName,
        'password': password,
      });
      Logger().d('User logged in: ${response.data}');
      return UserModel.fromJson(response.data);
    }
}

class RoleRemoteDataSource {
    final ApiClient api;
    RoleRemoteDataSource({required this.api});
    Future<List<RoleModel>> getRoles() async {
      final response = await api.get('/api/role');
      final List<dynamic> data = response.data as List<dynamic>;
      Logger().d('Roles fetched: $data');
      return data.map((json) => RoleModel.fromJson(json)).toList();
    }
}