import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/core/providers/api_client_provider.dart';
import 'package:group_trip/core/providers/user_storage_provider.dart';
import 'package:group_trip/features/auth/data/user_model.dart';
import 'package:group_trip/features/profile/data/profile_api.dart';
import 'package:group_trip/features/profile/data/profile_model.dart';
import 'package:group_trip/features/profile/domain/profile_repository.dart';



final profileRemoteDataSourceProvider = Provider((ref) {
  print('✅ profileRemoteDataSourceProvider initialized');
  return ProfileRemoteDataSource(api: ref.watch(apiClientProvider));
});

final profileRepositoryProvider = Provider((ref) {
  print('✅ profileRepositoryProvider initialized');
  return ProfileRepository(remoteDataSource: ref.watch(profileRemoteDataSourceProvider));
});


class ProfileNotifier extends StateNotifier<AsyncValue<ProfileModel?>> {
  final Ref ref;
  final ProfileRepository repository;

ProfileNotifier(this.ref, this.repository) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    final stored = await ref.read(userFromStorageProvider.future);
    if (stored != null) {
      await fetchUserProfile();
    } else {
      state = const AsyncData(null);
    }
  }
  Future<void> fetchUserProfile() async {
    state = const AsyncLoading();
    try {
      final profile = await repository.fetchUserProfile();
      state = AsyncData(profile);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<ProfileModel?>>((ref) {
  print('✅ profileNotifierProvider initialized');
  return ProfileNotifier(ref, ref.watch(profileRepositoryProvider));
});


/// A small view model for UI that merges local `UserResponse` (from storage)
/// and remote `ProfileModel`. UI should watch this provider to get a single
/// cohesive source of display data.
class ProfileView {
  final String displayName;
  final String subtitle;
  final String? imageUrl;
  final String? bio;
  final bool isUpdated;

  ProfileView({required this.displayName, required this.subtitle, this.imageUrl, this.bio, this.isUpdated = false});
}

final profileViewProvider = Provider<ProfileView?>((ref) {
  final userAsync = ref.watch(userFromStorageProvider);
  final profileAsync = ref.watch(profileNotifierProvider);
  bool isUpdated = false;
  UserResponse? user;
  if (userAsync is AsyncData<UserResponse?>) user = userAsync.value;

  ProfileModel? profile;
  if (profileAsync is AsyncData<ProfileModel?>) {
    profile = profileAsync.value;
    isUpdated = true;
  } 


  // Prefer remote profile when available for richer fields, but always use
  // local userName if present for displayName fallback.
  final displayName = user?.userName ?? (profile?.userId ?? 'Người dùng');
  final subtitle = user?.role ?? user?.status ?? (profile?.bio ?? 'Chưa có thông tin');
  final imageUrl = profile?.imageUrl;
  final bio = profile?.bio;

  // If neither source has meaningful data, return null so UI can show loading/fallback.
  if (user == null && profile == null) return null;

  return ProfileView(displayName: displayName, subtitle: subtitle, imageUrl: imageUrl, bio: bio, isUpdated: isUpdated);
});