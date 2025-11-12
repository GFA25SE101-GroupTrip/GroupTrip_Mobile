import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search
           
            const SizedBox(height: 20),

            Text(
              'Liên hệ hỗ trợ',
              style: GoogleFonts.inter(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            _buildSupportCard(
              context,
              icon: Icons.note_add_outlined,
              title: 'Submit a Ticket',
              subtitle: 'Gửi yêu cầu hỗ trợ chi tiết',
              color: Colors.blue.shade50,
              iconColor: Colors.blue,
            ),
            _buildSupportCard(
              context,
              icon: Icons.phone_in_talk,
              title: 'Hotline',
              subtitle: '1900-1234 | support@tripapp.com',
              color: Colors.red.shade50,
              iconColor: Colors.red,
            ),

            const SizedBox(height: 25),
            Text(
              'Yêu cầu gần đây',
              style: GoogleFonts.inter(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

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

            _buildTicketItem(
              title: 'Refund Trip to Đà Lạt',
              status: 'Resolved',
              statusColor: Colors.green,
              receiver: 'Admin Support',
              related: 'Đà Lạt Adventure - DL001',
              date: 'Oct 15, 2024',
              onTap: () {
                // Navigate to detail screen
                context.push('/profile/help/detail');
              },
            ),
            _buildTicketItem(
              title: 'App error when paying',
              status: 'Pending',
              statusColor: Colors.amber,
              date: 'Oct 10, 2024',
              onTap: () {
                // Navigate to detail screen
                context.push('/profile/help/detail');
              },
            ),
          ],
        ),
      ),
    );
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
              Text('Receiver: $receiver',
                  style:
                      GoogleFonts.inter(fontSize: 13, color: Colors.grey[700])),
            ],
            if (related != null) ...[
              Text('Related Trip: $related',
                  style:
                      GoogleFonts.inter(fontSize: 13, color: Colors.grey[700])),
            ],
            const SizedBox(height: 6),
            Text(date,
                style:
                    GoogleFonts.inter(fontSize: 12, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }
}
