
import 'package:group_trip/features/trip/data/trip_departure_model.dart';
import 'package:group_trip/features/trip/data/trip_feedback.dart';
import 'package:group_trip/features/trip/data/trip_image.dart';
import 'package:group_trip/features/trip/data/trip_rule.dart';
import 'package:group_trip/features/trip/data/trip_segment.dart';
import 'package:group_trip/features/trip/data/trip_tag_relation.dart';
import 'package:group_trip/features/trip/data/trip_insurance.dart';
class TripModel {
  final String id;
  final String creatorId;
  final String? creatorName;
  final String? creatorImg;
  final String? userCustomID;
  final String? baseTripId;
  final bool isCustom;
  final String name;
  final String baseTripName;
  final String? fromDestination;
  final String? fromLongtitude;
  final String? fromLatitude;
  final String? finalDestination;
  final String? finalLongtitude;
  final String? finalLatitude;
  final String description;
  final String status;
  final int minUsers;
  final int maxUsers;
  final double avarageRating;
  final String createdTime;
  final List<TripDeparture> tripDepartures;
  final List<TripSegment> tripSegments;
  final List<TripTagRelation> tripTagRelations;
  final List<TripImage> tripImages;
  final List<TripFeedback> tripFeedbacks;
  final TripRule? tripRules;
  final List<TripInsurance> insurances;

  TripModel({
    required this.id,
    required this.creatorId,
    this.creatorName,
    this.creatorImg,
    this.userCustomID,
    this.baseTripId,
    required this.baseTripName,
    required this.isCustom,
    required this.name,
    this.fromDestination,
    this.fromLongtitude,
    this.fromLatitude,
    this.finalDestination,
    this.finalLongtitude,
    this.finalLatitude,
    required this.description,
    required this.status,
    required this.minUsers,
    required this.maxUsers,
    required this.avarageRating,
    required this.createdTime,
    required this.tripDepartures,
    required this.tripSegments,
    required this.tripTagRelations,
    required this.tripImages,
    required this.tripFeedbacks,
    this.tripRules,
    required this.insurances,
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

    String? _stringifyNullable(dynamic v) {
      if (v == null) return null;
      if (v is String) return v;
      if (v is num) return v.toString();
      if (v is Map) {
        final keys = ['url', 'img', 'path', 'image', 'file', 'name'];
        for (final k in keys) {
          if (v.containsKey(k) && v[k] != null) return v[k].toString();
        }
        if (v.containsKey('id')) return v['id'].toString();
        return v.values.isNotEmpty ? v.values.first.toString() : null;
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
      creatorName: _stringifyNullable(json['creatorName']),
      creatorImg: _stringifyNullable(json['creator_Img']),
      userCustomID: _stringifyNullable(json['userCustomID']),
      baseTripId: _stringifyNullable(json['baseTripId']),
      baseTripName: _stringify(json['baseTripName']),
      isCustom: json['isCustom'] ?? false,
      name: _stringify(json['name']),
      fromDestination: _stringifyNullable(json['fromDestination']),
      fromLongtitude: _stringifyNullable(json['fromLongtitude']),
      fromLatitude: _stringifyNullable(json['fromLatitude']),
      finalLongtitude: _stringifyNullable(json['finalLongtitude']),
      finalLatitude: _stringifyNullable(json['finalLatitude']),
      finalDestination: _stringifyNullable(json['finalDestination']),
      description: _stringify(json['description']),
      status: _stringify(json['status']),
      minUsers: _parseInt(json['minUsers']),
      maxUsers: _parseInt(json['maxUsers']),
      avarageRating: (json['avarageRating'] ?? 0).toDouble(),
      createdTime: _stringify(json['createdTime']),
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
      insurances: _toList(json['insurances'])
          .where((e) => e != null && e is Map)
          .map((e) => TripInsurance.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'creatorId': creatorId,
        'creatorName': creatorName,
        'creator_Img': creatorImg,
        'userCustomID': userCustomID,
        'baseTripId': baseTripId,
        'baseTripName': baseTripName,
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
        'createdTime': createdTime,
        'tripDepartures': tripDepartures.map((e) => e.toJson()).toList(),
        'tripSegments': tripSegments.map((e) => e.toJson()).toList(),
        'tripTagRelations': tripTagRelations.map((e) => e.toJson()).toList(),
        'tripImages': tripImages.map((e) => e.toJson()).toList(),
        'tripFeedbacks': tripFeedbacks.map((e) => e.toJson()).toList(),
        'tripRules': tripRules,
        'insurances': insurances.map((e) => e.toJson()).toList(),
      };
}
