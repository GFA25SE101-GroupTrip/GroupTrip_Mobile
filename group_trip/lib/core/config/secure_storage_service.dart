import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:group_trip/features/auth/data/user_model.dart';

class SecureStorageService {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _fcmTokenKey = 'fcm_token';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Lưu token
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  // Lấy accessToken
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // Lấy refreshToken
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // Xóa token khi logout
  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  // Lưu FCM token
  Future<void> saveFcmToken(String fcmToken) async {
    await _storage.write(key: _fcmTokenKey, value: fcmToken);
  }

  // Lấy FCM token
  Future<String?> getFcmToken() async {
    return await _storage.read(key: _fcmTokenKey);
  }

  Future<void> saveUserInfor(UserResponse user) async {
    await _storage.write(key: 'user_id', value: user.userId);
    await _storage.write(key: 'user_name', value: user.userName);
    await _storage.write(key: 'user_status', value: user.status);
  }

  // Save whole user JSON (useful when backend returns more fields or tokens)
  Future<void> saveUserJson(Map<String, dynamic> userJson) async {
    final s = jsonEncode(userJson);
    await _storage.write(key: 'user_json', value: s);
  }

  // Read whole user JSON back as a Map (or null if not present)
  Future<Map<String, dynamic>?> getUserJson() async {
    final s = await _storage.read(key: 'user_json');
    if (s == null) return null;
    try {
      final m = jsonDecode(s) as Map<String, dynamic>;
      return m;
    } catch (_) {
      return null;
    }
  }


  Future<UserResponse?> getUserResponseFromJson() async {
    final m = await getUserJson();
    if (m == null) return null;
    // Try to be tolerant: backend may return different key names or omit some
    // optional fields. Map commonly-used keys to the UserResponse constructor
    try {
      final userId = (m['userId'] ?? m['id'] ?? m['user_id'] ?? '') as String;
      final userName = (m['userName'] ?? m['username'] ?? m['name'] ?? '') as String;
      final role = (m['role'] ?? '') as String;
      final status = (m['status'] ?? '') as String;
      final accessToken = (m['accessToken'] ?? m['access_token'] ?? '') as String;
      final refreshToken = (m['refreshToken'] ?? m['refresh_token'] ?? '') as String;

      // If nothing useful present, return null
      if (userId.isEmpty && userName.isEmpty && accessToken.isEmpty) return null;

      return UserResponse(
        userId: userId,
        userName: userName,
        role: role,
        status: status,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    } catch (_) {
      return null;
    }
  }

  // Clear stored user JSON
  Future<void> clearUserJson() async {
    await _storage.delete(key: 'user_json');
  }

  // Clear everything (tokens + user data)
  Future<void> clearAll() async {
    await clearUserJson();
    await clearTokens();
    await _storage.delete(key: _fcmTokenKey);
  }

}
