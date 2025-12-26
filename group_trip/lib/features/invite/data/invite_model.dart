class Invite {
  final String id;
  final String fromUserId;
  final String fromUserName;
  final String fromUserAvatar;
  final String tripId;
  final String tripName;
  final String tripImage;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // pending, accepted, rejected
  final DateTime createdAt;

  Invite({
    required this.id,
    required this.fromUserId,
    required this.fromUserName,
    required this.fromUserAvatar,
    required this.tripId,
    required this.tripName,
    required this.tripImage,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdAt,
  });

  factory Invite.fromJson(Map<String, dynamic> json) {
    return Invite(
      id: json['id'] ?? '',
      fromUserId: json['fromUserId'] ?? '',
      fromUserName: json['fromUserName'] ?? '',
      fromUserAvatar: json['fromUserAvatar'] ?? '',
      tripId: json['tripId'] ?? '',
      tripName: json['tripName'] ?? '',
      tripImage: json['tripImage'] ?? '',
      startDate: json['startDate'] is String
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      endDate: json['endDate'] is String
          ? DateTime.parse(json['endDate'])
          : DateTime.now(),
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] is String
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fromUserId': fromUserId,
    'fromUserName': fromUserName,
    'fromUserAvatar': fromUserAvatar,
    'tripId': tripId,
    'tripName': tripName,
    'tripImage': tripImage,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'status': status,
    'createdAt': createdAt.toIso8601String(),
  };
}
