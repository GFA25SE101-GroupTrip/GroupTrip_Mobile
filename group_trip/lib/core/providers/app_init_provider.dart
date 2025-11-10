import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/auth/providers/user_provider.dart';
import 'package:group_trip/features/profile/providers/profile_provider.dart';
import 'package:group_trip/features/wallet/providers/wallet_provider.dart';

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
  // Prefetch wallet so balance is available immediately on first screen
  try {
    // Read the Future (not the provider object) to await the fetch.
    await ref.read(walletModelProvider.future);
    print('ℹ️ walletModelProvider prefetched during app init');
  } catch (e) {
    print('⚠️ failed to prefetch wallet during init: $e');
  }
});