class ChatMember {
  final String travellerId;
  final String travellerName;
  final String imgUrl;
  final String roleInTrip;
  final String? memberStatus;
  final String? joinAt;

  ChatMember({
    required this.travellerId,
    required this.travellerName,
    required this.imgUrl,
    required this.roleInTrip,
    this.memberStatus,
    this.joinAt,
  });

  factory ChatMember.fromJson(Map<String, dynamic> json) {
    return ChatMember(
      travellerId: json['travellerId'] as String? ?? '',
      travellerName: json['travellerName'] as String? ?? '',
      imgUrl: json['img_url'] as String? ?? '',
      roleInTrip: json['roleInTrip'] as String? ?? '',
      memberStatus: json['memberStatus'] as String?,
      joinAt: json['joinAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'travellerId': travellerId,
      'travellerName': travellerName,
      'img_url': imgUrl,
      'roleInTrip': roleInTrip,
      'memberStatus': memberStatus,
      'joinAt': joinAt,
    };
  }

  ChatMember copyWith({
    String? travellerId,
    String? travellerName,
    String? imgUrl,
    String? roleInTrip,
    String? memberStatus,
    String? joinAt,
  }) {
    return ChatMember(
      travellerId: travellerId ?? this.travellerId,
      travellerName: travellerName ?? this.travellerName,
      imgUrl: imgUrl ?? this.imgUrl,
      roleInTrip: roleInTrip ?? this.roleInTrip,
      memberStatus: memberStatus ?? this.memberStatus,
      joinAt: joinAt ?? this.joinAt,
    );
  }
}