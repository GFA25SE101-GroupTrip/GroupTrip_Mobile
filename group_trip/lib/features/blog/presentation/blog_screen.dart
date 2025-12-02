import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/blog/presentation/blog_detail_screen.dart';
import 'package:group_trip/features/blog/presentation/widgets/blog_card.dart';
import 'package:group_trip/features/blog/presentation/widgets/modal_bottom_blog_sheet.dart';
import 'package:group_trip/features/blog/providers/blog_provider.dart';
import 'package:group_trip/shared/widgets/appbars/blog_app_bar.dart';

class BlogScreen extends ConsumerWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blogListAsync = ref.watch(blogListProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Builder(
          builder: (innerContext) => BlogAppBar(
            onSearch: (value) => print('Đang tìm: $value'),
            onAddPost: () {
              showModalBottomSheet(
                context: innerContext,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const CreateBlogBottomSheet(),
              );
            },
          ),
        ),
      ),
      body: blogListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Lỗi khi tải bài viết: $e')),
        data: (blogs) {
          if (blogs.isEmpty) {
            return const Center(child: Text('Không có bài viết nào'));
          }
          return ListView.builder(
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              final b = blogs[index];
              return BlogCard(
                viewDetail: () {
                  print('Tapped blog item index=$index id=${b.blogId}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlogDetailScreen(blog: b),
                    ),
                  );
                },
                imageUrl: b.coverImage,
                title: b.title,
                author: b.fullName,
                authorAvatar: b.userImage,
                tags: b.tags.map((t) => t.name).toList(),
                likes: 0,
                category: '',
              );
            },
          );
        },
      ),
    );
  }
}
