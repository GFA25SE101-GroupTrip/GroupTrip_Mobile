import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/features/wallet/data/wallet_model.dart';

class WalletRemoteDataSource {
  final ApiClient api;
  WalletRemoteDataSource({required this.api});
  Future<WalletModel> fetchUserWallet() async {
    final response = await api.get('payment', '/api/wallet/getcurrentwallet');
    print('⬅️ [WalletAPI] fetchUserWallet response data=${response.data}');
    final data = response.data['data'] as Map<String, dynamic>;
    return WalletModel.fromJson(data);
  }

  Future<String> topUpWallet(double amount) async {
    final response = await api.postWithParams(
      'payment',
      '/api/payment/createlinkpayment',
      queryParameters: {'ammount': amount}, // gửi theo query param
    );

    if (response.statusCode == 200 && response.data != null) {
      print('⬅️ [WalletAPI] Top-up response data=${response.data}');
      return response.data['data']['checkoutUrl'] as String;
      ;
    } else {
      throw Exception(
        'Top-up failed: ${response.statusCode} - ${response.data}',
      );
    }
  }

  Future<List<TransactionModel>> fetchTransactions(String userID) async {
  final response = await api.get(
    'payment',
    '/api/payment/getbalanceandtransaction${userID}',
  );

  print('⬅️ [WalletAPI] fetchTransactions data=${response.data}');

  final transactionsJson = response.data['data']['transactions'] as List;
  return transactionsJson
      .map((t) => TransactionModel.fromJson(t))
      .toList();
}
}