import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/utils/dataFormat.dart';
import 'package:group_trip/features/profile/providers/profile_provider.dart';
// wallet_model not directly used in this file; transactions are provided via provider
import 'package:group_trip/features/wallet/presentation/widget/payment_sheet.dart';
import 'package:group_trip/features/wallet/presentation/widget/transaction_item.dart';
import 'package:group_trip/features/wallet/providers/wallet_provider.dart';

class MyWalletScreen extends ConsumerWidget {
  const MyWalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final walletAsync = ref.watch(walletModelProvider);
  // ensure we subscribe to profileViewProvider so the wallet UI rebuilds when
  // profile changes; transactionsProvider depends on it and will refetch.
  ref.watch(profileViewProvider);
  final transactionsAsync = ref.watch(transactionsProvider);
    
    

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Tải lại',
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () async {
              // show a small loading snackbar
              final messenger = ScaffoldMessenger.of(context);
              messenger.showSnackBar(const SnackBar(
                content: Text('Đang tải lại giao dịch...'),
                duration: Duration(seconds: 2),
              ));
              try {
                // trigger refresh and await the provider's future to complete
                final _ = ref.refresh(transactionsProvider);
                await ref.read(transactionsProvider.future);
                messenger.showSnackBar(const SnackBar(
                  content: Text('Đã tải lại giao dịch'),
                  duration: Duration(seconds: 2),
                ));
              } catch (e) {
                messenger.showSnackBar(SnackBar(
                  content: Text('Lỗi khi tải lại: $e'),
                ));
              }
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ví của tôi',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet balance card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color.fromARGB(255, 13, 27, 153), Color.fromARGB(255, 10, 29, 73)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.money, color: Colors.white, size: 40),
                  const SizedBox(height: 10),
                  const Text(
                    'Số dư hiện tại',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  walletAsync.when(
                    data: (model) => Text(
                      model != null ? '${formatCurrency(model.balance)}' : '0₫',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    loading: () => const Text(
                      '...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    error: (e, st) => const Text(
                      '0₫',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatDateToDMY(DateTime.now()),
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const PaymentSheet(),
                          );
                        },
                        child: _walletButton(Icons.add_circle, 'Nạp tiền', const Color.fromARGB(255, 0, 0, 0))),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recent transactions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Giao dịch gần đây',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Xem tất cả',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Transactions loaded from server
            transactionsAsync.when(
              data: (txs) {
                if (txs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: Text('Không có giao dịch nào')), 
                  );
                }
                return Column(
                  children: txs.map((tx) => TransactionItem(transaction: tx)).toList(),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, st) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Text('Lỗi khi tải giao dịch')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _walletButton(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
