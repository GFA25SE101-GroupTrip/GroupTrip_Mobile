
import 'package:group_trip/features/trip/data/trip_departure_model.dart';
import 'package:group_trip/features/trip/data/trip_feedback.dart';
import 'package:group_trip/features/trip/data/trip_image.dart';
import 'package:group_trip/features/trip/data/trip_rule.dart';
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
  final TripRule? tripRules;

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
    int _parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is double) return v.toInt();
      try {
        return int.parse(v.toString());
      } catch (_) {
        return 0;
      }
    }

    String _stringify(dynamic v) {
      if (v == null) return '';
      if (v is String) return v;
      if (v is num) return v.toString();
      if (v is Map) {
        // common keys to try
        final keys = ['url', 'img', 'path', 'image', 'file', 'name'];
        for (final k in keys) {
          if (v.containsKey(k) && v[k] != null) return v[k].toString();
        }
        if (v.containsKey('id')) return v['id'].toString();
        return v.values.isNotEmpty ? v.values.first.toString() : '';
      }
      return v.toString();
    }

    List<dynamic> _toList(dynamic v) {
      if (v == null) return <dynamic>[];
      if (v is List) return v;
      if (v is Map && v['data'] is List) return v['data'] as List<dynamic>;
      return [v];
    }

    return TripModel(
      id: _stringify(json['id']),
      creatorId: _stringify(json['creatorId']),
      creatorName: _stringify(json['creatorName']), // nullable-ish
      creatorImg: _stringify(json['creator_Img']), // nullable-ish
      userCustomID: _stringify(json['userCustomID']),
      baseTripId: _stringify(json['baseTripId']),
      isCustom: json['isCustom'] ?? false,
      name: _stringify(json['name']),
      fromDestination: _stringify(json['fromDestination']),
      fromLongtitude: json['fromLongtitude']?.toDouble(),
      fromLatitude: json['fromLatitude']?.toDouble(),
      finalLongtitude: json['finalLongtitude']?.toDouble(),
      finalLatitude: json['finalLatitude']?.toDouble(),
      finalDestination: _stringify(json['finalDestination']),
      description: _stringify(json['description']),
      status: _stringify(json['status']),
      minUsers: _parseInt(json['minUsers']),
      maxUsers: _parseInt(json['maxUsers']),
      avarageRating: (json['avarageRating'] ?? 0).toDouble(),
        tripDepartures: _toList(json['tripDepartures'])
          .where((e) => e != null && e is Map)
          .map((e) => TripDeparture.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
        tripSegments: _toList(json['tripSegments'])
          .where((e) => e != null && e is Map)
          .map((e) => TripSegment.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
        tripTagRelations: _toList(json['tripTagRelations'])
          .where((e) => e != null && e is Map)
          .map((e) => TripTagRelation.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
        tripImages: _toList(json['tripImages'])
          .where((e) => e != null && e is Map)
          .map((e) => TripImage.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
        tripFeedbacks: _toList(json['tripFeedbacks'])
          .where((e) => e != null && e is Map)
          .map((e) => TripFeedback.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      tripRules: json['tripRules'] != null ? TripRule.fromJson(Map<String, dynamic>.from(json['tripRules'])) : null,
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
