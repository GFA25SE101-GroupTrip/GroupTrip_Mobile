import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class CreateBlogBottomSheet extends StatefulWidget {
  const CreateBlogBottomSheet({super.key});

  @override
  State<CreateBlogBottomSheet> createState() => _CreateBlogBottomSheetState();
}

class _CreateBlogBottomSheetState extends State<CreateBlogBottomSheet> {
  File? _coverImage;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final List<String> _tags = [];

  final List<Color> _tagColors = [
    Color(0xFFADD8E6),
    Color(0xFFFFB6C1),
    Color(0xFFFFD580),
    Color(0xFFB0E57C),
    Color(0xFFD8B4E2),
  ];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    // Mở thư viện ảnh
    final XFile? picked = await picker.pickImage(
      source:
          ImageSource.gallery, // 👈 Đổi sang ImageSource.camera nếu cần chụp
      maxWidth: 1024,
      imageQuality: 85,
    );

    if (picked != null) {
      setState(() {
        _coverImage = File(picked.path);
      });
    }
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
      });
    }
    _tagController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.80,
      minChildSize: 0.75,
      maxChildSize: 0.98,
      builder:
          (context, scrollController) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 50,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                       ),
                    ),
                  ),

                  // Ảnh bìa
                  Text(
                    "Ảnh bìa",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child:
                          _coverImage == null
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.camera_alt_outlined,
                                      size: 28,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Chạm để thêm ảnh bìa\nHoặc chụp từ camera",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _coverImage!,
                                  width: double.infinity,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tiêu đề
                  Text(
                    "Tiêu đề",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    maxLength: 100,
                    decoration: InputDecoration(
                      hintText: "Nhập tiêu đề bài viết...",
                      counterText: '',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tags
                  Text("Tags", style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _tagController,
                    onSubmitted: _addTag,
                    decoration: InputDecoration(
                      hintText: "Thêm tag...",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _addTag(_tagController.text),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        _tags.map((tag) {
                          final color =
                              _tagColors[_tags.indexOf(tag) %
                                  _tagColors.length];
                          return Chip(
                            label: Text(
                              '#$tag',
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: color.withOpacity(0.3),
                            side: BorderSide.none,
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () {
                              setState(() => _tags.remove(tag));
                            },
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // Nội dung
                  Text(
                    "Nội dung",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _contentController,
                    maxLines: 6,
                    maxLength: 2000,
                    decoration: InputDecoration(
                      hintText: "Chia sẻ trải nghiệm du lịch của bạn...",
                      alignLabelWithHint: true,
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade700,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Lưu nháp"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007BFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            "Đăng bài",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
    );
  }
}
