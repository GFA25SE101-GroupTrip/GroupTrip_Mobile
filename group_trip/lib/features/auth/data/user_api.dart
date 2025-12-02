import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/core/config/secure_storage_service.dart';
import 'package:group_trip/features/auth/data/user_model.dart';
import 'package:logger/logger.dart';

class UserRemoteDataSource {
  final ApiClient api;
  UserRemoteDataSource({required this.api});
  Future<Map<String, dynamic>> registerUser(UserModel user) async {
  final response = await api.post('auth', '/api/auth/register', data: user.toJson());
    Logger().d('User registered: ${response.data}');
    return response.data; // vì response.data đã là Map
  }

  Future<UserResponse> loginUser(String userName, String password) async {
    final response = await api.post(
      'auth',
      '/api/auth/login',
      data: {'userName': userName, 'password': password},
    );
    Logger().d('User logged in: ${response.data}');
    await SecureStorageService().saveTokens(
      response.data['accessToken'],
      response.data['refreshToken'],
    );
    await SecureStorageService().saveUserInfor(UserResponse.fromJson(response.data));
    await SecureStorageService().saveUserJson(response.data);
    return UserResponse.fromJson(response.data);
  }
}

class RoleRemoteDataSource {
  final ApiClient api;
  RoleRemoteDataSource({required this.api});
  Future<List<RoleModel>> getRoles() async {
  final response = await api.get('default', '/api/role');
    final List<dynamic> data = response.data as List<dynamic>;
    Logger().d('Roles fetched: $data');
    return data.map((json) => RoleModel.fromJson(json)).toList();
  }
}
