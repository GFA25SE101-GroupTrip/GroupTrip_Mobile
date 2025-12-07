import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/features/trip/data/trip_rel_model.dart';

class TripRemoteDataSource {
  final ApiClient apiClient;
  TripRemoteDataSource({required this.apiClient});

  Future<List<TripModel>> fetchTrips({String? status = 'Published'}) async {
    final endpoint = '/api/trips' + (status != null ? '/status' : '');
    final queryParams = status != null ? {'status': status} : <String, dynamic>{};
    
    final response = status != null
        ? await apiClient.getWithParams('trip', endpoint, queryParameters: queryParams)
        : await apiClient.get('trip', '/api/trips');
    
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      dynamic payload = response.data;
      print('Trips payload: $payload');
      if (payload is Map && payload.containsKey('data')) {
        payload = payload['data'];
      }

      if (payload is List) {
        return payload
            .map((item) => TripModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Unexpected trips payload shape: ${payload.runtimeType}',
        );
      }
    } else {
      throw Exception('Failed to load trips: status=${response.statusCode}');
    }
  }

  Future<TripModel> fetchTripById(String tripId) async {
    final response = await apiClient.get('trip','/api/trips/$tripId');
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      dynamic payload = response.data;

      if (payload is Map && payload.containsKey('data')) {
        payload = payload['data'];
      }
      if (payload is Map<String, dynamic>) {
        return TripModel.fromJson(payload);
      } else {
        throw Exception(
          'Unexpected trip payload shape: ${payload.runtimeType}',
        );
      }
    } else {
      throw Exception('Failed to load trip: status=${response.statusCode}');
    }
  }
  // Tính năng join trip members
  // https://gt-trip.grouptrip.site/api/trip-members?tripDepartureId=b65b86e1-fed0-4458-a2a7-2c7adbadb581
  Future<bool> joinTrip(String tripDepartureId) async {
    final endpoint =
        '/api/trip-members';
    final service = 'trip';

    print('➡️ [TripAPI] POST $endpoint -> service=$service');

    try {
      final response = await apiClient.postWithParams(service, endpoint, 
      queryParameters: {
        'tripDepartureId': tripDepartureId,
      });

      print(
        '⬅️ [TripAPI] Response ($service$endpoint) status=${response.statusCode}',
      );
      print('📦 Response data: ${response.data}');

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        print('✅ Successfully joined trip with ID: $tripDepartureId');
        return true;
      } else {
        print('❌ HTTP error: status=${response.statusCode}');
        throw Exception(
          'Failed to join trip: status=${response.statusCode}',
        );
      }
    } catch (e, stack) {
      print('💥 [TripAPI] Exception while joining trip: $e');
      print(stack);
      return false;
    }
  }

Future<bool> checkJoin(String tripDepartureId) async {
  final response = await apiClient.get(
    'trip',
    '/api/trip-members/check-join/$tripDepartureId',
  );

  if (response.statusCode != null &&
      response.statusCode! >= 200 &&
      response.statusCode! < 300) {
    dynamic payload = response.data;
    print('Check join trip payload: $payload');

    if (payload is Map && payload.containsKey('data')) {
      payload = payload['data'];
    }

    if (payload is Map<String, dynamic> &&
        payload.containsKey('isJoined')) {
      return payload['isJoined'] as bool;
    } else {
      throw Exception(
        'Unexpected check join payload shape: ${payload.runtimeType}',
      );
    }
  } else {
    throw Exception('Failed to check join trip: status=${response.statusCode}');
  }
}


}