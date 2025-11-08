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
    print(
      '⬅️ [ProfileAPI] GET /profiles/current-user status=${response.statusCode} data=${response.data}',
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      // The backend wraps response in { data: { ... } } — handle that shape.
      dynamic payload = response.data;
      if (payload is Map && payload.containsKey('data')) {
        payload = payload['data'];
      }

      if (payload is Map<String, dynamic>) {
        return ProfileModel.fromJson(payload);
      } else {
        throw Exception(
          'Unexpected profile payload shape: ${payload.runtimeType}',
        );
      }
    } else {
      throw Exception('Failed to load profile: status=${response.statusCode}');
    }
  }

  Future<void> updateUserProfile(String bio, String imageUrl) async {
    // Log request for debugging so we can confirm network activity
    // ignore: avoid_print
    print(
      '➡️ [ProfileAPI] POST /profiles/user -> service=user payload={bio:${bio}, image_url:$imageUrl}',
    );
    final response = await api.post(
      'user',
      '/api/profiles/user',
      data: {'bio': bio, 'image_url': imageUrl},
    );
    // ignore: avoid_print
    print(
      '⬅️ [ProfileAPI] POST /profiles/user status=${response.statusCode} data=${response.data}',
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      // success
      // ignore: avoid_print
      print('✅ Profile updated successfully');
      // ignore: avoid_print
      print(response.data);
    } else {
      throw Exception(
        'Failed to update profile: status=${response.statusCode}',
      );
    }
  }

  Future<void> updateUserBio(
    String userProfileID,
    String bio,
    String imageUrl,
  ) async {
    final response = await api.put(
      'user',
      '/api/profiles/user',
      data: {'userProfileId': userProfileID, 'bio': bio, 'image_url': imageUrl},
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      // success
      // ignore: avoid_print
      print('✅ Profile updated successfully');
      // ignore: avoid_print
      print(response.data);
    } else {
      throw Exception(
        'Failed to update profile: status=${response.statusCode}',
      );
    }
  }

  Future<UserInformation> fetchUserInformation(String userId) async {
    // Implementation for fetching user information if needed
    print(
      '➡️ [ProfileAPI] GET /api/auth/getuserid/{userId} -> service=auth userId=$userId',
    );
    try {
      // Ensure the path contains a separating slash before the userId
      final path = '/api/auth/getuserid$userId';
      final response = await api.get('auth', path);
      print(
        '⬅️ [ProfileAPI] GET /api/auth/userinformation status=${response.statusCode} data=${response.data}',
      );

      if (response.statusCode == 200) {
        // Process the user information
        print('User information fetched successfully: ${response.data}');
        dynamic payload = response.data;
        if (payload is Map && payload.containsKey('data')) {
          payload = payload['data'];
        }

        return UserInformation.fromJson(payload);
      } else {
        throw Exception(
          'Failed to fetch user information: status=${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching user information: $e');
      rethrow;
    }
  }

  Future<void> updateUserInformation(
    String userID,
    String fullname,
    String phonenumber,
    String bankAccount,
    String bankName,
  ) async {
    // Log request for debugging so we can confirm network activity
    // ignore: avoid_print
    print('➡️ [ProfileAPI] PUT /profiles/user/information -> service=user');
    final response = await api.put(
      'auth',
      '/api/auth/updateuserinfo',
      data: {
        "userId": userID,
        "fullName": fullname,
        "phoneNumber": phonenumber,
        "bankAccount": bankAccount,
        "bankName": bankName,
      },
    );
    // ignore: avoid_print
    print(
      '⬅️ [ProfileAPI] POST /profiles/user/information status=${response.statusCode} data=${response.data}',
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      // success
      // ignore: avoid_print
      print('✅ User information updated successfully');
      // ignore: avoid_print
      print(response.data);
    } else {
      throw Exception(
        'Failed to update user information: status=${response.statusCode}',
      );
    }
  }
}
