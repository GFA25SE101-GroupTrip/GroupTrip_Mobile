import 'package:flutter_riverpod/flutter_riverpod.dart';
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

final userInformationRepositoryProvider = Provider((ref) {
  print('✅ userInformationRepositoryProvider initialized');
  return UserInformationRespository(remoteDataSource: ref.watch(profileRemoteDataSourceProvider));
});

final userInformationNotifierProvider =
    StateNotifierProvider<UserInformationNotifier, AsyncValue<UserInformation?>>((ref) {
  print('✅ userInformationNotifierProvider initialized');
  final notifier = UserInformationNotifier(ref, ref.watch(userInformationRepositoryProvider));
  ref.listen<AsyncValue<UserResponse?>>(userFromStorageProvider, (previous, next) {
    final prevUser = previous?.asData?.value;
    final nextUser = next.asData?.value;
    if (prevUser == null && nextUser != null) {
      // token/user became available (e.g. after login)
      notifier.fetchUserInformation();
    } else if (prevUser != null && nextUser == null) {
      // user logged out: clear cached user information
      notifier.clearUserInformation();
    }
  });

  return notifier;
});

class UserInformationNotifier extends StateNotifier<AsyncValue<UserInformation?>> {
  final Ref ref;
  final UserInformationRespository repository;

