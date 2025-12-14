import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:group_trip/core/providers/user_storage_provider.dart';
import 'package:group_trip/features/report/presentation/complaint_detail_screen.dart';
import 'package:group_trip/features/report/providers/report_provider.dart';

class HelpCenterScreen extends ConsumerWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userFromStorageProvider);
    final userId = user.asData?.value?.userId ?? '';
    final reportsAsyncValue = ref.watch(reportListProvider(userId));

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Hỗ trợ',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E90FF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                context.push('/profile/help/submit');
              },
              child: Text(
                'Tạo yêu cầu',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.refresh(reportListProvider(userId).future);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            // Search
            const SizedBox(height: 25),
             TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm yêu cầu hỗ trợ',
                hintStyle: GoogleFonts.inter(fontSize: 14),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 10),
            reportsAsyncValue.when(
              data: (reports) {
                if (reports.isEmpty) {
                  return Center(
                    child: Text(
                      'Chưa có yêu cầu hỗ trợ nào.',
                      style: GoogleFonts.inter(
                          fontSize: 14, color: Colors.grey[600]),
                    ),
                  );
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: reports.map((report) {
                    return _buildTicketItem(
                      title: report.title,
                      status: report.status,
                      date: report.createdTime ?? '',
                      receiver: report.receiverName,
                      related: report.tripName,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComplaintDetailScreen(reportId: report.id,),
                          ),
                        );
                      },
                      statusColor: report.status == 'Resolved'
                          ? Colors.green
                          : Colors.amber,
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (err, stack) => Center(
                child: Text(
                  'Lỗi khi tải yêu cầu hỗ trợ: $err',
                  style:
                      GoogleFonts.inter(fontSize: 14, color: Colors.redAccent),
                ),
              ),
            ),
           
            ],
          ),
        ),
      );
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      final formatter = DateFormat('dd/MM/yyyy', 'vi_VN');
      return formatter.format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildSupportCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required Color color,
      required Color iconColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600, fontSize: 15)),
                Text(subtitle,
                    style:
                        GoogleFonts.inter(fontSize: 13, color: Colors.grey[600])),
              ],
            ),
          ),
          const Icon(Icons.arrow_drop_down, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildTicketItem({
    required String title,
    required String status,
    required Color statusColor,
    String? receiver,
    String? related,
    required String date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(status,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          color: statusColor,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            if (receiver != null) ...[
              const SizedBox(height: 4),
              Text('Gửi tới: $receiver',
                  style:
                      GoogleFonts.inter(fontSize: 13, color: Colors.grey[700])),
            ],
            if (related != null) ...[
              Text('Chuyến đi liên quan: $related',
                  style:
                      GoogleFonts.inter(fontSize: 13, color: Colors.grey[700])),
            ],
            const SizedBox(height: 6),
            Text(_formatDate(date),
                style:
                    GoogleFonts.inter(fontSize: 12, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }
}
