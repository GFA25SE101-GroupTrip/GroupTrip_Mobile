class ReportResponse {
  final String id;
  final String userId;
  final String? targetId;
  final String title;
  final String assignToRole;
  final String content;
  final String status;
  final String type;
  final String receiverName;

  final String? tripId;
  final String? tripName;
  final String? createdTime;

  // thêm mới
  final String? senderName;
  final String? senderAvatar;
  final String? receiverAvatar;

  final List<dynamic> attach;
  final ResponseModel? responseReportModel;

  ReportResponse({
    required this.id,
    required this.userId,
    this.targetId,
    required this.title,
    required this.assignToRole,
    required this.content,
    required this.status,
    required this.type,
    required this.receiverName,
    this.tripId,
    this.tripName,
    this.createdTime,
    this.senderName,
    this.senderAvatar,
    this.receiverAvatar,
    required this.attach,
    this.responseReportModel,
  });

  factory ReportResponse.fromJson(Map<String, dynamic> json) {
    return ReportResponse(
      id: json['id'] ?? "",
      userId: json['userId'] ?? "",
      targetId: json['targetId'], // nullable
      title: json['title'] ?? "",
      assignToRole: json['assignToRole'] ?? "",
      content: json['content'] ?? "",
      status: json['status'] ?? "",
      type: json['type'] ?? "",
      receiverName: json['receiverName'] ?? "",

      tripId: json['tripId'],
      tripName: json['tripName'],
      createdTime: json['createdTime'],

      senderName: json['senderName'],
      senderAvatar: json['senderAvatar'],
      receiverAvatar: json['receiverAvatar'],

      attach: json['attach'] != null
          ? List<dynamic>.from(json['attach'])
          : [],

      responseReportModel: json['responseReportModel'] != null
          ? ResponseModel.fromJson(json['responseReportModel'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "targetId": targetId,
      "title": title,
      "assignToRole": assignToRole,
      "content": content,
      "status": status,
      "type": type,
      "receiverName": receiverName,

      "tripId": tripId,
      "tripName": tripName,
      "createdTime": createdTime,

      "senderName": senderName,
      "senderAvatar": senderAvatar,
      "receiverAvatar": receiverAvatar,

      "attach": attach,
      "responseReportModel": responseReportModel?.toJson(),
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
  final List<dynamic> attachments;

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
      id: json['id'] ?? "",
      requestId: json['requestId'] ?? "",
      title: json['title'] ?? "",
      content: json['content'] ?? "",
      responsederName: json['responsederName'] ?? "",
      createTime: json['createTime'] ?? "",
      createdBy: json['createdBy'] ?? "",
      attachments: json['attachments'] != null
          ? List<dynamic>.from(json['attachments'])
          : [],
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