  UserInformationNotifier(this.ref, this.repository) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    final stored = await ref.read(userFromStorageProvider.future);
    if (stored != null) {
      await fetchUserInformation();
    } else {
      state = const AsyncData(null);
    }
  }
  Future<void> fetchUserInformation() async {
    state = const AsyncLoading();
    try {
      final user = await ref.read(userFromStorageProvider.future);
      final userInfo = await repository.fetchUserInformation(user!.userId);
      state = AsyncData(userInfo);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Clear the cached user information (used when user logs out)
  void clearUserInformation() {
    state = const AsyncData(null);
  }
}

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
    // preserve previous profile so we can fallback if refresh fails
    final prev = state.asData?.value;
    try {
      await repository.updateUserProfile(bio, imageUrl);
      // Try to refresh profile from server; if that fails, merge optimistic values
      try {
        final profile = await repository.fetchUserProfile();
        state = AsyncData(profile);
      } catch (e) {
        // fallback: merge updated fields into previous profile (or create minimal model)
        if (prev != null) {
          final merged = ProfileModel(
            userProfileId: prev.userProfileId,
            userId: prev.userId,
            bio: bio,
            imageUrl: imageUrl,
            tags: prev.tags,
            createdTime: prev.createdTime,
          );
          state = AsyncData(merged);
        } else {
          final fallback = ProfileModel(
            userProfileId: '',
            userId: '',
            bio: bio,
            imageUrl: imageUrl,
            tags: null,
            createdTime: DateTime.now(),
          );
          state = AsyncData(fallback);
        }
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  Future<void> updateUserInformation(String userID,
    String fullname,
    String phonenumber,
    String bankAccount,
    String bankName) async {
    final prev = state.asData?.value;
    try {
      // perform update on server
      await repository.updateUserInformation(userID, fullname, phonenumber, bankAccount, bankName);

      // Refresh the user information notifier so profileViewProvider immediately
      // gets the new fullname/phone/bank values. This keeps UI responsive.
      try {
        // ignore: avoid_print
        print('🔁 updateUserInformation: refreshing UserInformationNotifier');
        await ref.read(userInformationNotifierProvider.notifier).fetchUserInformation();
      } catch (e) {
        // ignore: avoid_print
        print('⚠️ Failed to refresh UserInformationNotifier after update: $e');
      }

      // Also try to refresh the profile model (if your backend updates profile fields)
      try {
        final profile = await repository.fetchUserProfile();
        state = AsyncData(profile);
      } catch (e) {
        // fallback to previous profile if refresh fails
        if (prev != null) {
          state = AsyncData(prev);
        } else {
          state = const AsyncData(null);
        }
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateUserBio(String profileId, String bio, String imageUrl) async {
    // preserve previous profile so UI doesn't lose values if refresh fails
    final prev = state.asData?.value;
    print('🔁 _updateBio started with url=$imageUrl and bio=${bio}');
    try {
      final currentProfile = prev;
      if (currentProfile == null) {
        print('⚠️ updateUserBio: no currentProfile loaded; proceeding with optimistic update');
      }

      // call remote update (if we have an id use it, else call without id if repo supports)
      if (profileId.isNotEmpty) {
        await repository.updateUserBio(profileId, bio, imageUrl);
      }

      // Try to refresh profile from server; if that fails, merge optimistic values
      try {
        final profile = await repository.fetchUserProfile();
        state = AsyncData(profile);
      } catch (e) {
        // fallback: merge updated fields into previous profile (or create minimal model)
        if (prev != null) {
          final merged = ProfileModel(
            userProfileId: prev.userProfileId,
            userId: prev.userId,
            bio: bio,
            imageUrl: imageUrl,
            tags: prev.tags,
            createdTime: prev.createdTime,
          );
          state = AsyncData(merged);
        } else {
          final fallback = ProfileModel(
            userProfileId: '',
            userId: '',
            bio: bio,
            imageUrl: imageUrl,
            tags: null,
            createdTime: DateTime.now(),
          );
          state = AsyncData(fallback);
        }
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Clear the cached profile (used when user logs out)
  void clearProfile() {
    state = const AsyncData(null);
  }
}

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<ProfileModel?>>((ref) {
  print('✅ profileNotifierProvider initialized');
  final notifier = ProfileNotifier(ref, ref.watch(profileRepositoryProvider));
  ref.listen<AsyncValue<UserResponse?>>(userFromStorageProvider, (previous, next) {
    final prevUser = previous?.asData?.value;
    final nextUser = next.asData?.value;
    if (prevUser == null && nextUser != null) {
      // token/user became available (e.g. after login)
      notifier.fetchUserProfile();
    } else if (prevUser != null && nextUser == null) {
      // user logged out: clear cached profile
      notifier.clearProfile();
    }
  });

  return notifier;
});

class ProfileView {
  final String userID;
  final String userProfileId;
  final String displayName;
  final String subtitle;
  final String? imageUrl;
  final String? bio;
  final bool isUpdated;
  final String? fullname;
  final String? bankAccount;
  final String? bankName;
  final String? phoneNumber;

  ProfileView({required this.userID, required this.userProfileId, required this.displayName, required this.subtitle, this.imageUrl, this.bio, this.isUpdated = false, this.fullname, this.bankAccount, this.bankName, this.phoneNumber});
}

final profileViewProvider = Provider<ProfileView?>((ref) {
  final userAsync = ref.watch(userFromStorageProvider);
  final profileAsync = ref.watch(profileNotifierProvider);
  final userInfoAsync = ref.watch(userInformationNotifierProvider);
  final user = userAsync.asData?.value;
  final profile = profileAsync.asData?.value;
  if (profile != null) {
    // Ưu tiên dữ liệu profile
    return ProfileView(
      userID: user?.userId ?? 'unknown',
      userProfileId: profile.userProfileId,
      displayName: user?.userName ?? 'Người dùng',
      subtitle: user?.role ?? 'Chưa có thông tin',
      imageUrl: profile.imageUrl,
      bio: profile.bio,
      isUpdated: true,
      fullname: userInfoAsync.asData?.value?.fullName,
      bankAccount: userInfoAsync.asData?.value?.bankAccount,
      bankName: userInfoAsync.asData?.value?.bankName,
      phoneNumber: userInfoAsync.asData?.value?.phoneNumber,
    );
  }

  // Fallback sang local user
  if (user != null) {
    return ProfileView(
      userID: user.userId,
      userProfileId: '',
      displayName: user.userName,
      subtitle: user.role,
      imageUrl: null,
      bio: null,
      isUpdated: false,
      fullname: null,
      bankAccount: null,
      bankName: null,
    );
  }

  return null;
});
