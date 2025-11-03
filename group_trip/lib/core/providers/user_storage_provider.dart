import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/secure_storage_provider.dart';
import 'package:group_trip/features/auth/data/user_model.dart';
import 'package:group_trip/features/auth/providers/user_provider.dart';

final userFromStorageProvider = FutureProvider<UserResponse?>((ref) async {
  // Watch auth state so this provider refreshes when login/logout occurs
  ref.watch(authNotifierProvider);
  final storage = ref.read(secureStorageProvider);
  return await storage.getUserResponseFromJson();
});
