
import 'package:group_trip/features/trip/data/trip_departure_model.dart';
import 'package:group_trip/features/trip/data/trip_feedback.dart';
import 'package:group_trip/features/trip/data/trip_image.dart';
import 'package:group_trip/features/trip/data/trip_segment.dart';
import 'package:group_trip/features/trip/data/trip_tag_relation.dart';
class TripModel {
  final String id;
  final String creatorId;
  final String? creatorName;
  final String? creatorImg;
  final String? userCustomID;
  final String? baseTripId;
  final bool isCustom;
  final String name;
  final String fromDestination;
  final double? fromLongtitude;
  final double? fromLatitude;
  final String finalDestination;
  final double? finalLongtitude;
  final double? finalLatitude;
  final String description;
  final String status;
  final int minUsers;
  final int maxUsers;
  final double avarageRating;
  final List<TripDeparture> tripDepartures;
  final List<TripSegment> tripSegments;
  final List<TripTagRelation> tripTagRelations;
  final List<TripImage> tripImages;
  final List<TripFeedback> tripFeedbacks;
  final String? tripRules;

  TripModel({
    required this.id,
    required this.creatorId,
     this.creatorName,
     this.creatorImg,
    this.userCustomID,
    this.baseTripId,
    required this.isCustom,
    required this.name,
    required this.fromDestination,
    this.fromLongtitude,
    this.fromLatitude,
    required this.finalDestination,
    this.finalLongtitude,
    this.finalLatitude,
    required this.description,
    required this.status,
    required this.minUsers,
    required this.maxUsers,
    required this.avarageRating,
    required this.tripDepartures,
    required this.tripSegments,
    required this.tripTagRelations,
    required this.tripImages,
    required this.tripFeedbacks,
    this.tripRules,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'],
      creatorId: json['creatorId'],
       creatorName: json['creatorName'] as String?, // 👈 nullable
    creatorImg: json['creator_Img'] as String?,  // 👈 nullable
      userCustomID: json['userCustomID'],
      baseTripId: json['baseTripId'],
      isCustom: json['isCustom'] ?? false,
      name: json['name'],
      fromDestination: json['fromDestination'],
      fromLongtitude: json['fromLongtitude']?.toDouble(),
      fromLatitude: json['fromLatitude']?.toDouble(),
      finalDestination: json['finalDestination'],
      finalLongtitude: json['finalLongtitude']?.toDouble(),
      finalLatitude: json['finalLatitude']?.toDouble(),
      description: json['description'],
      status: json['status'],
      minUsers: json['minUsers'] ?? 0,
      maxUsers: json['maxUsers'] ?? 0,
      avarageRating: (json['avarageRating'] ?? 0).toDouble(),
      tripDepartures: (json['tripDepartures'] as List<dynamic>?)
              ?.map((e) => TripDeparture.fromJson(e))
              .toList() ??
          [],
      tripSegments: (json['tripSegments'] as List<dynamic>?)
              ?.map((e) => TripSegment.fromJson(e))
              .toList() ??
          [],
      tripTagRelations: (json['tripTagRelations'] as List<dynamic>?)
              ?.map((e) => TripTagRelation.fromJson(e))
              .toList() ??
          [],
      tripImages: (json['tripImages'] as List<dynamic>?)
              ?.map((e) => TripImage.fromJson(e))
              .toList() ??
          [],
      tripFeedbacks: (json['tripFeedbacks'] as List<dynamic>?)
              ?.map((e) => TripFeedback.fromJson(e))
              .toList() ??
          [],
      tripRules: json['tripRules'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'creatorId': creatorId,
        'creatorName': creatorName,
        'creator_Img': creatorImg,
        'userCustomID': userCustomID,
        'baseTripId': baseTripId,
        'isCustom': isCustom,
        'name': name,
        'fromDestination': fromDestination,
        'fromLongtitude': fromLongtitude,
        'fromLatitude': fromLatitude,
        'finalDestination': finalDestination,
        'finalLongtitude': finalLongtitude,
        'finalLatitude': finalLatitude,
        'description': description,
        'status': status,
        'minUsers': minUsers,
        'maxUsers': maxUsers,
        'avarageRating': avarageRating,
        'tripDepartures': tripDepartures.map((e) => e.toJson()).toList(),
        'tripSegments': tripSegments.map((e) => e.toJson()).toList(),
        'tripTagRelations': tripTagRelations.map((e) => e.toJson()).toList(),
        'tripImages': tripImages.map((e) => e.toJson()).toList(),
        'tripFeedbacks': tripFeedbacks.map((e) => e.toJson()).toList(),
        'tripRules': tripRules,
      };
}
