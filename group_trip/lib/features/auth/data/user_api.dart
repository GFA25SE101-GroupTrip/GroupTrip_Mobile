import 'package:firebase_messaging/firebase_messaging.dart';
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
    
    // 📱 Send FCM token to server after successful login
    final fcmToken = await SecureStorageService().getFcmToken();
    print('Retrieved FCM Token from storage: $fcmToken');
    if (fcmToken != null && fcmToken.isNotEmpty) {
      try {
        // Create a temporary ApiClient with the new accessToken for FCM token submission
        final fcmDataSource = FcmTokenRemoteDataSource(api: api);
        await fcmDataSource.sendFcmToken(fcmToken);
        Logger().d('FCM Token sent successfully');
      } catch (e) {
        Logger().w('Failed to send FCM Token: $e');
      }
    }
    
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


class FcmTokenRemoteDataSource {
  final ApiClient api;
  FcmTokenRemoteDataSource({required this.api});

  Future<void> sendFcmToken(String fcmToken) async {
    final response = await api.post(
      'noti',
      '/api/fcmtoken',
data: '"$fcmToken"'
    );
    Logger().d('FCM Token sent: ${response.data}');
  }


  Future<void> deleteFcmToken(String fcmToken) async {
    final response = await api.delete(
      'noti',
      '/api/fcmtoken/$fcmToken',
    );
    Logger().d('FCM Token deleted: ${response.data}');
  }
}

// Setup FCM token refresh listener
void setupFCM(FcmTokenRemoteDataSource fcmDataSource) {
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    Logger().d('FCM Token refreshed: $newToken');
    
    // Save new token to secure storage
    await SecureStorageService().saveFcmToken(newToken);
    
    // Check if user is logged in
    final storedUser = await SecureStorageService().getUserResponseFromJson();
    if (storedUser != null && storedUser.accessToken.isNotEmpty) {
      // User is logged in, send new FCM token to server
      try {
        await fcmDataSource.sendFcmToken(newToken);
        Logger().d('New FCM Token sent to server successfully');
      } catch (e) {
        Logger().w('Failed to send new FCM Token to server: $e');
      }
    } else {
      Logger().d('User not logged in, FCM token will be sent on next login');
    }
  });
}

