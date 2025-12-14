

  class TrackingRoute {
    final String tripId;
    final String tripName;
    final String departureId;
    final String departureStatus;
    final String startDate;
    final String endDate;
    final List<SegmentTrackingViews> segmentTrackingViews;

    TrackingRoute({
      required this.tripId,
      required this.tripName,
      required this.departureId,
      required this.departureStatus,
      required this.startDate,
      required this.endDate,
      required this.segmentTrackingViews,
    });

    factory TrackingRoute.fromJson(Map<String, dynamic> json) {
      var segmentList = <SegmentTrackingViews>[];
      if (json['segmentTrackingViews'] != null) {
        segmentList = (json['segmentTrackingViews'] as List)
            .map((e) => SegmentTrackingViews.fromJson(e))
            .toList();
      }

      return TrackingRoute(
        tripId: json['tripId'] as String,
        tripName: json['tripName'] as String,
        departureId: json['departureId'] as String,
        departureStatus: json['departureStatus'] as String,
        startDate: json['startDate'] as String,
        endDate: json['endDate'] as String,
        segmentTrackingViews: segmentList,
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'tripId': tripId,
        'tripName': tripName,
        'departureId': departureId,
        'departureStatus': departureStatus,
        'startDate': startDate,
        'endDate': endDate,
        'segmentTrackingViews': segmentTrackingViews.map((e) => e.toJson()).toList(),
      };
    }
  }
  class SegmentTrackingViews {
    final String segmentId;
    final String fromDestination;
    final String toDestination;
    final String? startTime;
    final String? endTime;
    final int orderInTrip;
    final String segmentPhase;
    final List<PoiTrackingViews> poiTrackingViews;

    SegmentTrackingViews({
      required this.segmentId,
      required this.fromDestination,
      required this.toDestination,
      required this.startTime,
      required this.endTime,
      required this.orderInTrip,
      required this.segmentPhase,
      required this.poiTrackingViews,
    });

    factory SegmentTrackingViews.fromJson(Map<String, dynamic> json) {
      var poiList = <PoiTrackingViews>[];
      if (json['poiTrackingViews'] != null) {
        poiList = (json['poiTrackingViews'] as List)
            .map((e) => PoiTrackingViews.fromJson(e))
            .toList();
      }

      return SegmentTrackingViews(
        segmentId: json['segmentId'] as String,
        fromDestination: json['fromDestination'] as String,
        toDestination: json['toDestination'] as String,
        startTime: json['startTime'] as String?,
        endTime: json['endTime'] as String?,
        orderInTrip: json['orderInTrip'] as int,
        segmentPhase: json['segmentPhase'] as String,
        poiTrackingViews: poiList,
      );
    }
  
    Map<String, dynamic> toJson() {
      return {
        'segmentId': segmentId,
        'fromDestination': fromDestination,
        'toDestination': toDestination,
        'startTime': startTime,
        'endTime': endTime,
        'orderInTrip': orderInTrip,
        'segmentPhase': segmentPhase,
        'poiTrackingViews': poiTrackingViews.map((e) => e.toJson()).toList(),
      };
    }
    }
class PoiTrackingViews {
    final String poiId;
    final String name;
    final int orderInSegment;
    final String poiPhase;
    final List<ActivityTrackingViews> activityTrackingViews;

    PoiTrackingViews({
      required this.poiId,
      required this.name,
      required this.orderInSegment,
      required this.poiPhase,
      required this.activityTrackingViews,
    });

    factory PoiTrackingViews.fromJson(Map<String, dynamic> json) {
      var activityList = <ActivityTrackingViews>[];
      if (json['activityTrackingViews'] != null) {
        activityList = (json['activityTrackingViews'] as List)
            .map((e) => ActivityTrackingViews.fromJson(e))
            .toList();
      }

      return PoiTrackingViews(
        poiId: json['poiId'] as String,
        name: json['name'] as String,
        orderInSegment: json['orderInSegment'] as int,
        poiPhase: json['poiPhase'] as String,
        activityTrackingViews: activityList,
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'poiId': poiId,
        'name': name,
        'orderInSegment': orderInSegment,
        'poiPhase': poiPhase,
        'activityTrackingViews': activityTrackingViews.map((e) => e.toJson()).toList(),
      };
    }
  }

  class ActivityTrackingViews {
    final String activityId;
    final String name;
    final String activityPhase;

    ActivityTrackingViews({
      required this.activityId,
      required this.name,
      required this.activityPhase,
    });

    factory ActivityTrackingViews.fromJson(Map<String, dynamic> json) {
      return ActivityTrackingViews(
        activityId: json['activityId'] as String,
        name: json['name'] as String,
        activityPhase: json['activityPhase'] as String,
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'activityId': activityId,
        'name': name,
        'activityPhase': activityPhase,
      };
    }
  }
  