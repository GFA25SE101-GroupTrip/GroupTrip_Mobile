class ReportResponse {
  final String id;
  final String userId;
  final String targetId;
  final String title;
  final String status;
  final String receiverName;
  final String? tripId;
  final String? tripName;
  final String? createTime;
  final List<String> attach;
  final ResponseModel? responseReportModel;
  ReportResponse({
    required this.id,
    required this.userId,
    required this.targetId,
    required this.title,
    required this.status,
    required this.receiverName,
    this.tripId,
    this.tripName,
    this.createTime,
    required this.attach,
    this.responseReportModel,
  });
  factory ReportResponse.fromJson(Map<String, dynamic> json) {
    return ReportResponse(
      id: json['id'] as String,
      userId: json['userId'] as String,
      targetId: json['targetId'] as String,
      title: json['title'] as String,
      status: json['status'] as String,
      receiverName: json['receiverName'] as String,
      tripId: json['tripId'] as String?,
      tripName: json['tripName'] as String?,
      createTime: json['createTime'] as String?,
      attach: (json['attach'] as List<dynamic>)
          .map((item) => item as String)
          .toList(),
      responseReportModel: json['responseReportModel'] != null
          ? ResponseModel.fromJson(
              json['responseReportModel'] as Map<String, dynamic>)
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "targetId": targetId,
      "title": title,
      "status": status,
      "receiverName": receiverName,
      "tripId": tripId,
      "tripName": tripName,
      "createTime": createTime,
      "attach": attach,
      "responseReportModel":
          responseReportModel != null ? responseReportModel!.toJson() : null,
    };
  }
 
}

class ResponseModel {
  final String id;
  final String requestId;
  final String title;
  final String content;
  final String responsederName;
  final String createTime;
  final String createdBy;
  final List<String> attachments;
  ResponseModel({
    required this.id,
    required this.requestId,
    required this.title,
    required this.content,
    required this.responsederName,
    required this.createTime,
    required this.createdBy,
    required this.attachments,
  });
  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      id: json['id'] as String,
      requestId: json['requestId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      responsederName: json['responsederName'] as String,
      createTime: json['createTime'] as String,
      createdBy: json['createdBy'] as String,
      attachments: (json['attachments'] as List<dynamic>)
          .map((item) => item as String)
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "requestId": requestId,
      "title": title,
      "content": content,
      "responsederName": responsederName,
      "createTime": createTime,
      "createdBy": createdBy,
      "attachments": attachments,
    };
  }
}