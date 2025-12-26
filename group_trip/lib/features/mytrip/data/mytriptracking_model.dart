

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

    // Parse ngày từ định dạng ISO 8601
    String getFormattedStartDate() {
      return _formatDateFromIso8601(startDate);
    }

    String getFormattedStartTime() {
      return _formatTimeFromIso8601(startDate);
    }

    String getFormattedEndDate() {
      return _formatDateFromIso8601(endDate);
    }

    String getFormattedEndTime() {
      return _formatTimeFromIso8601(endDate);
    }

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
      this.startTime,
      this.endTime,
      required this.orderInTrip,
      required this.segmentPhase,
      required this.poiTrackingViews,
    });

    // Parse ngày giờ từ định dạng ISO 8601
    String getFormattedStartDate() {
      return startTime != null ? _formatDateFromIso8601(startTime!) : '';
    }

    String getFormattedStartTime() {
      return startTime != null ? _formatTimeFromIso8601(startTime!) : '';
    }

    String getFormattedEndDate() {
      return endTime != null ? _formatDateFromIso8601(endTime!) : '';
    }

    String getFormattedEndTime() {
      return endTime != null ? _formatTimeFromIso8601(endTime!) : '';
    }

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
    final String? startAt;
    final String? endAt;
    final List<ActivityTrackingViews> activityTrackingViews;

    PoiTrackingViews({
      required this.poiId,
      required this.name,
      required this.orderInSegment,
      required this.poiPhase,
      this.startAt,
      this.endAt,
      required this.activityTrackingViews,
    });

    // Parse ngày giờ từ định dạng ISO 8601
    String getFormattedStartDate() {
      return startAt != null ? _formatDateFromIso8601(startAt!) : '';
    }

    String getFormattedStartTime() {
      return startAt != null ? _formatTimeFromIso8601(startAt!) : '';
    }

    String getFormattedEndDate() {
      return endAt != null ? _formatDateFromIso8601(endAt!) : '';
    }

    String getFormattedEndTime() {
      return endAt != null ? _formatTimeFromIso8601(endAt!) : '';
    }

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
        startAt: json['startAt'] as String?,
        endAt: json['endAt'] as String?,
        activityTrackingViews: activityList,
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'poiId': poiId,
        'name': name,
        'orderInSegment': orderInSegment,
        'poiPhase': poiPhase,
        'startAt': startAt,
        'endAt': endAt,
        'activityTrackingViews': activityTrackingViews.map((e) => e.toJson()).toList(),
      };
    }
  }

  class ActivityTrackingViews {
    final String activityId;
    final String name;
    final String activityPhase;
    final int? duration;

    ActivityTrackingViews({
      required this.activityId,
      required this.name,
      required this.activityPhase,
      this.duration = 0,
    });

    factory ActivityTrackingViews.fromJson(Map<String, dynamic> json) {
      return ActivityTrackingViews(
        activityId: json['activityId'] as String,
        name: json['name'] as String,
        activityPhase: json['activityPhase'] as String,
        duration: json['duration'] as int? ?? 0,
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'activityId': activityId,
        'name': name,
        'activityPhase': activityPhase,
        'duration': duration,
      };
    }
  }

  // Helper functions để parse ngày giờ từ ISO 8601
  String _formatDateFromIso8601(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      // Định dạng: dd/MM/yyyy
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
    } catch (e) {
      return dateTimeString;
    }
  }

  String _formatTimeFromIso8601(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      // Định dạng: HH:mm:ss
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeString;
    }
  }
  