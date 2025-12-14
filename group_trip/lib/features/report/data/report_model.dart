class ReportModel {
  final String id;
  final String userId;
  final String? targetId;
  final String title;
  final String assignToRole;
  final String status;
  final String? receiverName;
  final String? tripId;
  final String? tripName;
  final String? createdTime;

  // Optional fields from JSON (nên có)
  final String? senderName;
  final String? senderAvatar;
  final String? receiverAvatar;
  final String? type;

  ReportModel({
    required this.id,
    required this.userId,
    this.targetId,
    required this.title,
    required this.assignToRole,
    required this.status,
    this.receiverName,
    this.tripId,
    this.tripName,
    this.createdTime,
    this.senderName,
    this.senderAvatar,
    this.receiverAvatar,
    this.type,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] ?? "",
      userId: json['userId'] ?? "",
      targetId: json['targetId'],
      title: json['title'] ?? "",
      assignToRole: json['assignToRole'] ?? "",
      status: json['status'] ?? "",
      receiverName: json['receiverName'],
      tripId: json['tripId'],
      tripName: json['tripName'],
      createdTime: json['createdTime'], // đúng key
      senderName: json['senderName'],
      senderAvatar: json['senderAvatar'],
      receiverAvatar: json['receiverAvatar'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'targetId': targetId,
      'title': title,
      'assignToRole': assignToRole,
      'status': status,
      'receiverName': receiverName,
      'tripId': tripId,
      'tripName': tripName,
      'createdTime': createdTime,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'receiverAvatar': receiverAvatar,
      'type': type,
    };
  }
}
