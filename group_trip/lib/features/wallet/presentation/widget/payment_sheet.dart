import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/utils/bankList.dart';
import 'package:group_trip/features/wallet/providers/wallet_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
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

  /// Hàm top-up (giả sử checkoutUrl.qrCode là payload QR string, không phải deeplink).
Future<void> _TopupWallet(double amount, BuildContext context) async {
  debugPrint("Nạp tiền vào ví: $amount");

  // 1) Gọi API để tạo top-up
  final walletRepository = ref.read(WalletRepositoryProvider);
  final checkoutUrl = await walletRepository.topUpWallet(amount);
  debugPrint("Checkout URL object: $checkoutUrl");

  // backend trả về chỉ payload QR (ví dụ "00020101...DDF9")
  final qrPayload = checkoutUrl.qrCode; // <-- string payload từ backend
  final webCheckoutUrl = checkoutUrl.checkoutUrl; // url web fallback

  // 2) Kiểm tra app ngân hàng / ví cài trên máy
  // final installed = await findInstalledBankApp();

  // if (installed != null) {
  //   final appName = installed.key;
  //   final scheme = installed.value; // e.g. 'mbbank://qr?data='
  //   final deeplinkString = '$scheme$qrPayload';
  //   final deeplinkUri = Uri.parse(deeplinkString);

  //   debugPrint('Detected installed app: $appName. Trying deeplink: $deeplinkString');

  //   // 3a) Thử mở deeplink vào app ngân hàng
  //   if (await canLaunchUrl(deeplinkUri)) {
  //     final launched = await launchUrl(deeplinkUri, mode: LaunchMode.externalApplication);
  //     debugPrint('launchUrl result for $appName: $launched');
  //     if (!launched) {
  //       // Nếu không mở được, fallback sang WebView
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Không thể mở app ngân hàng, chuyển sang thanh toán web...')),
  //       );
  //       await _openCheckoutWebview(context, webCheckoutUrl);
  //     }
  //     // Nếu mở deeplink thành công — app ngân hàng sẽ xử lý thanh toán. Tạm đóng hàm.
  //     return;
  //   } else {
  //     // Nếu canLaunchUrl false (tức backend deeplink/ scheme không hợp lệ)
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Không thể mở liên kết deeplink trên thiết bị. Chuyển sang thanh toán web...')),
  //     );
  //     await _openCheckoutWebview(context, webCheckoutUrl);
  //     return;
  //   }
  // } else {
    // 3b) Nếu không có app nào cài -> mở in-app WebView (fallback)
    debugPrint('No bank/wallet app detected. Opening web checkout.');
    await _openCheckoutWebview(context, webCheckoutUrl);
    return;
  // }
}

/// Mở checkout trong WebView (toàn màn hình)
Future<void> _openCheckoutWebview(BuildContext context, String checkoutUrl) async {
  final uri = Uri.parse(checkoutUrl);

  await Navigator.of(context).push(MaterialPageRoute(
    fullscreenDialog: true,
    builder: (_) => Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(NavigationDelegate(
            onNavigationRequest: (req) {
              final url = req.url;
              debugPrint('WebView navigation: $url');

              // xử lý callback custom scheme nếu backend redirect về myapp://...
              if (url.startsWith('myapp://payment-success')) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thanh toán thành công')),
                );
                // Best-effort refresh wallet (fire-and-forget async closure)
                try {
                  () async {
                    final _ = ref.refresh(walletModelProvider);
                    await ref.read(walletModelProvider.future);
                  }();
                } catch (e) {
                  debugPrint('Failed to refresh wallet after success callback: $e');
                }
                return NavigationDecision.prevent;
              }
              if (url.startsWith('myapp://payment-cancel')) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Giao dịch đã bị hủy')),
                );
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onPageStarted: (s) => debugPrint('WebView page started: $s'),
            onPageFinished: (s) => debugPrint('WebView page finished: $s'),
            onWebResourceError: (err) => debugPrint('WebView error: $err'),
          ))
          ..loadRequest(uri),
      ),
    ),
  ));
}

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1.0,
      maxChildSize: 1.0,
      minChildSize: 0.7,
      expand: false,
      builder: (context, scrollController) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
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
                // add bottom padding equal to keyboard inset so the content scrolls above the keyboard
                padding: EdgeInsets.fromLTRB(16, 72, 16, 90 + bottomInset),
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
                // move the bottom action up by the keyboard inset so it stays visible
                bottom: bottomInset,
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
