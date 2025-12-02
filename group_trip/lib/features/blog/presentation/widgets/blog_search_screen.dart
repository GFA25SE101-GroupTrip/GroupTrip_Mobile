import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/blog/providers/blog_provider.dart';
import 'package:group_trip/features/blog/presentation/blog_detail_screen.dart';

class BlogSearchScreen extends ConsumerStatefulWidget {
  const BlogSearchScreen({super.key});

  @override
  ConsumerState<BlogSearchScreen> createState() => _BlogSearchScreenState();
}



class _BlogSearchScreenState extends ConsumerState<BlogSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedTab = 'Tất cả';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.removeListener(() {});
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // elevation: 0,
        // Styled back button (leading) — rounded container with subtle shadow
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black87, size: 20),
              onPressed: () => Navigator.of(context).pop(),
              splashRadius: 22,
            ),
          ),
        ),
        title: _buildSearchField(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              'Kết quả tìm kiếm',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ref.watch(blogListProvider).when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Lỗi khi tải dữ liệu: $e'),
              ),
              data: (blogs) {
                final queryRaw = _searchController.text.trim();

                // If the user hasn't typed anything yet, show an instruction
                if (queryRaw.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(
                      child: Text(
                        'Vui lòng nhập vào để tìm kiếm',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                  );
                }

                final query = queryRaw.toLowerCase();
                final filtered = blogs.where((b) {
                  final title = b.title.toLowerCase();
                  final author = b.fullName.toLowerCase();
                  switch (selectedTab) {
                    case 'Tác giả':
                      return author.contains(query);
                    case 'Bài viết':
                      return title.contains(query);
                    default:
                      return title.contains(query) || author.contains(query);
                  }
                }).toList();

                if (filtered.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Text('Không tìm thấy kết quả phù hợp'),
                  );
                }

                return Column(
                  children: filtered.map((b) {
                    return GestureDetector(
                      onTap: () {
                        print('Tapped blog id: ${b.blogId}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => BlogDetailScreen(blog: b)),
                        );
                      },
                      child: _buildPostCard(
                        imageUrl: b.coverImage ?? 'https://res.cloudinary.com/db18zz55c/image/upload/v1762439871/uploads/scaled_38.jpg1/800/400',
                        title: b.title,
                        author: b.fullName,
                        authorAvatarUrl: b.userImage,
                        createdAt: b.created_at,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildSearchField() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8), // 👈 margin
    child: TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Tìm kiếm theo tác giả hoặc tiêu đề',
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}


  


  Widget _buildPostCard({
    required String imageUrl,
    required String title,
    required String author,
    String? authorAvatarUrl,
    String? createdAt,
    void Function()? onTap,
  }) {
    return 
     Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            // Cover image (made slightly larger)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
              child: Image.network(
                imageUrl,
                width: 120,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600, height: 1.3)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (authorAvatarUrl != null && authorAvatarUrl.trim().isNotEmpty) ...[
                          CircleAvatar(
                            radius: 12,
                            backgroundImage: NetworkImage(authorAvatarUrl),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: Text(
                            author,
                            style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
                          ),
                        ),
                        if (createdAt != null) ...[
                          const SizedBox(width: 8),
      
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              _timeAgo(createdAt),
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    
  }

  String _timeAgo(String isoDate) {
    if (isoDate.trim().isEmpty) return '';
    try {
      final s = isoDate.trim();

      // Detect if the string already contains timezone information (Z or ±HH:MM)
      final hasTz = RegExp(r'(Z|z|[+\-]\d{2}:\d{2})$').hasMatch(s);

      // If no timezone info is present, assume the server sent UTC without offset
      // and append 'Z' so DateTime.parse treats it as UTC. Otherwise parse as-is.
      final parsed = hasTz ? DateTime.parse(s) : DateTime.parse(s + 'Z');
      final dt = parsed.toLocal();

      final diff = DateTime.now().difference(dt);
      final isFuture = diff.isNegative;
      final absSeconds = diff.inSeconds.abs();
      final absMinutes = diff.inMinutes.abs();
      final absHours = diff.inHours.abs();
      final absDays = diff.inDays.abs();

      if (absSeconds < 60) return isFuture ? 'vài giây nữa' : 'vài giây trước';
      if (absMinutes < 60) return isFuture ? 'trong $absMinutes phút' : '$absMinutes phút trước';
      if (absHours < 24) return isFuture ? 'trong $absHours giờ' : '$absHours giờ trước';
      if (absDays < 30) return isFuture ? 'trong $absDays ngày' : '$absDays ngày trước';

      final months = (absDays / 30).floor();
      if (months < 12) return isFuture ? 'trong $months tháng' : '$months tháng trước';
      final years = (months / 12).floor();
      return isFuture ? 'trong $years năm' : '$years năm trước';
    } catch (_) {
      return '';
    }
  }
}
