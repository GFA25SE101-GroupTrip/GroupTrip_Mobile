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
  Future<void> updateUserProfile(String bio, String imageUrl) async {
    state = const AsyncLoading();
    try {
      await repository.updateUserProfile(bio, imageUrl);
      // Refresh profile after update
      final profile = await repository.fetchUserProfile();
      state = AsyncData(profile);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  Future<void> updateUserInformation(String userID,
    String fullname,
    String phonenumber,
    String bankAccount,
    String bankName) async {
    state = const AsyncLoading();
    try {
      await repository.updateUserInformation(userID, fullname, phonenumber, bankAccount, bankName);
      // Refresh profile after update
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
  final String userID;
  final String displayName;
  final String subtitle;
  final String? imageUrl;
  final String? bio;
  final bool isUpdated;
  final String? fullname;

  ProfileView({required this.userID, required this.displayName, required this.subtitle, this.imageUrl, this.bio, this.isUpdated = false, this.fullname});
}

final profileViewProvider = Provider<ProfileView?>((ref) {
  final userAsync = ref.watch(userFromStorageProvider);
  final profileAsync = ref.watch(profileNotifierProvider);

  final user = userAsync.asData?.value;
  final profile = profileAsync.asData?.value;
  if (profile != null) {
    // Ưu tiên dữ liệu profile
    return ProfileView(
      userID: user?.userId ?? 'unknown',
      displayName: user?.userName ?? 'Người dùng',
      subtitle: user?.role ?? 'Chưa có thông tin',
      imageUrl: profile.imageUrl,
      bio: profile.bio,
      isUpdated: true,
      fullname: null,
    );
  }

  // Fallback sang local user
  if (user != null) {
    return ProfileView(
      userID: user.userId ?? 'unknown',
      displayName: user.userName ?? 'Người dùng',
      subtitle: user.role ?? user.status ?? 'Chưa có thông tin',
      imageUrl: null,
      bio: null,
      isUpdated: false,
      fullname: null,
    );
  }

  return null;
});
