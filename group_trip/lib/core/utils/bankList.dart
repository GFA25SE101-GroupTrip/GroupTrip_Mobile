import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
final Map<String, String> bankSchemes = {
  // Ngân hàng
  'VCB Digibank': 'vcbdigibank://qr?data=',
  'MB Bank': 'mbbank://qr?data=',
  'Techcombank': 'techcombank://qr?data=',
  'BIDV SmartBanking': 'bidvsmartbanking://qr?data=',

  // Ví điện tử
  'Momo': 'momo://app?action=payWithApp&data=',
  'ZaloPay': 'zalopay://app?data=',
  'ShopeePay': 'airpay://qr?data=',
  'VNPay': 'vnpay://app?data=',
  'Viettel Money': 'viettelmoney://qr?data=',
};

/// Trả về MapEntry(appName, scheme) nếu tìm thấy app có thể xử lý scheme.
/// Thử với một payload dummy ngắn để canLaunchUrl có URI hợp lệ.
Future<MapEntry<String, String>?> findInstalledBankApp() async {
  for (final entry in bankSchemes.entries) {
    final testUriString = '${entry.value}test'; // thử ghép payload giả
    final uri = Uri.parse(testUriString);
    final can = await canLaunchUrl(uri);
    debugPrint('Testing ${entry.key} -> $can (uri=$testUriString)');
    if (can) return entry; // trả về entry đầu tiên có thể mở
  }
  return null;
}