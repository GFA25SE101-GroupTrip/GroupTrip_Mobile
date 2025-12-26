import 'package:dio/dio.dart';
import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/core/config/secure_storage_service.dart';
import 'package:group_trip/features/staff/data/staff_data.dart';

class StaffRemoteDataSource {
  final ApiClient api;
  StaffRemoteDataSource({required this.api});

  Future<List<DepartureStaff>> fetchStaffs() async {
    // Get userId from secure storage

    final storage = SecureStorageService();
    final userId = await storage.getUserResponseFromJson().then(
      (user) => user?.userId ?? '',
    );

    final response = await api.get('trip', 'api/trips/departures/$userId');
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      dynamic payload = response.data;
      print('Staffs payload: $payload');
      if (payload is Map && payload.containsKey('data')) {
        payload = payload['data'];
      }

      if (payload is List) {
        return payload.map((item) {
          final itemMap = Map<String, dynamic>.from(item as Map);
          return DepartureStaff.fromJson(itemMap);
        }).toList();
      } else {
        throw Exception(
          'Unexpected staffs payload shape: ${payload.runtimeType}',
        );
      }
    } else {
      throw Exception('Failed to load staffs: status=${response.statusCode}');
    }
  }

  Future<void> updateSegmentStatus({
    required String activityId,
    required String tripId,
    required String departureId,
    required String activityPhase,
  }) async {
    try {
      final response = await api.putWithParams(
        'trip',
        'api/trips/activity-status/$activityId',
        data: {
          'tripId': tripId,
          'departureId': departureId,
          'activityPhase': activityPhase,
        },
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        print('✅ Update segment status successful for activityId: $activityId');
      } else {
        throw Exception(
          'Failed to update segment status: status=${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      // 🔥 ĐÂY là chỗ đọc message backend
      final data = e.response?.data;

      String errorCode = 'Bad request!';
      String errorMessage = 'Không thể cập nhật trạng thái hoạt động';

      if (data is Map<String, dynamic>) {
        errorCode = data['errorCode'] ?? errorCode;
        errorMessage = data['errorMessage'] ?? errorMessage;
      }

      print('💥 Update segment status error ($errorCode): $errorMessage');
      throw Exception('$errorMessage');
    } catch (e) {
      // fallback cho lỗi khác (network, timeout…)
      print('💥 Unexpected error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
