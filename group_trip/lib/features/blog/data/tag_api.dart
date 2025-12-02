import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/features/blog/data/tag_model.dart';

class TagRemoteDataSource 
{
  final ApiClient api;
  TagRemoteDataSource({required this.api});

  Future<List<TagModel>> fetchTags() async {
    final response = await api.get('trip','/api/tags');
    // Backend returns an envelope: { data: [ ... ], message: ..., code: ... }
    final payload = response.data;
    // print for debugging
    print('Fetched tags envelope: $payload');

    // Try to pull the list from payload['data'] if present, otherwise assume
    // response.data is already a List.
    final dynamic maybeList = (payload is Map && payload.containsKey('data'))
        ? payload['data']
        : payload;

    if (maybeList is List) {
      return maybeList.map<TagModel>((json) => TagModel.fromJson(Map<String, dynamic>.from(json))).toList();
    }

    // Fallback: return empty list if shape unexpected
    return <TagModel>[];
  }

  Future<void> createTag(String name, String description) async {
    await api.post('trip','/api/tags', data: {
      'name': name,
      'description': description,
    });
  }
}