class ChatMember {
  final String travellerId;
  final String travellerName;
  final String imgUrl;
  final String roleInTrip;
  final DateTime joinAt;
  ChatMember({
    required this.travellerId,
    required this.travellerName,
    required this.imgUrl,
    required this.roleInTrip,
    required this.joinAt,
  });
  factory ChatMember.fromJson(Map<String, dynamic> json) {
    return ChatMember(
      travellerId: json['travellerId'] as String,
      travellerName: json['travellerName'] as String,
      imgUrl: json['img_url'] as String,
      roleInTrip: json['roleInTrip'] as String,
      joinAt: DateTime.parse(json['joinAt'] as String
      
      ),
    );
  }
  Map <String, dynamic> toJson() {
    return {
      'travellerId': travellerId,
      'travellerName': travellerName,
      'img_url': imgUrl,
      'roleInTrip': roleInTrip,
      'joinAt': joinAt.toIso8601String(),
    };
  }
}