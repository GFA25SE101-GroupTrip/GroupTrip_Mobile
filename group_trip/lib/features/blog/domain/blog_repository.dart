import 'package:group_trip/features/blog/data/blog_api.dart';
import 'package:group_trip/features/blog/data/blog_model.dart';

class BlogRepository {
  final BlogRemoteDataSource remoteDataSource;

  BlogRepository({required this.remoteDataSource});

  Future<String> createBlog(BlogCreateModel model) async {
    return await remoteDataSource.createBlog(model);
  }

  Future<List<BlogModel>> fetchBlogs() async {
    return await remoteDataSource.fetchBlogs(null, null);
  }

  Future<List<BlogModel>> fetchBlogsByFilter(String? fullName, String? title) async {
    return await remoteDataSource.fetchBlogs(fullName, title);
  }

  Future<void> deleteBlog(String blogId) async {
    await remoteDataSource.deleteBlog(blogId);
  }
}