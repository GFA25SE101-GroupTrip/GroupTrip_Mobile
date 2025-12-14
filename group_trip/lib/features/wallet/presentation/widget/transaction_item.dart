import 'package:flutter/material.dart';
import 'package:group_trip/features/wallet/data/wallet_model.dart';
import 'package:intl/intl.dart';


class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine transaction type
    final isDeposit = transaction.type == 'Deposit';
    final isTopup = transaction.type == 'Topup';
    final isFullPayment = transaction.type == 'FullPayment';
    final isRefund = transaction.type == 'Refund';

    // Icon selection
    final icon = isDeposit || isFullPayment
        ? Icons.arrow_upward_rounded
        : isTopup
            ? Icons.account_balance_wallet_rounded
            : Icons.refresh_rounded;

    // Color selection
    final color = isDeposit || isFullPayment
        ? Colors.red
        : isTopup
            ? Colors.blue
            : Colors.green;

    // Amount prefix (+ for incoming, - for outgoing)
    final amountPrefix = isTopup || isRefund ? '+' : '-';

    final amountText =
        '$amountPrefix${NumberFormat('#,###').format(transaction.totalAmount)}đ';

    // Status translation
    final statusText = transaction.status == 'Pending'
        ? 'Chờ xử lý'
        : 'Thành công';
    final statusColor = transaction.status == 'Pending'
        ? Colors.orange
        : Colors.green;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.transactionName,
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm')
                      .format(transaction.createdTime.add(Duration(hours: 7))),
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amountText,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
