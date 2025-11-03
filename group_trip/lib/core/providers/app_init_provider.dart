import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/auth/providers/user_provider.dart';

final appInitProvider = FutureProvider<void>((ref) async {
  // gọi restoreSession để set auth state nếu có session
  await ref.read(authNotifierProvider.notifier).restoreSession();
});