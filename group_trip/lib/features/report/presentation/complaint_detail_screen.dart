import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_trip/features/report/presentation/widgets/detailRow.dart';
import 'package:group_trip/features/report/presentation/widgets/fileChip.dart';
import 'package:group_trip/features/report/presentation/widgets/section_card.dart';

class ComplaintDetailScreen extends StatelessWidget {
  const ComplaintDetailScreen({super.key});

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
          'Complaint #0234',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.more_vert, color: Colors.black),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.hourglass_top, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  'Đang chờ xử lý',
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.amber[800]),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Chi tiết khiếu nại
            SectionCard(
              title: 'Chi tiết khiếu nại',
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailRow(label: 'Loại:', value: 'Refund', trailingIcon: Icons.refresh, color: Colors.green),
                  DetailRow(label: 'Gửi tới:', value: 'Admin'),
                  DetailRow(label: 'Ngày tạo:', value: '18 Oct 2025'),
                  DetailRow(label: 'Cập nhật:', value: '20 Oct 2025'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.network(
                          'https://picsum.photos/200/300',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ninh Bình', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                            Text('Adventure 3D2N',
                                style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[700])),
                            const SizedBox(height: 4),
                            Text('7 ngày 6 đêm',
                                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500])),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Xem chi tiết'),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Nội dung khiếu nại
            SectionCard(
              title: 'Nội dung khiếu nại',
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tiêu đề',
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  Text('Yêu cầu hoàn tiền do hoãn chuyến',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 12),
                  Text('Mô tả',
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  Text(
                    'Chuyến đi bị hủy do thời tiết, tôi mong được hoàn 80% phí. Tôi đã chuẩn bị tất cả giấy tờ chuyến đi như vé máy bay và hợp đồng để chứng minh.',
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Text('Tệp đính kèm:',
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FileChip(name: 'booking_receipt.jpg', size: '2.4 MB', icon: Icons.image, color: Colors.red),
                      FileChip(name: 'weather_report.pdf', size: '1.2 MB', icon: Icons.picture_as_pdf, color: Colors.orange),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Phản hồi từ Admin
            SectionCard(
              title: 'Phản hồi từ Admin',
              color: const Color(0xFFEFFFF6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Admin',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600, fontSize: 15)),
                            Text('Support',
                                style: GoogleFonts.inter(
                                    fontSize: 13, color: Colors.grey[700])),
                          ],
                        ),
                      ),
                      Text('Oct 20, 2025',
                          style:
                              GoogleFonts.inter(fontSize: 12, color: Colors.grey[500])),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Refund approved',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600, fontSize: 15)),
                        const SizedBox(height: 6),
                        Text(
                          'Chúng tôi đã xử lý hoàn tiền và tài khoản của bạn sẽ nhận trong vài ngày tới.',
                          style:
                              GoogleFonts.inter(fontSize: 14, color: Colors.grey[800]),
                        ),
                        const SizedBox(height: 10),
                        Text('Tệp đính kèm:',
                            style: GoogleFonts.inter(
                                fontSize: 13, color: Colors.grey[600])),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FileChip(name: 'evidence1.jpg', size: '1.4 MB', icon: Icons.image, color: Colors.blue),
                            FileChip(name: 'invoice.pdf', size: '0.9 MB', icon: Icons.picture_as_pdf, color: Colors.orange),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 18),
                      const SizedBox(width: 6),
                      Text('Khiếu nại đã được xử lý thành công',
                          style: GoogleFonts.inter(
                              color: Colors.green[800], fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Cập nhật lần cuối: 20 Oct 2025',
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500])),
                ],
              ),
            ),

            const SizedBox(height: 20),
            // Action buttons with improved spacing
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E90FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E90FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Resolve',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
