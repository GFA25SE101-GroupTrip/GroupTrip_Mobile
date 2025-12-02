
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/api_client_provider.dart';
import 'package:group_trip/features/wallet/data/wallet_api.dart';
import 'package:group_trip/features/wallet/domain/wallet_repository.dart';
import 'package:group_trip/features/wallet/data/wallet_model.dart';
import 'package:group_trip/features/profile/providers/profile_provider.dart';

final WalletRemoteDataSourceProvider = Provider<WalletRemoteDataSource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return WalletRemoteDataSource(api: apiClient);
});

final WalletRepositoryProvider = Provider<WalletRepository>((ref) {
  final remoteDataSource = ref.read(WalletRemoteDataSourceProvider);
  return WalletRepository(remoteDataSource: remoteDataSource);
});


final walletNotifierProvider =
    StateNotifierProvider<WalletNotifier, AsyncValue<void>>((ref) {
  print('✅ walletNotifierProvider initialized');
  return WalletNotifier(ref.watch(WalletRepositoryProvider));
});

/// Exposes the current wallet model. UI should watch this provider to get
/// balance updates. It calls `fetchUserWallet()` on the repository and will
/// rebuild when refreshed (for example after a top-up).
final walletModelProvider =
    FutureProvider<WalletModel?>((ref) async {
  final repo = ref.read(WalletRepositoryProvider);
  try {
    final model = await repo.fetchUserWallet();
    return model;
  } catch (e) {
    // Return null on error so UI can show a sensible fallback.
    return null;
  }
});

/// Provides the list of transactions for the current profile's userID.
/// This provider automatically re-evaluates when `profileViewProvider` changes.
final transactionsProvider =
    FutureProvider<List<TransactionModel>>((ref) async {
  final profile = ref.watch(profileViewProvider);
  final repo = ref.read(WalletRepositoryProvider);
  if (profile == null || profile.userID.isEmpty) return <TransactionModel>[];
  try {
    final txs = await repo.fetchTransactions(profile.userID);
    return txs;
  } catch (e) {
    // ignore: avoid_print
    print('⚠️ transactionsProvider fetch failed: $e');
    return <TransactionModel>[];
  }
});

// Parameter holder for fetching transactions within a date range
class TransactionRangeParams {
  final String userID;
  final String startTime; // expected ISO8601 or backend-accepted format
  final String endTime;

  const TransactionRangeParams({required this.userID, required this.startTime, required this.endTime});
}

/// Fetch transactions for a user within [startTime, endTime].
/// Usage: ref.watch(transactionsByRangeProvider(TransactionRangeParams(...)))
final transactionsByRangeProvider =
    FutureProvider.family<List<TransactionModel>, TransactionRangeParams>((ref, params) async {
  final repo = ref.read(WalletRepositoryProvider);
  if (params.userID.isEmpty) return <TransactionModel>[];
  try {
    final txs = await repo.fetchAllTransactions(params.userID, params.startTime, params.endTime);
    return txs;
  } catch (e) {
    // ignore: avoid_print
    print('⚠️ transactionsByRangeProvider fetch failed: $e');
    return <TransactionModel>[];
  }
});
class WalletNotifier extends StateNotifier<AsyncValue<void>> {
  final WalletRepository repository;

  WalletNotifier(this.repository) : super(const AsyncData(null));

  Future<void> loadWallet() async {
    state = const AsyncLoading();
    try {
      await repository.fetchUserWallet();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> topUp(double amount) async {
    state = const AsyncLoading();
    try {
      final checkoutUrl = await repository.topUpWallet(amount);
      await repository.fetchUserWallet(); // Refresh wallet after top-up
      state = AsyncData(checkoutUrl);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  Future<void> loadTransactions(String userID) async {
    state = const AsyncLoading();
    try {
      await repository.fetchTransactions(userID);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> loadAllTransactions(String userID, String StartTime, String EndTime) async {
    state = const AsyncLoading();
    try {
      await repository.fetchAllTransactions(userID, StartTime, EndTime);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}