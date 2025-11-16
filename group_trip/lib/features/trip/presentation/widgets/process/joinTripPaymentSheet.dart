import 'package:flutter/material.dart';

class WalletPaymentBottomSheet extends StatelessWidget {
  final String accountNumber;
  final int requiredAmount;
  final int balance;
  final VoidCallback onJoinTrip;

  const WalletPaymentBottomSheet({
    super.key,
    required this.accountNumber,
    required this.requiredAmount,
    required this.balance,
    required this.onJoinTrip,
  });

  @override
  Widget build(BuildContext context) {
    final int remaining = balance - requiredAmount;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          const Text(
            "Thanh toán tham gia trip",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          _infoRow("Số tài khoản trong ví:", accountNumber),
          _infoRow("Số tiền cần thanh toán:", _format(requiredAmount)),
          _infoRow("Số dư còn lại:", _format(remaining),
              valueColor: remaining >= 0 ? Colors.green : Colors.red),

          const SizedBox(height: 30),

          // Join Trip Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: remaining >= 0 ? onJoinTrip : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Tham gia trip",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String _format(int number) {
    return "${number.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')} đ";
  }
}
