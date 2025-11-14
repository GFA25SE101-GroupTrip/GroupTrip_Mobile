import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/features/trip/data/trip_rel_model.dart';

class TripRemoteDataSource {
  final ApiClient apiClient;
  TripRemoteDataSource({required this.apiClient});

  Future<List<TripModel>> fetchTrips() async {
    final response = await apiClient.get('trip','/api/trips');
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
}
