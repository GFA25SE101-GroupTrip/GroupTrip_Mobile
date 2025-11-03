import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:group_trip/features/profile/presentation/widgets/profile_header.dart';

class ProfileDetailScreen extends ConsumerStatefulWidget {
  const ProfileDetailScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileDetailScreen> createState() =>
      _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends ConsumerState<ProfileDetailScreen> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController bioCtrl = TextEditingController();
  final TextEditingController bankAccountCtrl = TextEditingController();
  final TextEditingController bankNameCtrl = TextEditingController();

  File? _avatarFile;

  @override
  void initState() {
    super.initState();
    // initialize with empty or persisted values later
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    usernameCtrl.dispose();
    phoneCtrl.dispose();
    bioCtrl.dispose();
    bankAccountCtrl.dispose();
    bankNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await ImagePicker().pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _avatarFile = File(picked.path);
      });
    }
  }

  Future<String?> _showBankPicker() async {
    final banks = <String>['Vietcombank', 'Techcombank', 'BIDV', 'VPBank', 'MB Bank', 'Sacombank', 'TPBank'];
    String query = '';
    return await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setStateModal) {
          final filtered = banks.where((b) => b.toLowerCase().contains(query.toLowerCase())).toList();
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Tìm ngân hàng'),
                    onChanged: (v) => setStateModal(() => query = v),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final b = filtered[i];
                      return ListTile(
                        title: Text(b),
                        onTap: () => Navigator.of(ctx).pop(b),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        });
      },
    );
  }

  void _changePassword() {
    final pass1 = TextEditingController();
    final pass2 = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Đổi mật khẩu"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: pass1,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Mật khẩu mới"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: pass2,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Nhập lại mật khẩu",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              if (pass1.text == pass2.text && pass1.text.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đổi mật khẩu thành công!")),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Mật khẩu không khớp!")),
                );
              }
            },
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xóa tài khoản"),
        content: const Text(
          "Bạn có chắc chắn muốn xóa tài khoản này không?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Tài khoản đã bị xóa")),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Xóa"),
          ),
        ],
      ),
    );
  }

  Widget _inputField(
    TextEditingController controller,
    String label, {
    int minLines = 1,
    int? maxLines,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        minLines: minLines,
        maxLines: maxLines,
        expands: false,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF7F7FD5), // màu nhấn tím xanh gradient
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: const Color(0xFFF4F6FB), // nền sáng xanh xám
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD1D9E6), width: 1.2),
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF7F7FD5), width: 1.8),
            borderRadius: BorderRadius.circular(14),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text(
          "Profile Details",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.blue),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile saved successfully!')),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: ProfileHeader(
                nameCtrl: nameCtrl,
                emailCtrl: emailCtrl,
                bioCtrl: bioCtrl,
                avatarFile: _avatarFile,
                isEditing: true,
                onEditAvatar: () => showModalBottomSheet(
                  context: context,
                  builder: (_) => SafeArea(
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.photo_library),
                          title: const Text('Chọn từ thư viện'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage(ImageSource.gallery);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text('Chụp ảnh'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage(ImageSource.camera);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                onSaveAvatarBio: () {
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ảnh/Bio đã lưu (chưa upload)')));
                },
              ),
            ),

            // Personal Info
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.person_outline, color: Colors.blue),
                    title: Text(
                      "Thông tin cá nhân",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  _inputField(usernameCtrl, "Username"),
                  _inputField(phoneCtrl, "Phone number"),
                  _inputField(emailCtrl, "Email"),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Payment Info
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.credit_card, color: Colors.teal),
                    title: Text(
                      "Thông tin thanh toán",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  _inputField(bankAccountCtrl, "Bank Account"),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: InkWell(
                      onTap: () async {
                        final selected = await _showBankPicker();
                        if (selected != null) {
                          setState(() {
                            bankNameCtrl.text = selected;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Bank Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              bankNameCtrl.text.isEmpty
                                  ? 'Chọn ngân hàng'
                                  : bankNameCtrl.text,
                            ),
                            const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Buttons
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.lock_outline,
                      color: Colors.orange,
                    ),
                    title: const Text("Change Password"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _changePassword,
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    title: const Text(
                      "Delete Account",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.red,
                    ),
                    onTap: _deleteAccount,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
