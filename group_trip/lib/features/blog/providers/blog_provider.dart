import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/api_client_provider.dart';
import 'package:group_trip/features/blog/data/blog_api.dart';
import 'package:group_trip/features/blog/data/blog_model.dart';
import 'package:group_trip/features/blog/domain/blog_repository.dart';

final blogRemoteDataSourceProvider = Provider<BlogRemoteDataSource>((ref) {
  print('✅ blogRemoteDataSourceProvider initialized');
  final apiClient = ref.watch(apiClientProvider);
  return BlogRemoteDataSource(api: apiClient);
});
final blogRepositoryProvider = Provider<BlogRepository>((ref) {
  final blogApi = ref.watch(blogRemoteDataSourceProvider);
  return BlogRepository(remoteDataSource: blogApi);
});

final blogNotifierProvider =
    StateNotifierProvider<BlogNotifier, AsyncValue<void>>((ref) {
  print('✅ blogNotifierProvider initialized');
  final repository = ref.watch(blogRepositoryProvider);
  return BlogNotifier(repository: repository);
});

/// A simple provider to fetch the list of blogs for UI.
final blogListProvider = FutureProvider<List<BlogModel>>((ref) async {
  final repository = ref.watch(blogRepositoryProvider);
  // Fetch blogs and sort newest first by `created_at`.
  final blogs = await repository.fetchBlogs();
  try {
    final sorted = List<BlogModel>.from(blogs);
    sorted.sort((a, b) {
      try {
        final da = DateTime.parse(a.created_at);
        final db = DateTime.parse(b.created_at);
        return db.compareTo(da); // descending: newest first
      } catch (_) {
        return 0;
      }
    });
    return sorted;
  } catch (e) {
    // If sorting fails for any reason, return unsorted list
    return blogs;
  }
});

class BlogNotifier extends StateNotifier<AsyncValue<void>> {
  final BlogRepository repository;

  BlogNotifier({required this.repository}) : super(const AsyncValue.data(null));

  Future<String?> createBlog(BlogCreateModel model) async {
    state = const AsyncValue.loading();
    try {
      final response = await repository.createBlog(model);
      state = const AsyncValue.data(null);
      return response;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
  Future<List<BlogModel>?> fetchBlogs() async {
    state = const AsyncValue.loading();
    try {
      final response = await repository.fetchBlogs();
      state = const AsyncValue.data(null);
      return response;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<void> deleteBlog(String blogId) async {
    state = const AsyncValue.loading();
    try {
      await repository.deleteBlog(blogId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<List<BlogModel>?> fetchBlogsByFilter(String? fullName, String? title) async {
    state = const AsyncValue.loading();
    try {
      final response = await repository.fetchBlogsByFilter(fullName, title);
      state = const AsyncValue.data(null);
      return response;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}