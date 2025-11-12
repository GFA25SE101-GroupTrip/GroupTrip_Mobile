import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SubmitTicketScreen extends StatefulWidget {
  const SubmitTicketScreen({Key? key}) : super(key: key);

  @override
  State<SubmitTicketScreen> createState() => _SubmitTicketScreenState();
}

class _SubmitTicketScreenState extends State<SubmitTicketScreen> {
  String selectedContact = '';
  String? selectedType;
  String? selectedTrip;
  String? selectedCategory;
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  XFile? attachedImage;
  File? attachedFile;

  final List<String> adminTypes = ['Refund', 'Support'];
  final List<String> representativeTypes = ['Trip Issue', 'Other'];
  final List<String> trips = ['Đà Lạt', 'Sa Pa', 'Phú Quốc'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hỗ trợ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
       
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bạn muốn liên hệ với ai?',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),

            const SizedBox(height: 10),

            // Option: Admin
            _buildContactOption(
              title: 'Admin',
              subtitle: 'Hệ thống / Vấn đề thanh toán',
              icon: Icons.admin_panel_settings_rounded,
              selected: selectedContact == 'Admin',
              onTap: () => setState(() {
                selectedContact = 'Admin';
                selectedType = null;
                selectedTrip = null;
              }),
            ),

            const SizedBox(height: 12),

            // Option: Travel Representative
            _buildContactOption(
              title: 'Đại diện du lịch',
              subtitle: 'Vấn đề về chuyến đi',
              icon: Icons.card_travel_rounded,
              selected: selectedContact == 'Representative',
              onTap: () => setState(() {
                selectedContact = 'Representative';
                selectedType = null;
                selectedTrip = null;
              }),
            ),

            const SizedBox(height: 20),
            // Issue Category dropdown
       
            const SizedBox(height: 18),

            // Conditional fields
            if (selectedContact == 'Admin') ...[
              const Text('Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _buildDropdown<String>(
                hint: 'Select type...',
                value: selectedType,
                items: adminTypes,
                onChanged: (val) => setState(() => selectedType = val),
              ),
            ] else if (selectedContact == 'Representative') ...[
              const Text('Trip participated', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _buildDropdown<String>(
                hint: 'Select trip...',
                value: selectedTrip,
                items: trips,
                onChanged: (val) => setState(() => selectedTrip = val),
              ),
              const SizedBox(height: 16),
              const Text('Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _buildDropdown<String>(
                hint: 'Select type...',
                value: selectedType,
                items: representativeTypes,
                onChanged: (val) => setState(() => selectedType = val),
              ),
            ],

            const SizedBox(height: 18),

            // Subject
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                labelText: 'Tiêu đề',
                hintText: 'Ví dụ: Yêu cầu hoàn tiền cho trip Đà Lạt',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 16),
              maxLength: 100,
            ),

            const SizedBox(height: 14),

            // Description
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Mô tả',
                hintText: 'Vui lòng mô tả chi tiết vấn đề bạn gặp phải...',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 15),
              maxLines: 6,
            ),

            const SizedBox(height: 18),

            // Attachment box (image only)
            GestureDetector(
              onTap: _showAttachmentOptions,
              child: Container(
                height: 140,
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.grey.shade50,
                ),
                child: attachedImage == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.cloud_upload_outlined,
                                size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Chạm để tải ảnh lên hoặc chụp ảnh',
                                style: TextStyle(color: Colors.grey, fontSize: 14)),
                            SizedBox(height: 6),
                            Text('Kích thước tối đa: 10MB',
                                style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      )
                    : Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(attachedImage!.path),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.broken_image, color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  attachedImage!.name,
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w600),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _formatFileSize(attachedFile),
                                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() {
                              attachedImage = null;
                              attachedFile = null;
                            }),
                            icon: const Icon(Icons.close, color: Colors.grey),
                          )
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 22),

            // Send button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  // handle send logic (placeholder)
                  String message = 'Ticket sent successfully!';
                  if (attachedImage != null) {
                    message += '\nAttached: ${attachedImage!.name}';
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                },
                child: const Text('Gửi yêu cầu',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.blue : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? Colors.blue : Colors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: selected ? Colors.blue : Colors.black)),
                  Text(subtitle,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
            Radio<String>(
              value: title == 'Admin' ? 'Admin' : 'Representative',
              groupValue: selectedContact,
              onChanged: (_) => onTap(),
              activeColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      hint: Text(hint),
      value: value,
      items: items
          .map((e) => DropdownMenuItem<T>(
                value: e,
                child: Text(e.toString()),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _showAttachmentOptions() async {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Chọn ảnh từ thư viện'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Chụp ảnh'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              // document option removed
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Hủy'),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? file = await picker.pickImage(source: source, imageQuality: 85);
      if (file == null) return;

      final f = File(file.path);
      final bytes = await f.length();
      const maxBytes = 10 * 1024 * 1024; // 10MB
      if (bytes > maxBytes) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File quá lớn. Vui lòng chọn ảnh < 10MB.')),
        );
        return;
      }

      setState(() {
        attachedImage = file;
        attachedFile = f;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải ảnh: $e')),
      );
    }
  }


  String _formatFileSize(File? f) {
    if (f == null) return '';
    try {
      final bytes = f.lengthSync();
      if (bytes < 1024) return '$bytes B';
      final kb = bytes / 1024;
      if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
      final mb = kb / 1024;
      return '${mb.toStringAsFixed(2)} MB';
    } catch (_) {
      return '';
    }
  }

  // document picker removed — image-only attachments supported
}
