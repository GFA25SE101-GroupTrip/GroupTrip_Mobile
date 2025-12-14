import 'dart:io';

import 'package:group_trip/features/mytrip/data/mytrip_api.dart';
import 'package:group_trip/features/mytrip/data/mytrip_model.dart';
import 'package:group_trip/features/mytrip/data/mytriptracking_model.dart';

class MyTripRepository {
  final MyTripRemoteDataSource remoteDataSource;
  MyTripRepository({required this.remoteDataSource});
  
  Future<List<MyTripModel>> fetchMyTrips({String status = 'UpComming'}) async {
    return await remoteDataSource.fetchMyTrips(status: status);
  }

  Future<TrackingRoute> fetchTrackingRoute(String departureId) async {
    return await remoteDataSource.fetchTrackingRoute(departureId);
  }
  
  Future<void> outTrip(String tripDepartureId) async {
    await remoteDataSource.outTrip(tripDepartureId);
  }

  Future<void> rejoinTrip(String tripDepartureId) async {
    await remoteDataSource.rejoinTrip(tripDepartureId);
  }
  

  Future<void> payToTrip(String tripDepartureId) async {
    await remoteDataSource.payToTrip(tripDepartureId);
  }

  Future<void> evaluateTrip(String tripId, int rating, String comment, List<File> images) async {
    await remoteDataSource.addFeedback(tripId: tripId, rating: rating, comment: comment, images: images);
  }
  // Define methods for fetching and managing trip data
}