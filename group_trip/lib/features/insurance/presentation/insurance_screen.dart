import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:group_trip/features/trip/data/trip_insurance.dart';
import 'package:group_trip/features/insurance/providers/insurance_provider.dart';

// TODO: Create provider to fetch user's insurance list
// final userInsurancesProvider = FutureProvider<List<TripInsurance>>((ref) async {
//   // Fetch from API
// });

class InsuranceScreen extends ConsumerWidget {
  const InsuranceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch insurance list from provider
    final insuranceListAsync = ref.watch(insuranceListProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Bảo hiểm du lịch',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: insuranceListAsync.when(
        data: (insurances) => _buildBody(context, insurances),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Lỗi: $error'),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, dynamic insurances) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Info banner ---
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Quản lý và theo dõi tất cả các gói bảo hiểm du lịch của bạn',
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
          const SizedBox(height: 20),

          // --- Section: Active Insurances ---
          _buildSectionHeader('Bảo hiểm đang hoạt động', '${insurances.where((i) => i.insurance?.isActive == true).length}'),
          const SizedBox(height: 12),
          if (insurances.where((i) => i.insurance?.isActive == true).isEmpty)
            _buildEmptyState('Không có bảo hiểm nào đang hoạt động')
          else
            ...insurances
                .where((i) => i.insurance?.isActive == true)
                .map((insurance) => _buildInsuranceCard(context, insurance.insurance!, insurance.tripName))
                .toList(),

          const SizedBox(height: 24),

          // --- Section: Inactive Insurances ---
          _buildSectionHeader('Bảo hiểm không hoạt động', '${insurances.where((i) => i.insurance?.isActive != true).length}'),
          const SizedBox(height: 12),
          if (insurances.where((i) => i.insurance?.isActive != true).isEmpty)
            _buildEmptyState('Không có bảo hiểm nào không hoạt động')
          else
            ...insurances
                .where((i) => i.insurance?.isActive != true)
                .map((insurance) => _buildInsuranceCard(context, insurance.insurance!, insurance.tripName))
                .toList(),
        ],
      ),
    );
  }


  Widget _buildSectionHeader(String title, String count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            count,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInsuranceCard(BuildContext context, TripInsurance insurance, String tripName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Trip Name Badge ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Text(
              tripName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),
          // --- Header ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.shield, color: Colors.blue.shade700, size: 24),
              ),
              const SizedBox(width: 12),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      insurance.providerName,
                      style: TextStyle(
                        fontSize: 12,
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
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 12),

          // --- Details Grid ---
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  label: 'Giá',
                  value: '${insurance.price.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (Match m) => '.')} VND',
                  icon: Icons.attach_money,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDetailItem(
                  label: 'Bảo hiểm tối đa',
                  value: '${(insurance.maxCoverageAmount / 1000000).toStringAsFixed(1)}M VND',
                  icon: Icons.verified_user,
                  color: Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // --- Benefit ---
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade600, size: 16),
                  const SizedBox(width: 6),
                  const Text(
                    'Quyền lợi',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                insurance.benefit,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // --- Action Buttons ---
          Row(
            children: [
              if (insurance.pdfAttachment != null && insurance.pdfAttachment!.isNotEmpty)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Open PDF viewer
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đang tải file PDF...')),
                      );
                    },
                    icon: const Icon(Icons.picture_as_pdf, size: 16),
                    label: const Text('Chi tiết', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange.shade700,
                      side: BorderSide(color: Colors.orange.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              if (insurance.pdfAttachment != null && insurance.pdfAttachment!.isNotEmpty)
                const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to insurance detail or claim
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    'Xem chi tiết',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.shield_outlined, color: Colors.grey.shade400, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
