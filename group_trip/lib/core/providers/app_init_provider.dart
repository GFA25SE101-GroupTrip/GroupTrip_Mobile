import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/auth/providers/user_provider.dart';
import 'package:group_trip/features/profile/providers/profile_provider.dart';

final appInitProvider = FutureProvider<void>((ref) async {
  // gọi restoreSession để set auth state nếu có session
  await ref.read(authNotifierProvider.notifier).restoreSession();
  // Ensure profile notifier is constructed during app init so it can
  // fetch remote profile if a stored user exists. Without this read,
  // the `profileNotifierProvider` may never be created until UI watches it.
  try {
    ref.read(profileNotifierProvider);
    print('ℹ️ profileNotifierProvider requested during app init');
  } catch (e) {
    // non-fatal, just log
    print('⚠️ failed to request profileNotifierProvider during init: $e');
  }
});