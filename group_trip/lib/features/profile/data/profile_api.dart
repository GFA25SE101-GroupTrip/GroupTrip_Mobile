import 'package:dio/dio.dart';
import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/features/profile/data/profile_model.dart';

class ProfileRemoteDataSource {
  final ApiClient api;

  ProfileRemoteDataSource({required this.api});

  Future<ProfileModel> fetchUserProfile() async {
    final response = await api.get('user', '/profiles/current-user');
    if (response.statusCode == 200) {
      return ProfileModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load profile');
    }
  }
} 