import 'package:group_trip/features/blog/data/blog_api.dart';
import 'package:group_trip/features/blog/data/blog_model.dart';

class BlogRepository {
  final BlogRemoteDataSource remoteDataSource;

  BlogRepository({required this.remoteDataSource});

  Future<String> createBlog(BlogCreateModel model) async {
    return await remoteDataSource.createBlog(model);
  }

  Future<List<BlogModel>> fetchBlogs() async {
    return await remoteDataSource.fetchBlogs();
  }
}