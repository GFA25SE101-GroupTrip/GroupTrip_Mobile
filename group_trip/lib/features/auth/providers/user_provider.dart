import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/core/providers/api_client_provider.dart';
import 'package:group_trip/features/auth/data/user_api.dart';
import 'package:group_trip/features/auth/data/user_model.dart';
import 'package:group_trip/features/auth/domain/role_repository.dart';
import 'package:group_trip/features/auth/domain/user_repository.dart';
import 'package:group_trip/core/config/secure_storage_service.dart';
import 'package:group_trip/core/providers/secure_storage_provider.dart';

// ...existing code...
// Khai báo provider cho ApiClient. Riverpod sẽ tạo/khóa một instance ApiClient
// lần đầu được đọc và tái sử dụng cho đến khi provider bị dispose.


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
  StateNotifierProvider<AuthNotifier, AsyncValue<UserResponse?>>((ref) {
  print('✅ authNotifierProvider initialized');
  return AuthNotifier(ref.watch(userRepositoryProvider), ref.watch(secureStorageProvider));
});

final registerNotifierProvider =
    StateNotifierProvider<RegisterNotifier, AsyncValue<bool>>((ref) {
  print('✅ registerNotifierProvider initialized');
  return RegisterNotifier(ref.watch(userRepositoryProvider));
});
class RegisterNotifier extends StateNotifier<AsyncValue<bool>> {
  final UserRepository repository;

  RegisterNotifier(this.repository) : super(const AsyncData(false));

  Future<void> register(UserModel user) async {
    state = const AsyncLoading();
    try {
      final res = await repository.register(user);
      // repository.register returns Map<String, dynamic>
      if (res['statusCode'] == 200) {
        state = const AsyncData(true);
      } else {
        state = AsyncError(
          Exception(res['message'] ?? 'Registration failed'),
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
class AuthNotifier extends StateNotifier<AsyncValue<UserResponse?>> {
  final UserRepository repository;
  final SecureStorageService storage;
  final ValueNotifier<int> listenable = ValueNotifier<int>(0);

  AuthNotifier(this.repository, this.storage) : super(const AsyncData(null));
  
  void _emit() {
    listenable.value++;
    // debug
    // ignore: avoid_print
    print('AuthNotifier emit: state=$state, listenable=${listenable.value}');
  }
  void setAuthenticated(UserResponse user) {
    state = AsyncData(user);
    _emit();
  }

  Future<void> restoreSession() async {
    final storedUser = await storage.getUserResponseFromJson();
    if (storedUser != null) {
      state = AsyncData(storedUser);
      _emit();
    }else {
      state = const AsyncData(null);
      _emit();
    }
  }

  Future<void> login(String email, String password) async {
  state = const AsyncLoading();
  print('🔄 Starting login for: $email');
  try {
    final result = await repository.login(email, password); // hoặc repository.login(user)
    state = AsyncData(result);
    _emit();
  } catch (e, st) {
    state = AsyncError(e, st);
    _emit();
  }
  }

  Future<void> logout() async {
    // Clear stored tokens and user data locally
    try {
      await storage.clearUserJson();
      await storage.clearTokens();
    } catch (_) {}
    state = const AsyncData(null);
    _emit();
  }
}

final roleNotifierProvider =
    StateNotifierProvider<RoleNotifier, AsyncValue<List<RoleModel>>>((ref) {
  return RoleNotifier(ref.watch(roleRepositoryProvider));
});