import 'package:dio/dio.dart';
import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/features/invite/data/inviteData.dart';
import 'dart:convert';

class InviteRemoteDataSource {
  final ApiClient apiClient;
  InviteRemoteDataSource({required this.apiClient});

  Future<List<InvitedData>> fetchReceivedInvites() async {
    final response = await apiClient.get(
      'trip',
      '/api/invitations/received-invitations',
    );
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      dynamic payload = response.data;
      print('Invites payload: $payload');
      if (payload is Map && payload.containsKey('data')) {
        payload = payload['data'];
      }

      if (payload is List) {
        return payload
            .map((item) => InvitedData.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Unexpected invites payload shape: ${payload.runtimeType}',
        );
      }
    } else {
      throw Exception('Failed to load invites: status=${response.statusCode}');
    }
  }

  Future<List<InvitedData>> fetchSentInvites() async {
    final response = await apiClient.get(
      'trip',
      '/api/invitations/sended-invitation',
    );
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      dynamic payload = response.data;
      print('Sent Invites payload: $payload');
      if (payload is Map && payload.containsKey('data')) {
        payload = payload['data'];
      }

      if (payload is List) {
        return payload
            .map((item) => InvitedData.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Unexpected sent invites payload shape: ${payload.runtimeType}',
        );
      }
    } else {
      throw Exception(
        'Failed to load sent invites: status=${response.statusCode}',
      );
    }
  }

  Future<void> updateInvitationStatus({
    required String invitationId,
    required String status,
  }) async {
    final response = await apiClient.put(
      'trip',
      '/api/invitations/$invitationId/status',
      data: jsonEncode(status), // ⭐ QUAN TRỌNG
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw Exception(
        'Failed to update invitation status: status=${response.statusCode}',
      );
    }
  }

  Future<List<UserSearch>> fetchUserByEmail(String email) async {
    final response = await apiClient.get(
      'auth',
      '/api/auth/user/$email',
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      dynamic payload = response.data;
      print('User payload: $payload');
      if (payload is Map && payload.containsKey('data')) {
        payload = payload['data'];
      }

      // Xử lý cả Map (single user) và List (multiple users)
      if (payload is List) {
        return payload
            .map((item) => UserSearch.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (payload is Map) {
        // Nếu là single user, wrap thành List
        return [UserSearch.fromJson(payload as Map<String, dynamic>)];
      } else {
        throw Exception(
          'Unexpected user payload shape: ${payload.runtimeType}',
        );
      }
    } else {
      throw Exception('Failed to load user: status=${response.statusCode}');
    }
  }

Future<void> sendInvitation({
  required String tripdepartureId,
  required String toUserId,
  required String content,
}) async {
  try {
    await apiClient.post(
      'trip',
      '/api/invitations/$tripdepartureId',
      data: {
        "toUserId": toUserId,
        "content": content,
      },
    );
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response!.data;

      if (data is Map<String, dynamic>) {
        // Ưu tiên errorMessage của backend
        final message = data['errorMessage'] ??
            data['message'] ??
            'Request failed';

        throw Exception(message);
      }

      if (data is String) {
        throw Exception(data);
      }

      throw Exception('Server error (${e.response!.statusCode})');
    }

    throw Exception('Network error');
  }
}



}