import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/utils/dataFormat.dart';
import 'package:group_trip/features/profile/providers/profile_provider.dart';
// wallet_model not directly used in this file; transactions are provided via provider
import 'package:group_trip/features/wallet/presentation/widget/payment_sheet.dart';
import 'package:group_trip/features/wallet/presentation/widget/transaction_item.dart';
import 'package:group_trip/features/wallet/providers/wallet_provider.dart';

class MyWalletScreen extends ConsumerStatefulWidget {
  const MyWalletScreen({super.key});

  @override
  ConsumerState<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends ConsumerState<MyWalletScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _pickStartDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now.subtract(const Duration(days: 30)),
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _pickEndDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) setState(() => _endDate = picked);
  }

  void _clearDates() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
  }

  Future<void> _loadTransactionByDate() async {
    final startTime = combineDate(_startDate!).toIso8601String();
    final endTime = combineDate(_endDate!).toIso8601String();

    print('Loading transactions from $startTime to $endTime');
  }

  @override
  Widget build(BuildContext context) {
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
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('Đang tải lại giao dịch...'),
                  duration: Duration(seconds: 2),
                ),
              );
              try {
                // Refresh wallet balance first
                final _ = ref.refresh(walletModelProvider);
                await ref.read(walletModelProvider.future);

                // Then refresh transactions list
                final _ = ref.refresh(transactionsProvider);
                await ref.read(transactionsProvider.future);

                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Đã tải lại số dư và giao dịch'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Lỗi khi tải lại: $e')),
                );
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
                  colors: [
                    Color.fromARGB(255, 13, 27, 153),
                    Color.fromARGB(255, 10, 29, 73),
                  ],
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
                    data:
                        (model) => Text(
                          model != null
                              ? '${formatCurrency(model.balance)}'
                              : '0₫',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                    loading:
                        () => const Text(
                          '...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                    error:
                        (e, st) => const Text(
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
                        child: _walletButton(
                          Icons.add_circle,
                          'Nạp tiền',
                          const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
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

            // --- Date range filter ---
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lọc theo ngày',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _pickStartDate(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(
                                _startDate != null
                                    ? formatDateToDMY(_startDate!)
                                    : 'Ngày bắt đầu',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () => _pickEndDate(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(
                                _endDate != null
                                    ? formatDateToDMY(_endDate!)
                                    : 'Ngày kết thúc',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _clearDates,
                          child: const Text('Xóa'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            _loadTransactionByDate();
                          },
                          child: const Text('Áp dụng'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Transactions loaded from server
            transactionsAsync.when(
              data: (txs) {
                // Apply date filtering client-side if start/end specified
                var filtered = txs;
                if (_startDate != null) {
                  filtered =
                      filtered
                          .where((t) => !t.createdTime.isBefore(_startDate!))
                          .toList();
                }
                if (_endDate != null) {
                  // include entire end day
                  final dayEnd = DateTime(
                    _endDate!.year,
                    _endDate!.month,
                    _endDate!.day,
                    23,
                    59,
                    59,
                  );
                  filtered =
                      filtered
                          .where((t) => !t.createdTime.isAfter(dayEnd))
                          .toList();
                }

                if (filtered.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: Text('Không có giao dịch nào')),
                  );
                }
                return Column(
                  children:
                      filtered
                          .map((tx) => TransactionItem(transaction: tx))
                          .toList(),
                );
              },
              loading:
                  () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              error:
                  (e, st) => Padding(
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
