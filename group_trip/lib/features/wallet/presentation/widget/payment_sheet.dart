import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/utils/bankList.dart';
import 'package:group_trip/features/wallet/providers/wallet_provider.dart';
import 'package:url_launcher/url_launcher.dart';
// QR view removed: using in-app webview instead

class PaymentSheet extends ConsumerStatefulWidget {
  const PaymentSheet({super.key});

  @override
  ConsumerState<PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends ConsumerState<PaymentSheet> {
  String _selectedMethod = "bank";
  final TextEditingController _amountController = TextEditingController();
  double _amount = 0;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _TopupWallet(double amount, BuildContext context) async {
    debugPrint("Nạp tiền vào ví: $amount");

    // 1. Gọi API để tạo top-up
    final walletRepository = ref.read(WalletRepositoryProvider);
    final checkoutUrl = await walletRepository.topUpWallet(amount);
    debugPrint("Checkout URL: $checkoutUrl");

    // 2. Kiểm tra app ngân hàng / ví cài trên máy
    final installedAppScheme = await findInstalledBankApp();

    if (installedAppScheme != null) {
      // 3a. Nếu có app -> mở deeplink
      final uri = Uri.parse(checkoutUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // fallback nếu checkoutUrl không mở được
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể mở app ngân hàng.')),
        );
      }
    } else {
      // 3b. Nếu không có app -> mở in-app web view (fallback to browser if unavailable)
      try {
        final uri = Uri.parse(checkoutUrl);
        final launched = await launchUrl(uri, mode: LaunchMode.inAppWebView);
        if (!launched) {
          // fallback: try external application (browser)
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            // As a last resort, show the link so the user can copy it
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Mở thanh toán'),
                content: SelectableText(checkoutUrl),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Đóng'),
                  ),
                  TextButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: checkoutUrl));
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã sao chép liên kết vào clipboard')),
                      );
                    },
                    child: const Text('Sao chép liên kết'),
                  ),
                ],
              ),
            );
          }
        }
      } catch (e) {
        // ignore: avoid_print
        print('Failed to open in-app webview: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể mở trang thanh toán.')),
        );
      }
    }

    // Best-effort: refresh the wallet model so UI can reflect any immediate
    // balance changes (some payment flows may update balance asynchronously).
    try {
      ref.refresh(walletModelProvider);
      await ref.read(walletModelProvider.future);
      debugPrint('Wallet model refreshed after top-up attempt');
    } catch (e) {
      debugPrint('Failed to refresh wallet after top-up: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1.0,
      maxChildSize: 1.0,
      minChildSize: 0.7,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 72, 16, 90),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Ô nhập số tiền ---
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E5E5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Nhập số tiền cần thanh toán",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                hintText: "Nhập số tiền (VD: 500000)",
                                prefixIcon: const Icon(Icons.payments_rounded),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE5E5E5),
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _amount =
                                      double.tryParse(value) != null
                                          ? double.parse(value)
                                          : 0;
                                });
                              },
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Tối thiểu 100.000đ • Tối đa 10.000.000đ",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Chi tiết thanh toán ---
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E5E5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Chi tiết thanh toán",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _PaymentRow(
                              label: "Số tiền nhập",
                              value: _formatCurrency(_amount),
                            ),
                            const _PaymentRow(
                              label: "Phí giao dịch",
                              value: "Miễn phí",
                            ),
                            const Divider(),
                            _PaymentRow(
                              label: "Tổng thanh toán",
                              value: _formatCurrency(_amount),
                              highlight: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Phương thức thanh toán ---
                      const Text(
                        "Phương thức thanh toán",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),

                      const SizedBox(height: 24),
                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                            children: [
                              const TextSpan(
                                text: "Bằng việc thanh toán, bạn đồng ý với ",
                              ),
                              TextSpan(
                                text: "Điều khoản dịch vụ",
                                style: const TextStyle(
                                  color: Color(0xFF007AFF),
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        debugPrint(
                                          "Điều khoản dịch vụ clicked!",
                                        );
                                      },
                              ),
                              const TextSpan(text: " của chúng tôi"),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // --- Header ---
              Container(
                height: 64,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Thanh toán",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),

              // --- Button Thanh toán ---
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  top: false,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Color(0xFFE5E5E5), width: 1),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            _amount >= 1000 && _amount <= 10000000
                                ? () {
                                  _TopupWallet(_amount, context);
                                  debugPrint(
                                    "Phương thức chọn: $_selectedMethod, số tiền: $_amount",
                                  );
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007AFF),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Thanh toán ${_formatCurrency(_amount)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Hàm hiển thị định dạng tiền ---
  static String _formatCurrency(double value) {
    if (value == 0) return "0đ";
    final str = value.toStringAsFixed(0);
    final formatted = str.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => "${m[1]}.",
    );
    return "$formattedđ";
  }
}

class _PaymentRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _PaymentRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
              color: highlight ? const Color(0xFF007AFF) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
