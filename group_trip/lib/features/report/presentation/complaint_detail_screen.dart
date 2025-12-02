import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_trip/core/utils/dataFormat.dart';
import 'package:group_trip/features/report/presentation/widgets/detailRow.dart';
import 'package:group_trip/features/report/presentation/widgets/fileChip.dart';
import 'package:group_trip/features/report/presentation/widgets/fullscreenImage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:group_trip/features/report/presentation/widgets/section_card.dart';
import 'package:group_trip/features/report/providers/report_provider.dart';

class ComplaintDetailScreen extends ConsumerWidget {
  final String reportId;
  const ComplaintDetailScreen({super.key, required this.reportId});

  String _statusToVietnamese(String status) {
    final s = status.trim().toLowerCase();
    switch (s) {
      case 'pending':
        return 'Đang chờ';
      case 'processing':
        return 'Đang xử lý';
      case 'completed':
        return 'Đã hoàn thành';
      case 'cancelled':
        return 'Đã Hủy';
      default:
        return status.isNotEmpty ? status : 'Đang chờ xử lý';
    }
  }

  /// Helper to pick icon and color for a given status key
  Map<String, dynamic> _statusIconAndColor(String status) {
    final s = status.trim().toLowerCase();
    if (s == 'completed') {
      return {'icon': Icons.check_circle, 'color': Colors.green[700]};
    }
    if (s == 'cancelled') {
      return {'icon': Icons.cancel, 'color': Colors.red[700]};
    }
    // pending / processing / default
    return {'icon': Icons.hourglass_top, 'color': Colors.amber[800]};
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(reportDetailProvider(reportId));

    return provider.when(
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (err, st) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Complaint',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            body: Center(child: Text('Lỗi khi tải dữ liệu: $err')),
          ),
      data: (report) {
        final resp = report.responseReportModel;
        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.title.isNotEmpty ? report.title : 'Complaint',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      _statusIconAndColor(report.status)['icon'] as IconData,
                      size: 14,
                      color: _statusIconAndColor(report.status)['color'] as Color?,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _statusToVietnamese(report.status),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: (_statusIconAndColor(report.status)['color'] as Color?) ?? Colors.amber[800],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.more_vert, color: Colors.black),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // status moved to AppBar

                // Chi tiết khiếu nại
                SectionCard(
                  title: 'Chi tiết khiếu nại',
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // DetailRow(label: 'Loại:', value: report.type),
                      DetailRow(label: 'Gửi tới:', value: report.receiverName),
                      if (report.createdTime != null)
                        DetailRow(
                          label: 'Ngày tạo:',
                          value: report.createdTime!,
                        ),
                      if (resp != null) DetailRow(label: 'Cập nhật:', value: resp.createTime),
                      const SizedBox(height: 10),
                      if (report.tripId != null || report.tripName != null)
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
                                // If you have a trip image url, use it; otherwise a placeholder
                                'https://res.cloudinary.com/db18zz55c/image/upload/v1762439871/uploads/scaled_38.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (report.tripName != null)
                                    Text(
                                      report.tripName!,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  if (report.tripId != null)
                                    Text(
                                      'Trip ID: ${report.tripId!}',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (report.tripId != null)
                              TextButton(
                                onPressed: () {},
                                child: const Text('Xem chi tiết'),
                              ),
                          ],
                        ),
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
                      Text(
                        'Tiêu đề',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        report.title,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Mô tả',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        report.content,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                        ),
                      ),
                      // The API may not include a separate description field; if it does, show it.
                      // For now use receiverName as fallback not needed; only show if present.
                      // If your ReportResponse has a dedicated content field, replace the following.
                      if (resp == null)
                        const SizedBox.shrink()
                      else
                        // Text(resp.content, style: GoogleFonts.inter(fontSize: 14)), sửa thành report.content
                        const SizedBox(height: 12),
                      if (report.attach.isNotEmpty)
                        Text(
                          'Tệp đính kèm:',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      const SizedBox(height: 8),
                      if (report.attach.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              report.attach.map((a) {
                                final lower = a.toLowerCase();
                                final isImage =
                                    lower.endsWith('.png') ||
                                    lower.endsWith('.jpg') ||
                                    lower.endsWith('.jpeg') ||
                                    lower.endsWith('.gif') ||
                                    lower.endsWith('.webp');
                                return GestureDetector(
                                  onTap: () async {
                                    if (lower.endsWith('.pdf')) {
                                      final uri = Uri.parse(a);
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          fullscreenDialog: true,
                                          builder:
                                              (_) => Scaffold(
                                                appBar: AppBar(
                                                  title: const Text('Xem PDF'),
                                                  leading: IconButton(
                                                    icon: const Icon(
                                                      Icons.close,
                                                    ),
                                                    onPressed:
                                                        () =>
                                                            Navigator.of(
                                                              context,
                                                            ).pop(),
                                                  ),
                                                ),
                                                body: WebViewWidget(
                                                  controller:
                                                      WebViewController()
                                                        ..setJavaScriptMode(
                                                          JavaScriptMode
                                                              .unrestricted,
                                                        )
                                                        ..loadRequest(uri),
                                                ),
                                              ),
                                        ),
                                      );
                                    } else if (isImage) {
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder:
                                              (_) => Scaffold(
                                                backgroundColor: Colors.black,
                                                appBar: AppBar(
                                                  backgroundColor: Colors.black,
                                                  leading: IconButton(
                                                    icon: const Icon(
                                                      Icons.close,
                                                    ),
                                                    onPressed:
                                                        () =>
                                                            Navigator.of(
                                                              context,
                                                            ).pop(),
                                                  ),
                                                ),
                                                body: Center(
                                                  child: InteractiveViewer(
                                                    child: Image.network(
                                                      a,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        ),
                                      );
                                    }
                                    // else {
                                    //   final uri = Uri.parse(a);
                                    //   await Navigator.of(context).push(MaterialPageRoute(
                                    //     fullscreenDialog: true,
                                    //     builder: (_) => Scaffold(
                                    //       appBar: AppBar(
                                    //         title: const Text('Mở tệp đính kèm'),
                                    //         leading: IconButton(
                                    //           icon: const Icon(Icons.close),
                                    //           onPressed: () => Navigator.of(context).pop(),
                                    //         ),
                                    //       ),
                                    //       body: WebViewWidget(
                                    //         controller: WebViewController()
                                    //           ..setJavaScriptMode(JavaScriptMode.unrestricted)
                                    //           ..loadRequest(uri),
                                    //       ),
                                    //     ),
                                    //   ));
                                    // }
                                  },
                                  child:
                                      isImage
                                          ? Container(
                                            width: 80,
                                            height: 80,
                                            clipBehavior: Clip.hardEdge,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Image.network(
                                              a,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (c, e, s) => const Icon(
                                                    Icons.broken_image,
                                                  ),
                                            ),
                                          )
                                          : FileChip(
                                            name: a,
                                            size: '',
                                            icon: Icons.attach_file,
                                            color: Colors.grey,
                                          ),
                                );
                              }).toList(),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Phản hồi từ Admin (optional)
                if (resp != null)
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
                                  Text(
                                    resp.responsederName,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  // Text(resp.createdBy, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[700])),
                                ],
                              ),
                            ),
                            if (resp.createTime.isNotEmpty)
                              Text(
                                formatDateToDMYString(resp.createTime),
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
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
                              if (resp.title.isNotEmpty)
                                Text(
                                  resp.title,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              const SizedBox(height: 6),
                              Text(
                                resp.content,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (resp.attachments.isNotEmpty)
                                Text(
                                  'Tệp đính kèm:',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              const SizedBox(height: 6),
                              if (resp.attachments.isNotEmpty)
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children:
                                      resp.attachments.map((a) {
                                        return GestureDetector(
                                          onTap: () async {
                                            final lower = a.toLowerCase();
                                            if (lower.endsWith('.pdf')) {
                                              final uri = Uri.parse(a);
                                              await Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  fullscreenDialog: true,
                                                  builder:
                                                      (_) => Scaffold(
                                                        appBar: AppBar(
                                                          title: const Text(
                                                            'Xem PDF',
                                                          ),
                                                          leading: IconButton(
                                                            icon: const Icon(
                                                              Icons.close,
                                                            ),
                                                            onPressed:
                                                                () =>
                                                                    Navigator.of(
                                                                      context,
                                                                    ).pop(),
                                                          ),
                                                        ),
                                                        body: WebViewWidget(
                                                          controller:
                                                              WebViewController()
                                                                ..setJavaScriptMode(
                                                                  JavaScriptMode
                                                                      .unrestricted,
                                                                )
                                                                ..loadRequest(
                                                                  uri,
                                                                ),
                                                        ),
                                                      ),
                                                ),
                                              );
                                            } else if (lower.endsWith('.png') ||
                                                lower.endsWith('.jpg') ||
                                                lower.endsWith('.jpeg') ||
                                                lower.endsWith('.gif') ||
                                                lower.endsWith('.webp')) {
                                              await Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) =>
                                                          FullScreenImageViewer(
                                                            imageUrl: a,
                                                          ),
                                                ),
                                              );
                                            }
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Image.network(
                                              a,
                                              width: 120, // kích thước ảnh nhỏ
                                              height: 120,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // status message removed as requested
                        if (resp.createTime.isNotEmpty)
                          Text(
                            'Cập nhật lần cuối: ${resp.createTime}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),
                // Action buttons (keep present but you can hook them up)
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
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
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
      },
    );
  }
}
