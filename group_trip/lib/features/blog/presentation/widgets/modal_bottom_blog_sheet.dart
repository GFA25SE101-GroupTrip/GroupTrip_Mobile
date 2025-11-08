import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/image_provider.dart';
import 'package:group_trip/features/blog/data/blog_model.dart';
import 'package:group_trip/features/blog/providers/blog_provider.dart';
import 'package:group_trip/features/blog/providers/tag_provider.dart';
import 'package:group_trip/features/blog/data/tag_model.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class CreateBlogBottomSheet extends ConsumerStatefulWidget {
  const CreateBlogBottomSheet({super.key});

  @override
  ConsumerState<CreateBlogBottomSheet> createState() =>
      _CreateBlogBottomSheetState();
}

class _CreateBlogBottomSheetState extends ConsumerState<CreateBlogBottomSheet> {
  File? _coverImage;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final List<String> _tags = [];
  final List<String> _selectedTagIds = []; // store selected tag ids (to send to backend)
  List<TagModel> _allTags = [];
  List<TagModel> _suggestions = [];
  int _createdTagCount = 0; // how many tags created in this flow
  // Validation error messages (shown under inputs)
  String? _imageError;
  String? _titleError;
  String? _contentError;
  String? _tagsError;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // fetch all tags once and keep locally for suggestion matching
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final tagNotifier = ref.read(tagNotifierProvider.notifier);
      try {
        final list = await tagNotifier.fetchTags();
        setState(() {
          _allTags = list;
        });
      } catch (_) {}
    });
    _tagController.addListener(() {
      // call async updater (don't await in listener)
      _updateSuggestions();
    });
    // track title/content changes to update validation state and clear errors when fixed
    _titleController.addListener(() {
      final len = _titleController.text.trim().length;
      if (_titleError != null && len >= 5 && len <= 100) {
        setState(() => _titleError = null);
      } else {
        setState(() {});
      }
    });
    _contentController.addListener(() {
      final len = _contentController.text.trim().length;
      if (_contentError != null && len >= 100 && len <= 500) {
        setState(() => _contentError = null);
      } else {
        setState(() {});
      }
    });
    // clear tag error when user types
    _tagController.addListener(() {
      if (_tagsError != null && _selectedTagIds.length >= 2) setState(() => _tagsError = null);
    });
  }

  Future<void> _updateSuggestions() async {
    final q = _tagController.text.trim();
    if (q.isEmpty) {
      if (_suggestions.isNotEmpty) setState(() => _suggestions = []);
      return;
    }

    // ensure we have tags loaded; fetch if empty
    if (_allTags.isEmpty) {
      final tagNotifier = ref.read(tagNotifierProvider.notifier);
      try {
        final list = await tagNotifier.fetchTags();
        _allTags = list;
      } catch (e) {
        // ignore fetch error; leave suggestions empty
      }
    }

    final qlow = q.toLowerCase();
    final matches = _allTags.where((t) => t.name.toLowerCase().contains(qlow)).toList();
    if (mounted) setState(() => _suggestions = matches);
  }

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
        _imageError = null; // clear image error when user picks one
      });
    }
  }

  bool _validate() {
    var ok = true;
    setState(() {
      _imageError = null;
      _titleError = null;
      _contentError = null;
      _tagsError = null;

      if (_coverImage == null) {
        _imageError = 'Vui lòng chọn ảnh bìa trước khi đăng';
        ok = false;
      }
      final title = _titleController.text.trim();
      if (title.length < 5 || title.length > 100) {
        _titleError = 'Tiêu đề phải có 5-100 ký tự';
        ok = false;
      }
      final content = _contentController.text.trim();
      if (content.length < 100 || content.length > 500) {
        _contentError = 'Nội dung phải có tối thiểu 100 chữ và tối đa 500 chữ';
        ok = false;
      }
      if (_selectedTagIds.length < 2) {
        _tagsError = 'Vui lòng chọn ít nhất 2 tag';
        ok = false;
      } else if (_selectedTagIds.length > 5) {
        _tagsError = 'Tối đa 5 tag';
        ok = false;
      }
    });
    return ok;
  }

  Future<void> _createBlog() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final coverImage = _coverImage;
    List<BlogTag> tags = [];

    final selectedTagIds = _selectedTagIds;

    tags = selectedTagIds.map((id) {
      return BlogTag(blogId: '3fa85f64-5717-4562-b3fc-2c963f66afa6', tagId: id);
    }).toList();
    
    // Validation
    // Validation (show inline errors)
  if (!_validate()) return;
  final blogNotifier = ref.read(blogNotifierProvider.notifier);
    BlogCreateModel data = BlogCreateModel(
      title: title,
      content: content,
      publish_date: DateTime.now().toUtc().toIso8601String(),
      tags: tags,
    );
    print('Creating blog with data: ${data.toJson()}');
    final blogId = await blogNotifier.createBlog(data);
    // upload cover image if exists
    print(coverImage);
      if (blogId != null) {
        try {
          await ref.read(imageProvider.notifier).uploadImage(coverImage!, blogId);

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng bài thành công')));
        } catch (e) {
          // ignore: avoid_print
          print('Failed to upload cover image: $e');
        }
      }
    // refresh the blog list provider (ignore the returned value)
    var _ = ref.refresh(blogListProvider);

  }

  Future<void> _addTag(String tag) async {
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      final tagNotifier = ref.read(tagNotifierProvider.notifier);
      // check total selected limit
      if (_selectedTagIds.length >= 5) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chỉ được chọn tối đa 5 tag')));
        _tagController.clear();
        return;
      }
      // creating new tags per flow limited to 3
      if (_createdTagCount >= 3) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chỉ được tạo tối đa 3 tag mới')));
        _tagController.clear();
        return;
      }

      try {
        // If tag exists in local cache, select it instead of creating
        final existing = _allTags.firstWhere((t) => t.name.toLowerCase() == tag.toLowerCase(), orElse: () => TagModel(id: '', name: '', description: ''));
        if (existing.id.isNotEmpty) {
          if (!_selectedTagIds.contains(existing.id) && _selectedTagIds.length < 5) {
            setState(() {
              _selectedTagIds.add(existing.id);
              _tags.add(existing.name);
              _tagsError = null;
            });
          }
        } else {
          // create tag on server
          await tagNotifier.addTag(tag, 'This is blog tag created from traveller');
          // re-fetch tags and try to find the created tag to get its id
          final fresh = await tagNotifier.fetchTags();
          // update local cache
          setState(() => _allTags = fresh);
          final created = fresh.firstWhere(
            (t) => t.name.toLowerCase() == tag.toLowerCase(),
            orElse: () => TagModel(id: '', name: '', description: ''),
          );
          setState(() {
            if (created.id.isNotEmpty) {
              if (!_selectedTagIds.contains(created.id)) _selectedTagIds.add(created.id);
              if (!_tags.contains(created.name)) _tags.add(created.name);
              _createdTagCount++;
              _tagsError = null;
            } else {
              // fallback: add by name
              if (!_tags.contains(tag)) _tags.add(tag);
            }
          });
        }
      } catch (e) {
        // ignore: avoid_print
        print('Failed to create/select tag: $e');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tạo tag thất bại')));
      }
    }
    _tagController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(imageProvider);
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
                  // Image error message
                  if (_imageError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(_imageError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
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
                      errorText: _titleError,
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
                  // tag error message
                  if (_tagsError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(_tagsError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                    ),
                  const SizedBox(height: 8),
                  // Show selected tags as chips
                  if (_tags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _tags.map((name) {
                        final idx = _tags.indexOf(name);
                        final color = _tagColors[idx % _tagColors.length];
                        return InputChip(
                          label: Text('#$name', style: const TextStyle(fontSize: 12)),
                          onDeleted: () {
                            // find corresponding id by name in _allTags
                            final model = _allTags.firstWhere((t) => t.name == name, orElse: () => TagModel(id: '', name: '', description: ''));
                            setState(() {
                              if (model.id.isNotEmpty) _selectedTagIds.remove(model.id);
                              _tags.remove(name);
                              // update tags error state
                              if (_selectedTagIds.length < 2) {
                                _tagsError = 'Vui lòng chọn ít nhất 2 tag';
                              } else {
                                _tagsError = null;
                              }
                            });
                          },
                          backgroundColor: color.withOpacity(0.2),
                        );
                      }).toList(),
                    ),

                  // Suggestions list (show while typing)
                  if (_suggestions.isNotEmpty)
                    Container(
                      constraints: const BoxConstraints(maxHeight: 160),
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _suggestions.length,
                        itemBuilder: (ctx, i) {
                          final t = _suggestions[i];
                          final alreadySelected = _selectedTagIds.contains(t.id);
                          return ListTile(
                            title: Text(t.name),
                            trailing: alreadySelected ? const Icon(Icons.check, color: Colors.green) : null,
                            onTap: () {
                              if (_selectedTagIds.length >= 5 && !alreadySelected) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chỉ được chọn tối đa 5 tag')));
                                return;
                              }
                              setState(() {
                                if (!alreadySelected) {
                                  _selectedTagIds.add(t.id);
                                  _tags.add(t.name);
                                    // clear tag error if now meets minimum
                                    if (_selectedTagIds.length >= 2) _tagsError = null;
                                } else {
                                  _selectedTagIds.remove(t.id);
                                  _tags.remove(t.name);
                                }
                                _suggestions = [];
                                _tagController.clear();
                              });
                            },
                          );
                        },
                      ),
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
                    maxLength: 500,
                    decoration: InputDecoration(
                      hintText: "Chia sẻ trải nghiệm du lịch của bạn...",
                      alignLabelWithHint: true,
                      filled: true,
                      errorText: _contentError,
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
                        child: ElevatedButton(
                          onPressed: _createBlog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007BFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            uploadState.isLoading ? 'Đang đăng...' : "Đăng bài",
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
