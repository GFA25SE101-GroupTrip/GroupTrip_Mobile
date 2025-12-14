import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/utils/dataFormat.dart';
import 'package:group_trip/features/mytrip/providers/mytrip_provider.dart';
import 'package:group_trip/features/trip/data/trip_departure_model.dart';
import 'package:group_trip/features/trip/data/trip_model.dart';
import 'package:group_trip/features/wallet/providers/wallet_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:group_trip/features/trip/providers/tripProvider.dart';

class PaymentSheet extends ConsumerStatefulWidget {
  final String? tripImage;
  final String? tripTitle;
  final String? tripDepartureDate;
  final int totalAmount;
  final int? deposit;
  final int? balance;
  final int? indebt;
  final int? payAmount;
  final String tripDepartureId;
  const PaymentSheet({
    super.key,
    this.tripImage,
    this.tripTitle,
    this.tripDepartureDate,
    required this.totalAmount,
    this.balance,
    this.deposit,
    this.indebt,
    this.payAmount,
    required this.tripDepartureId,
  });

  @override
  ConsumerState<PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends ConsumerState<PaymentSheet> {
  String _selectedMethod = "wallet";

  Future<void> _checkout(int payAmount) async {
    try {
      debugPrint("Nạp tiền vào ví: $payAmount");
      final walletRepository = ref.read(WalletRepositoryProvider);
      final checkoutResp = await walletRepository.topUpWallet(payAmount.toDouble());
      debugPrint('Checkout response: $checkoutResp');

      final webCheckoutUrl = checkoutResp.checkoutUrl;
      if (webCheckoutUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không nhận được url thanh toán')));
        return;
      }

      await _openCheckoutWebview(webCheckoutUrl);
    } catch (e) {
      debugPrint('Checkout failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi khi tạo thanh toán: $e')));
    }
  }

  Future<void> _openCheckoutWebview(String checkoutUrl) async {
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

                if (url.startsWith('https://grouptrip.site/traveller/finances')) {
                  Navigator.of(context).pop();
                  // Refresh wallet and trip data
                  try {
                    final _ = ref.refresh(walletModelProvider);
                    () async {
                      try {
                        await ref.read(walletModelProvider.future);
                      } catch (_) {}
                    }();
                    ref.refresh(TripModelProvider);
                  } catch (e) {
                    debugPrint('Failed to refresh after payment: $e');
                  }
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
    final ballance = ref.watch(walletModelProvider);
    final intBalance = ballance.asData?.value?.balance.toInt() ?? 0;

    // Sử dụng deposit nếu có, nếu không tính từ totalAmount
    final intDeposit = widget.deposit ?? (widget.totalAmount ~/ 2);
    final intIndebt = (intDeposit - intBalance) > 0 ? (intDeposit - intBalance) : 0;

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
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
                      // Trip Info
                      if (widget.tripImage != null && widget.tripTitle != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F8F8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  widget.tripImage!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.tripTitle!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    if (widget.tripDepartureDate != null)
                                      Text(
                                        widget.tripDepartureDate!,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (widget.tripImage != null && widget.tripTitle != null)
                        const SizedBox(height: 20),
                      // Payment Details
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
                              'Chi tiết thanh toán',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _PaymentRow(
                              label: "Tổng chi phí tour",
                              value: formatCurrency(widget.totalAmount.toDouble()),
                            ),
                            _PaymentRow(
                              label: "Tiền cọc (50%)",
                              value: formatCurrency(intDeposit.toDouble()),
                            ),
                            const Divider(),
                            _PaymentRow(
                              label: "Số dư trong ví",
                              value: formatCurrency(intBalance.toDouble()),
                            ),
                            _PaymentRow(
                              label: "Còn lại sau thanh toán",
                              value: formatCurrency((intBalance - intDeposit).toDouble()),
                            ),
                            if (intIndebt > 0) ...[
                              const SizedBox(height: 6),
                              _PaymentRow(
                                label: "Cần thanh toán thêm",
                                value: formatCurrency(intIndebt.toDouble()),
                                highlight: true,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Payment Method
                      const Text(
                        "Phương thức thanh toán",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildPaymentOption(
                        context,
                        id: "wallet",
                        icon: Icons.account_balance_wallet_rounded,
                        title: "Ví điện tử",
                        subtitle: formatCurrency(intBalance.toDouble()),
                        warning: intIndebt > 0
                            ? 'Số dư không đủ. Vui lòng nạp thêm ${formatCurrency(intIndebt.toDouble())}.'
                            : null,
                        actionText: intIndebt > 0 ? 'Nạp tiền' : null,
                        onTapAction: intIndebt > 0 ? () => _checkout(intIndebt) : null,
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                            children: [
                              const TextSpan(text: "Bằng việc thanh toán, bạn đồng ý với "),
                              TextSpan(
                                text: "Điều khoản dịch vụ",
                                style: const TextStyle(
                                  color: Color(0xFF007AFF),
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    debugPrint("Điều khoản dịch vụ clicked!");
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
              // Header
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
              // Bottom Button
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  top: false,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Color(0xFFE5E5E5), width: 1),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: intBalance >= intDeposit
                          ? ElevatedButton(
                              onPressed: () async {
                                try {
                                  await ref.read(mytripPayToTripProvider(widget.tripDepartureId).future);
                                  // Refresh wallet and trip data after payment
                                  await ref.refresh(walletModelProvider.future);
                                  await ref.refresh(TripModelProvider.future);
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Thanh toán thành công')),
                                    );
                                    Navigator.pop(context);
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Lỗi: $e')),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF007AFF),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text(
                                'Thanh toán',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () => _checkout(intIndebt),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF007AFF),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(
                                'Nạp ${formatCurrency(intIndebt.toDouble())}',
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

  Widget _buildPaymentOption(
    BuildContext context, {
    required String id,
    required IconData icon,
    required String title,
    required String subtitle,
    String? warning,
    String? actionText,
    VoidCallback? onTapAction,
  }) {
    final bool selected = _selectedMethod == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? const Color(0xFF007AFF) : const Color(0xFFE5E5E5),
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: selected ? const Color(0xFF007AFF) : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Radio<String>(
                  value: id,
                  groupValue: _selectedMethod,
                  onChanged: (v) {
                    setState(() {
                      _selectedMethod = v!;
                    });
                  },
                  activeColor: const Color(0xFF007AFF),
                ),
              ],
            ),
            if (warning != null && selected) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.red, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        warning,
                        style: const TextStyle(fontSize: 13, color: Colors.red),
                      ),
                    ),
                    if (actionText != null)
                      TextButton(
                        onPressed: onTapAction,
                        child: Text(
                          actionText,
                          style: const TextStyle(
                            color: Color(0xFF007AFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
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
