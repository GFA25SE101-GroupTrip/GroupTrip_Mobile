import 'package:url_launcher/url_launcher.dart';

final Map<String, String> bankSchemes = {
  'VCB Digibank': 'vcb://',
  'MB Bank': 'mbbank://',
  'Techcombank': 'tcbbank://',
  'BIDV': 'bidv://',
  'Momo': 'momo://',
  'ZaloPay': 'zalopay://',
};



Future<String?> findInstalledBankApp() async {
  for (final scheme in bankSchemes.values) {
    final uri = Uri.parse(scheme);
    if (await canLaunchUrl(uri)) return scheme; // trả về scheme đầu tiên tìm thấy
  }
  return null;
}
