import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/features/blog/data/blog_model.dart';

class BlogRemoteDataSource {
    final ApiClient api;
    BlogRemoteDataSource({required this.api});

    Future<String> createBlog(BlogCreateModel model) async {
      print(
        '➡️ [BlogAPI] POST /blogs -> service=user payload=${model.toJson()}',
      );
      final response = await api.post(
        'user',
        '/api/blogs',
        data: model.toJson(),
      );
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      // success
      // ignore: avoid_print
      print('✅ Blog created successfully');
      // ignore: avoid_print

      print(response.data);
      final payload = response.data;
      if (payload is Map<String, dynamic> && payload.containsKey('data')) {
        return payload['data'] as String;
      } else {
        throw Exception(
          'Unexpected blog creation payload shape: ${payload.runtimeType}',
        );
      }
    } else {
      throw Exception(
        'Failed to create blog: status=${response.statusCode}',
      );
    }
  }

  Future<List<BlogModel>> fetchBlogs() async {
      print('➡️ [BlogAPI] GET /blogs -> service=user');
      final response = await api.get(
        'user',
        '/api/blogs',
      );
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        // success
        // ignore: avoid_print
        print('✅ Blogs fetched successfully');
        // ignore: avoid_print
        print(response.data);
        final payload = response.data;
        if (payload is Map<String, dynamic> && payload.containsKey('data')) {
          final data = payload['data'];
          if (data is List) {
            return data
                .map((item) => BlogModel.fromJson(item as Map<String, dynamic>))
                .toList();
          } else {
            throw Exception(
              'Unexpected blogs payload shape: ${data.runtimeType}',
            );
          }
        } else {
          throw Exception(
            'Unexpected blogs payload shape: ${payload.runtimeType}',
          );
        }
      } else {
        throw Exception(
          'Failed to fetch blogs: status=${response.statusCode}',
        );
      }
  }
    
}