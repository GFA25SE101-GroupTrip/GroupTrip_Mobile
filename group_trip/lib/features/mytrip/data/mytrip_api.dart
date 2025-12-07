import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/features/mytrip/data/mytrip_model.dart';

class MyTripRemoteDataSource {
  final ApiClient api;
  MyTripRemoteDataSource({required this.api});

  Future<List<MyTripModel>> fetchMyTrips({String status = 'UpComming'}) async {
    final response = await api.getWithParams(
      'trip',
      '/api/trip-members/filter-joined-trip',
      queryParameters: {'status': status},
    );
    if(response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      dynamic payload = response.data;
      print('MyTrips payload: $payload');
      if (payload is Map && payload.containsKey('data')) {
        payload = payload['data'];
      }

      if (payload is List) {
        return payload.map((item) => MyTripModel.fromJson(item)).toList();
      } else {
        throw Exception(
          'Unexpected my trips payload shape: ${payload.runtimeType}',
        );
      }
    } else {
      throw Exception('Failed to load my trips: status=${response.statusCode}');
    }
  }
}