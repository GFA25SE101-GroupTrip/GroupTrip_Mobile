import 'package:dio/dio.dart';
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
  Future<Map<String, dynamic>> joinTrip(String tripDepartureId) async {
  final endpoint =
      '/api/trip-members?tripDepartureId=$tripDepartureId';

  final service = 'trip';

  try {
    final response = await apiClient.post(service, endpoint);

    return {
      'success': true,
      'message': 'Tham gia chuyến đi thành công',
    };
  } on DioException catch (e) {
    // 🔥 ĐÂY là chỗ đọc message backend
    final data = e.response?.data;

    String errorCode = 'Bad request!';
    String errorMessage = 'Không thể tham gia chuyến này';

    if (data is Map<String, dynamic>) {
      errorCode = data['errorCode'] ?? errorCode;
      errorMessage = data['errorMessage'] ?? errorMessage;
    }

    print('💥 Join trip error ($errorCode): $errorMessage');

    return {
      'success': false,
      'errorCode': errorCode,
      'errorMessage': errorMessage,
    };
  } catch (e) {
    // fallback cho lỗi khác (network, timeout…)
    return {
      'success': false,
      'errorCode': 'Exception',
      'errorMessage': e.toString(),
    };
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



Future<List<TripModel>> fetchTripsByName(String name) async {
    final endpoint = '/api/trips/name';
    final queryParams = {'name': name};
    
    final response = await apiClient.getWithParams('trip', endpoint, queryParameters: queryParams);
    
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      dynamic payload = response.data;
      print('Trips by name payload: $payload');
      if (payload is Map && payload.containsKey('data')) {
        payload = payload['data'];
      }

      if (payload is List) {
        return payload
            .map((item) => TripModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Unexpected trips by name payload shape: ${payload.runtimeType}',
        );
      }
    } else {
      throw Exception('Failed to load trips by name: status=${response.statusCode}');
    }
  }


Future<List<TripModel>> fetchTripsByDate(String fromDate) async {
    final endpoint = '/api/trips/by-date';
    final queryParams = {'fromDate': fromDate};
    
    final response = await apiClient.getWithParams('trip', endpoint, queryParameters: queryParams);
    
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      dynamic payload = response.data;
      print('Trips by date payload: $payload');
      if (payload is Map && payload.containsKey('data')) {
        payload = payload['data'];
      }

      if (payload is List) {
        return payload
            .map((item) => TripModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Unexpected trips by date payload shape: ${payload.runtimeType}',
        );
      }
    } else {
      throw Exception('Failed to load trips by date: status=${response.statusCode}');
    }
  }

Future<void> userChooseInsurance(
  String tripDepartureId,
  String insuranceId,
) async {
  final endpoint =
      '/api/insurance/user-choose/$insuranceId/$tripDepartureId';

  final response = await apiClient.put('trip', endpoint);

  if (response.statusCode != null &&
      response.statusCode! >= 200 &&
      response.statusCode! < 300) {
    print('Successfully chose insurance for trip departure $tripDepartureId');
  } else {
    throw Exception(
      'Failed to choose insurance: status=${response.statusCode}',
    );
  }
}


}