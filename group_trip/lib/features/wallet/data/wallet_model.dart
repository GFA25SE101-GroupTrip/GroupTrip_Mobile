class WalletModel {
  // Wallet model implementation
  final String walletId;
  final String userId;
  final double balance;
  final String status;
  WalletModel({
    required this.walletId,
    required this.userId,
    required this.balance,
    required this.status,
  });
  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      walletId: json['walletId'] as String,
      userId: json['userId'] as String,
      balance: (json['balance'] as num).toDouble(),
      status: json['status'] as String,
    );
  }
}

class TransactionModel {
  final int orderId;
  final String walletId;
  final String? tripDepartureId;
  final String? destinationWalletId;
  final int type; // 1 = Nạp, 2 = Trừ, 3 = Refund
  final String transactionName;
  final double totalAmount;
  final String status;
  final double percentCost;
  final double netAmmount;
  final String id;
  final DateTime createdTime;
  final DateTime lastUpdatedTime;
  final DateTime? deletedTime;

  TransactionModel({
    required this.orderId,
    required this.walletId,
    this.tripDepartureId,
    this.destinationWalletId,
    required this.type,
    required this.transactionName,
    required this.totalAmount,
    required this.status,
    required this.percentCost,
    required this.netAmmount,
    required this.id,
    required this.createdTime,
    required this.lastUpdatedTime,
    this.deletedTime,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      orderId: json['orderId'] ?? 0,
      walletId: json['walletId'] ?? '',
      tripDepartureId: json['tripDepartureId'],
      destinationWalletId: json['destinationWalletId'],
      type: json['type'] ?? 0,
      transactionName: json['transactionName'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      percentCost: (json['percentCost'] ?? 0).toDouble(),
      netAmmount: (json['netAmmount'] ?? 0).toDouble(),
      id: json['id'] ?? '',
      createdTime: DateTime.parse(json['createdTime']),
      lastUpdatedTime: DateTime.parse(json['lastUpdatedTime']),
      deletedTime: json['deletedTime'] != null
          ? DateTime.parse(json['deletedTime'])
          : null,
    );
  }
}
