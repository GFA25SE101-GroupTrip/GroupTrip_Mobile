import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/features/auth/data/user_api.dart';
import 'package:group_trip/features/auth/data/user_model.dart';
import 'package:group_trip/features/auth/domain/role_repository.dart';
import 'package:group_trip/features/auth/domain/user_repository.dart';

// ...existing code...
// Khai báo provider cho ApiClient. Riverpod sẽ tạo/khóa một instance ApiClient
// lần đầu được đọc và tái sử dụng cho đến khi provider bị dispose.
final apiClientProvider = Provider((ref) {
  print('✅ apiClientProvider initialized');
  return ApiClient();
});

final userRemoteDataSourceProvider = Provider((ref) {
  print('✅ userRemoteDataSourceProvider initialized');
  return UserRemoteDataSource(api: ref.watch(apiClientProvider));
});

final userRepositoryProvider = Provider((ref) {
  print('✅ userRepositoryProvider initialized');
  return UserRepository(remoteDataSource: ref.watch(userRemoteDataSourceProvider));
});

final roleRemoteDataSourceProvider = Provider(
  (ref) {
    print('✅ roleRemoteDataSourceProvider initialized');
    return RoleRemoteDataSource(api: ref.watch(apiClientProvider));
  },
);

final roleRepositoryProvider = Provider(
  (ref) {
    print('✅ roleRepositoryProvider initialized');
    return RoleRepository(remoteDataSource: ref.watch(roleRemoteDataSourceProvider));
  },
);

class RoleNotifier extends StateNotifier<AsyncValue<List<RoleModel>>> {
  final RoleRepository repository;

  RoleNotifier(this.repository) : super(const AsyncData([]));

  Future<void> fetchRoles() async {
    state = const AsyncLoading();
    try {
      final roles = await repository.getRoles();
      state = AsyncData(roles);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  } 
}
// --- Notifier ---
final authNotifierProvider =
  StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  print('✅ authNotifierProvider initialized');
  return AuthNotifier(ref.watch(userRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final UserRepository repository;

  AuthNotifier(this.repository) : super(const AsyncData(null));

  Future<void> register(UserModel user) async {
  state = const AsyncLoading();
  print('🔄 Starting registration for user: ${user.toJson()}');
  try {
    final result = await repository.register(user); // giữ nguyên API repo
    state = AsyncData(result);
  } catch (e, st) {
    state = AsyncError(e, st);
  }
  }

  Future<void> login(String email, String password) async {
  state = const AsyncLoading();
  print('🔄 Starting login for: $email');
  try {
    final result = await repository.login(email, password); // hoặc repository.login(user)
    state = AsyncData(result);
  } catch (e, st) {
    state = AsyncError(e, st);
  }
  }

  void logout() {
  // xóa state / token tùy implement của bạn
  state = const AsyncData(null);
  }
}




final roleNotifierProvider =
    StateNotifierProvider<RoleNotifier, AsyncValue<List<RoleModel>>>((ref) {
  return RoleNotifier(ref.watch(roleRepositoryProvider));
});