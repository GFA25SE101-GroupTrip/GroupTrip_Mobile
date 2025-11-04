import 'package:dio/dio.dart';
import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/features/profile/data/profile_model.dart';

class ProfileRemoteDataSource {
  final ApiClient api;

  ProfileRemoteDataSource({required this.api});

  Future<ProfileModel> fetchUserProfile() async {
    // Log request for debugging so we can confirm network activity
    // ignore: avoid_print
    print('➡️ [ProfileAPI] GET /profiles/current-user -> service=user');
    final response = await api.get('user', '/api/profiles/current-user');
    // ignore: avoid_print
    print('⬅️ [ProfileAPI] GET /profiles/current-user status=${response.statusCode} data=${response.data}');

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      // The backend wraps response in { data: { ... } } — handle that shape.
      dynamic payload = response.data;
      if (payload is Map && payload.containsKey('data')) {
        payload = payload['data'];
      }

      if (payload is Map<String, dynamic>) {
        return ProfileModel.fromJson(payload);
      } else {
        throw Exception('Unexpected profile payload shape: ${payload.runtimeType}');
      }
    } else {
      throw Exception('Failed to load profile: status=${response.statusCode}');
    }
  }

  Future<void> updateUserProfile(String bio, String imageUrl) async {
    // Log request for debugging so we can confirm network activity
    // ignore: avoid_print
    print('➡️ [ProfileAPI] POST /profiles/user -> service=user payload={bio:${bio}, image_url:$imageUrl}');
    final response = await api.post(
      'user',
      '/api/profiles/user',
      data: {
        'bio': bio,
        'image_url': imageUrl,
      },
    );
    // ignore: avoid_print
    print('⬅️ [ProfileAPI] POST /profiles/user status=${response.statusCode} data=${response.data}');

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      // success
      // ignore: avoid_print
      print('✅ Profile updated successfully');
      // ignore: avoid_print
      print(response.data);
    } else {
      throw Exception('Failed to update profile: status=${response.statusCode}');
    }
  }
} 