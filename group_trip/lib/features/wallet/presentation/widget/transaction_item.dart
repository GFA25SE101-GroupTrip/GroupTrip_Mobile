import 'package:flutter/material.dart';
import 'package:group_trip/features/wallet/data/wallet_model.dart';
import 'package:intl/intl.dart';


class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDeposit = transaction.type == 1;
    final isExpense = transaction.type == 2;
    final isRefund = transaction.type == 3;

    final icon = isDeposit
        ? Icons.arrow_downward_rounded
        : isExpense
            ? Icons.arrow_upward_rounded
            : Icons.refresh_rounded;

    final color = isDeposit
        ? Colors.green
        : isExpense
            ? Colors.red
            : Colors.orange;

    final amountPrefix = isDeposit
        ? '+'
        : isExpense
            ? '-'
            : '+';

    final amountText =
        '$amountPrefix${NumberFormat('#,###').format(transaction.totalAmount)}đ';

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
                      .format(transaction.createdTime),
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
                transaction.status,
                style: TextStyle(
                  color: transaction.status == 'Pending'
                      ? Colors.orange
                      : Colors.green,
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
