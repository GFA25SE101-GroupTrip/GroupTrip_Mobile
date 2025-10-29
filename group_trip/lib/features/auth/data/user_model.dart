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