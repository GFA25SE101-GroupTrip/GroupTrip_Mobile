class TripMember {
  final String? memberId;
  final String? memberName;
  final String? imgUrl;
  final int? paidAmount;
  final int? remainAmount;
  final String? tripMemberStatus;

  TripMember({
    this.memberId,
    this.memberName,
    this.imgUrl,
    this.paidAmount,
    this.remainAmount,
    this.tripMemberStatus,
  });

  factory TripMember.fromJson(Map<String, dynamic> json) {
    int? _toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is double) return v.toInt();
      try {
        return int.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    return TripMember(
      memberId: json['memberId'] as String?,
      memberName: json['memberName'] as String?,
      imgUrl: json['imgUrl'] as String?,
      paidAmount: _toInt(json['paidAmount']),
      remainAmount: _toInt(json['remainAmount']),
      tripMemberStatus: json['tripMemberStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'memberName': memberName,
        'imgUrl': imgUrl,
        'paidAmount': paidAmount,
        'remainAmount': remainAmount,
        'tripMemberStatus': tripMemberStatus,
      };
}
