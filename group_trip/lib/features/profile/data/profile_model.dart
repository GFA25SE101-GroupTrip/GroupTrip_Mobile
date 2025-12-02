
class ProfileModel {
  final String userProfileId;
  final String userId;
  final String bio;
  final String imageUrl;
  final List<String>? tags;
  final DateTime createdTime;
  ProfileModel({
    required this.userProfileId,
    required this.userId,
    required this.bio,
    required this.imageUrl,
    this.tags,
    required this.createdTime,
  });
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    // Support multiple possible key names and tolerate nulls from backend.
    String _getString(dynamic v) => v == null ? '' : v.toString();

    final userProfileId = _getString(json['userProfileId'] ?? json['user_profile_id']);
    final userId = _getString(json['userId'] ?? json['user_id']);
    final bio = _getString(json['bio']);
    final imageUrl = _getString(json['imageUrl'] ?? json['image_url'] ?? json['avatar']);

    List<String>? tags;
    if (json['tags'] != null) {
      try {
        tags = List<String>.from((json['tags'] as List).map((e) => e.toString()));
      } catch (_) {
        tags = null;
      }
    }

    DateTime createdTime;
    try {
      final ct = json['created_time'] ?? json['createdTime'] ?? json['createdAt'];
      if (ct != null) {
        createdTime = DateTime.parse(ct.toString());
      } else {
        createdTime = DateTime.now();
      }
    } catch (_) {
      createdTime = DateTime.now();
    }

    return ProfileModel(
      userProfileId: userProfileId,
      userId: userId,
      bio: bio,
      imageUrl: imageUrl,
      tags: tags,
      createdTime: createdTime,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userProfileId': userProfileId,
      'userId': userId,
      'bio': bio,
      'image_url': imageUrl,
      'tags': tags,
      'created_time': createdTime.toIso8601String(),
    };
  }
}


class UserInformation {
  final String id;
  final String fullName;
  final String email;
  final String status;
  final String phoneNumber;
  final String role;
  final String bankAccount;
  final String bankName;
  final DateTime createdTime;
  final String? gender;
  final DateTime dayOfBirth;
  UserInformation({
    required this.id,
    required this.fullName,
    required this.email,
    required this.status,
    required this.phoneNumber,
    required this.role,
    required this.bankAccount,
    required this.bankName,
    required this.createdTime,
    this.gender,
    required this.dayOfBirth,
  });
  factory UserInformation.fromJson(Map<String, dynamic> json) {
    // Support multiple possible key names and tolerate nulls from backend.
    String _getString(dynamic v) => v == null ? '' : v.toString();

    final id = _getString(json['id']);
    final fullName = _getString(json['fullName'] ?? json['full_name']);
    final email = _getString(json['email']);
    final status = _getString(json['status']);
    final phoneNumber = _getString(json['phoneNumber'] ?? json['phone_number']);
    final role = _getString(json['role']);
    final bankAccount = _getString(json['bankAccount'] ?? json['bank_account']);
    final bankName = _getString(json['bankName'] ?? json['bank_name']);

    DateTime createdTime;
    try {
      final ct = json['created_time'] ?? json['createdTime'] ?? json['createdAt'];
      if (ct != null) {
        createdTime = DateTime.parse(ct.toString());
      } else {
        createdTime = DateTime.now();
      }
    } catch (_) {
      createdTime = DateTime.now();
    }
    String? gender;
    if (json['gender'] != null) {
      gender = _getString(json['gender']);
    } else {
      gender = null;
    }
    DateTime dayOfBirth;
    try {
      final dob = json['dayOfBirth'] ?? json['day_of_birth'];
      if (dob != null) {
        dayOfBirth = DateTime.parse(dob.toString());
      } else {
        dayOfBirth = DateTime.now();
      }
    } catch (_) {
      dayOfBirth = DateTime.now();
    }
    return UserInformation(
      id: id,
      fullName: fullName,
      email: email,
      status: status,
      phoneNumber: phoneNumber,
      role: role,
      bankAccount: bankAccount,
      bankName: bankName,
      createdTime: createdTime,
      gender: gender,
      dayOfBirth: dayOfBirth,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'status': status,
      'phoneNumber': phoneNumber,
      'role': role,
      'bankAccount': bankAccount,
      'bankName': bankName,
      'createdTime': createdTime.toIso8601String(),
      'gender': gender,
      'dayOfBirth': dayOfBirth.toIso8601String(),
    };
  }
}

