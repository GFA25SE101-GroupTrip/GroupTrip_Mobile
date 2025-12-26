import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:group_trip/features/trip/data/trip_insurance.dart';

class InsuranceSection extends StatelessWidget {
  final List<TripInsurance> insurances;
  final Function(TripInsurance)? onInsuranceSelected;

  InsuranceSection({super.key, required this.insurances, this.onInsuranceSelected});

  String _formatPrice(int price) {
    final formatted = price.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (Match m) => '.',
    );
    return '$formatted VND';
  }

  String _formatMaxCoverage(int amount) {
    final formatted = amount.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (Match m) => '.',
    );
    return '$formatted VND';
  }

  @override
  Widget build(BuildContext context) {
    final bool hasInsurances = insurances.isNotEmpty;

    return Column(
      key: const ValueKey('insurance_section'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Nhà tổ chức đã có bảo hiểm mặc định, giá được tính vào giá tour, những lựa chọn bên dưới là những gói nâng cao theo nhu cầu của khách du lịch',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue.shade700,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (!hasInsurances)
          _buildEmptyState()
        else
          ...insurances.map((insurance) => _buildInsuranceCard(context, insurance)).toList(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInsuranceCard(BuildContext context, TripInsurance insurance) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header with name and provider ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insurance.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Nhà cung cấp: ${insurance.providerName}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (!insurance.isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Không hoạt động',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // --- Price section ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Giá: ${_formatPrice(insurance.price)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF007AFF),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // --- Benefit section ---
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quyền lợi:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                insurance.benefit,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // --- Coverage amount ---
          Row(
            children: [
              const Icon(Icons.shield, size: 16, color: Colors.green),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Bảo hiểm tối đa: ${_formatMaxCoverage(insurance.maxCoverageAmount)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),

          if (insurance.pdfAttachment != null && insurance.pdfAttachment!.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showPDFViewer(context, insurance.pdfAttachment!);
                },
                icon: const Icon(Icons.picture_as_pdf, size: 18),
                label: const Text('Xem chi tiết (PDF)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade100,
                  foregroundColor: Colors.orange.shade700,
                  elevation: 0,
                ),
              ),
            ),
          ],

          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                onInsuranceSelected?.call(insurance);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                elevation: 0,
              ),
              child: const Text(
                'Chọn bảo hiểm này',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Center(
        child: Text(
          "Chuyến đi này không có gói bảo hiểm",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }

  void _showPDFViewer(BuildContext context, String pdfUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..loadRequest(Uri.parse(pdfUrl)),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
