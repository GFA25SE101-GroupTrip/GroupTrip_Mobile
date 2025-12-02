import 'package:group_trip/features/blog/data/tag_api.dart';
import 'package:group_trip/features/blog/data/tag_model.dart';

class TagRespository {
  final TagRemoteDataSource remoteDataSource;
  TagRespository({required this.remoteDataSource});
  Future<List<TagModel>> getTags() async {
    try {
      return await remoteDataSource.fetchTags();
    } catch (e) {
      rethrow;
    }
  }
  Future<void> addTag(String name, String description) async {
    try {
      return await remoteDataSource.createTag(name, description);
    } catch (e) {
      rethrow;
    }
  }
}