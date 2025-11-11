import 'package:group_trip/features/wallet/data/wallet_api.dart';
import 'package:group_trip/features/wallet/data/wallet_model.dart';

class WalletRepository {
  // Repository methods would be defined here
  final WalletRemoteDataSource remoteDataSource;
  WalletRepository({required this.remoteDataSource});
  WalletModel? _cache;

  Future<WalletModel> fetchUserWallet() async {
    try {
      // ignore: avoid_print
      print('🔁 [WalletRepository] fetchUserWallet()');
      final res = await remoteDataSource.fetchUserWallet();
      // ignore: avoid_print
      print('✅ [WalletRepository] fetchUserWallet completed');
      _cache = res;
      return res;
    } catch (e) {
      // ignore: avoid_print
      print('❌ [WalletRepository] fetchUserWallet failed: $e');
      rethrow;
    }
  }
  double? get balance => _cache?.balance;

  Future<TopUpResponse> topUpWallet(double amount) async {
    try {
      // ignore: avoid_print
      print('🔁 [WalletRepository] topUpWallet($amount)');
      final res = await remoteDataSource.topUpWallet(amount);
      // ignore: avoid_print
      print('✅ [WalletRepository] topUpWallet completed');
      return res;
    } catch (e) {
      // ignore: avoid_print
      print('❌ [WalletRepository] topUpWallet failed: $e');
      rethrow;
    }
  }

  Future<List<TransactionModel>> fetchTransactions(String userID) async {
    
    try {
      // ignore: avoid_print
      print('🔁 [WalletRepository] fetchTransactions($userID)');
      final res = await remoteDataSource.fetchTransactions(userID);
      // ignore: avoid_print
      print('✅ [WalletRepository] fetchTransactions completed');
      return res;
    } catch (e) {
      // ignore: avoid_print
      print('❌ [WalletRepository] fetchTransactions failed: $e');
      rethrow;
    }
  }

}