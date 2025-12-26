class InvitedData {
  final String id;
  final String depatureId;
  final String tripName;
  final String tripImg;
  final String tripId;
  final String fromUserId;
  final String fromUserName;
  final String toUserName;
  final String toUserId;
  final String? title;
  final String content;
  final String invitationStatus;

  InvitedData({
    required this.id,
    required this.depatureId,
    required this.tripName,
    required this.tripImg,
    required this.tripId,
    required this.fromUserId,
    required this.fromUserName,
    required this.toUserName,
    required this.toUserId,
    this.title,
    required this.content,
    required this.invitationStatus,
  });

  factory InvitedData.fromJson(Map<String, dynamic> json) {
    return InvitedData(
      id: json['id'],
      depatureId: json['depatureId'],
      tripName: json['tripName'],
      tripImg: json['trip_Img'],
      tripId: json['tripId'],
      fromUserId: json['fromUserId'],
      fromUserName: json['fromUserName'],
      toUserName: json['toUserName'],
      toUserId: json['toUserId'],
      title: json['title'],
      content: json['content'],
      invitationStatus: json['invitationStatus'],
    );
  }
}


class UserSearch {
  final String userId;
  final String userName;
  final String email;
  final String img;
  UserSearch({
    required this.userId,
    required this.userName,
    required this.email,
    required this.img,
  });
  factory UserSearch.fromJson(Map<String, dynamic> json) {
    return UserSearch(
      userId: json['userId'],
      userName: json['userName'],
      email: json['email'],
      img: json['img'],
    );
  }
}