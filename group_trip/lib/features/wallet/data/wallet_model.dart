class WalletModel {
  // Wallet model implementation
  final String id;
  final String userId;
  final double balance;
  final String? status;
  WalletModel({
    required this.id,
    required this.userId,
    required this.balance,
    this.status,
  });
  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      balance: (json['balance'] as num).toDouble(),
      status: json['status'] as String?,
    );
  }
}

class TransactionModel {
  final int orderId;
  final String walletId;
  final String? tripDepartureId;
  final String? destinationWalletId;
  final String type; // "Topup", "Transfer", "Refund", etc.
  final String transactionName;
  final double currentBalance;
  final double totalAmount;
  final String status;
  final double percentCost;
  final double netAmmount;
  final String id;
  final String? createdBy;
  final String? lastUpdatedBy;
  final String? deletedBy;
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
    required this.currentBalance,
    required this.totalAmount,
    required this.status,
    required this.percentCost,
    required this.netAmmount,
    required this.id,
    this.createdBy,
    this.lastUpdatedBy,
    this.deletedBy,
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
      type: json['type'] ?? 'Unknown',
      transactionName: json['transactionName'] ?? '',
      currentBalance: (json['currentBalance'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      percentCost: (json['percentCost'] ?? 0).toDouble(),
      netAmmount: (json['netAmmount'] ?? 0).toDouble(),
      id: json['id'] ?? '',
      createdBy: json['createdBy'],
      lastUpdatedBy: json['lastUpdatedBy'],
      deletedBy: json['deletedBy'],
      createdTime: (() {
        try {
          final s = json['createdTime'];
          if (s == null) return DateTime.fromMillisecondsSinceEpoch(0);
          final parsed = DateTime.tryParse(s.toString());
          return parsed ?? DateTime.fromMillisecondsSinceEpoch(0);
        } catch (_) {
          return DateTime.fromMillisecondsSinceEpoch(0);
        }
      })(),
      lastUpdatedTime: (() {
        try {
          final s = json['lastUpdatedTime'];
          if (s == null) return DateTime.fromMillisecondsSinceEpoch(0);
          final parsed = DateTime.tryParse(s.toString());
          return parsed ?? DateTime.fromMillisecondsSinceEpoch(0);
        } catch (_) {
          return DateTime.fromMillisecondsSinceEpoch(0);
        }
      })(),
      deletedTime: json['deletedTime'] != null
          ? (() {
              try {
                final parsed = DateTime.tryParse(json['deletedTime'].toString());
                return parsed;
              } catch (_) {
                return null;
              }
            })()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'walletId': walletId,
        'tripDepartureId': tripDepartureId,
        'destinationWalletId': destinationWalletId,
        'type': type,
        'transactionName': transactionName,
        'currentBalance': currentBalance,
        'totalAmount': totalAmount,
        'status': status,
        'percentCost': percentCost,
        'netAmmount': netAmmount,
        'id': id,
        'createdBy': createdBy,
        'lastUpdatedBy': lastUpdatedBy,
        'deletedBy': deletedBy,
        'createdTime': createdTime.toIso8601String(),
        'lastUpdatedTime': lastUpdatedTime.toIso8601String(),
        'deletedTime': deletedTime?.toIso8601String(),
      };
}


class TopUpResponse {
  final String checkoutUrl;
  final String qrCode; 
  TopUpResponse({required this.checkoutUrl, required this.qrCode});
  factory TopUpResponse.fromJson(Map<String, dynamic> json) {
    return TopUpResponse(
      checkoutUrl: json['checkoutUrl'] as String,
      qrCode: json['qrCode'] as String,
    );
  }
}
