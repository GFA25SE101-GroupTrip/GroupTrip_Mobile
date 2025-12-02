import 'package:group_trip/features/report/data/report_response.dart';

class ReportModel {
  final String id;
  final String userId;
  final String targetId;
  final String title;
  final String assignToRole;
  final String status;
  final String? receiverName;
  final String? tripId;
  final String? tripName;
  final String? createTime;
  ReportModel({
    required this.id,
    required this.userId,
    required this.targetId,
    required this.title,
    required this.assignToRole,
    required this.status,
    required this.receiverName,
    this.tripId,
    this.tripName,
    this.createTime,
  });
  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      targetId: json['targetId'] as String,
      assignToRole: json['assignToRole'] as String,
      title: json['title'] as String,
      status: json['status'] as String,
      receiverName: json['receiverName'] as String,
      tripId: json['tripId'] as String?,
      tripName: json['tripName'] as String?,
      createTime: json['createTime'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'targetId': targetId,
      'title': title,
      'status': status,
      'assignToRole': assignToRole,
      'receiverName': receiverName,
      'tripId': tripId,
      'tripName': tripName,
      'createTime': createTime,
    };
  }
}



