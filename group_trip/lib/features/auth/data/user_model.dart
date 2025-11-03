class UserModel {
  final String username;
  final String fullName;
  final String password;
  final String confirmPassword;
  final String email;
  final String bankAccount;
  final String bankName;
  final String role;

  UserModel({
    required this.username,
    required this.fullName,
    required this.password,
    required this.confirmPassword,
    required this.email,
    required this.bankAccount,
    required this.bankName,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] as String,
      fullName: json['fullName'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirmPassword'] as String,
      email: json['email'] as String,
      bankAccount: json['bankAccount'] as String,
      bankName: json['bankName'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullName': fullName,
      'password': password,
      'confirmPassword': confirmPassword,
      'email': email,
      'bankAccount': bankAccount,
      'bankName': bankName,
      'role': role,
    };
  }
}

class RoleModel {
  final String id;
  final String name;
  final String? normalizedName;
  final String fullName;
  final DateTime createdTime;

  RoleModel({
    required this.id,
    required this.name,
    this.normalizedName,
    required this.fullName,
    required this.createdTime,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      normalizedName: json['normalizedName'] as String?,
      fullName: json['fullName'] as String,
      createdTime: DateTime.parse(json['createdTime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'normalizedName': normalizedName,
      'fullName': fullName,
      'createdTime': createdTime.toIso8601String(),
    };
  }
}


class UserResponse {
  final String userId;
  final String userName;
  final String role;
  final String status;
  final String accessToken;
  final String refreshToken;

  UserResponse({
    required this.userId,
    required this.userName,
    required this.role,
    required this.status,
    required this.accessToken,
    required this.refreshToken,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'role': role,
      'status': status,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
