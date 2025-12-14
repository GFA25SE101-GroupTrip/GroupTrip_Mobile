import 'dart:io';

import 'package:dio/dio.dart';
import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/features/mytrip/data/mytrip_model.dart';
import 'package:group_trip/features/mytrip/data/mytriptracking_model.dart';

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
        return payload.map((item) {
          final itemMap = Map<String, dynamic>.from(item as Map);
          return MyTripModel.fromJson(itemMap);
        }).toList();
      } else {
        throw Exception(
          'Unexpected my trips payload shape: ${payload.runtimeType}',
        );
      }
    } else {
      throw Exception('Failed to load my trips: status=${response.statusCode}');
    }
  } 
  

  Future<TrackingRoute> fetchTrackingRoute(String departureId) async {
    final response = await api.get(
      'trip',
      '/api/trip-members/tracking-route/$departureId',
    );
    if(response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      dynamic payload = response.data;
      print('Tracking route payload: $payload');
      
      // Handle the response structure
      if (payload is Map && payload.containsKey('data')) {
        payload = payload['data'];
      }
      
      if (payload is Map) {
        final payloadMap = Map<String, dynamic>.from(payload);
        return TrackingRoute.fromJson(payloadMap);
      } else {
        throw Exception(
          'Unexpected tracking route payload shape: ${payload.runtimeType}',
        );
      }
    } else {
      throw Exception('Failed to load tracking route: status=${response.statusCode}');
    }
  }


  Future<void> outTrip(String tripDepartureId) async {
    final response = await api.put(
      'trip',
      '/api/trip-members/out-trip/$tripDepartureId',
    );
    if(response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw Exception('Failed to out trip: status=${response.statusCode}');
    }
  }


  Future<void> rejoinTrip(String tripDepartureId) async {
    final response = await api.put(
      'trip',
      '/api/trip-members/rejoin/$tripDepartureId',
    );
    if(response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw Exception('Failed to rejoin trip: status=${response.statusCode}');
    }
  }

  Future<void> payToTrip(String tripDepartureId) async {
    try {
      final response = await api.post(
        'payment',
        '/api/payment/paytotrip$tripDepartureId',
      );
      if(response.statusCode == null ||
          response.statusCode! < 200 ||
          response.statusCode! >= 300) {
        throw Exception('Failed to pay to trip: status=${response.statusCode}, message=${response.data}');
      }
    } catch (e) {
      print('PayToTrip error: $e');
      rethrow;
    }
  }

  Future<void> addFeedback({
    required String tripId,
    required String comment,
    required int rating,
    List<File>? images, // optional
  }) async {
    try {
      final formData = FormData.fromMap({
        'Comment': comment,
        'Rating': rating,
        if (images != null)
          'Images': await Future.wait(
            images.map((img) async {
              return await MultipartFile.fromFile(
                img.path,
                filename: img.path.split('/').last,
              );
            }),
          ),
      });

      final response = await api.postFormData(
        'trip',
        '/api/trips/add-feedback/$tripId',
        data: formData,
      );

      if (response.statusCode == null ||
          response.statusCode! < 200 ||
          response.statusCode! >= 300) {
        throw Exception(
          'Failed to add feedback: status=${response.statusCode}, message=${response.data}',
        );
      }
    } catch (e) {
      print('AddFeedback error: $e');
      rethrow;
    }
  }



}