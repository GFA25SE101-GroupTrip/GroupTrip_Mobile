import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/features/account/representative/data/rep_model.dart';
import 'package:group_trip/features/trip/data/trip_rel_model.dart';

class RepRemoteDataSource {
  final ApiClient apiClient;

  RepRemoteDataSource({required this.apiClient});

  Future<List<RepModel>> fetchTours() async {
    // Log request for debugging so we can confirm network activity
    // ignore: avoid_print
    print('➡️ [RepAPI] GET /representative/tours -> service=representative');
    final response = await apiClient.get('user', '/api/profiles/representative');
    // ignore: avoid_print
    print(
      '⬅️ [RepAPI] GET /representative/tours status=${response.statusCode} data=${response.data}',
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      // The backend wraps response in { data: [ ... ] } — handle that shape.
      dynamic payload = response.data;
      if (payload is Map && payload.containsKey('data')) {
        payload = payload['data'];
      }

      if (payload is List) {
        return payload
            .map((item) => RepModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Unexpected tours payload shape: ${payload.runtimeType}',
        );
      }
    } else {
      throw Exception('Failed to load tours: status=${response.statusCode}');
    }
  }


  Future<List<TripModel>> fetchRepresentativeTrips(String repId) async {
    print('➡️ [RepAPI] GET /representative/$repId/trips -> service=representative');
    final response = await apiClient.get('trip', '/api/trips/creator', queryParameters: {
      'creatorId': repId,
    });
    print(
      '⬅️ [RepAPI] GET /representative/$repId/trips status=${response.statusCode} data=${response.data}',
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      dynamic payload = response.data;
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
  
}