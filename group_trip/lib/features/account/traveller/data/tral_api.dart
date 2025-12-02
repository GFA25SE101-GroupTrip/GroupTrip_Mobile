import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/features/account/traveller/data/tral_model.dart';

class TravellerResourceData {
  final ApiClient api;

  TravellerResourceData({required this.api});

  Future<TravellerModel> fetchUserProfile(String userID) async {
    // Log request for debugging so we can confirm network activity
    // ignore: avoid_print
    print('➡️ [ProfileAPI] GET /profiles/current-user -> service=user');
    final response = await api.get('user', '/api/profiles/current-user', queryParameters: {'id': userID});
    // ignore: avoid_print
    print(
      '⬅️ [ProfileAPI] GET /profiles/current-user status=${response.statusCode} data=${response.data}',
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      // The backend wraps response in { data: { ... } } — handle that shape.
      dynamic payload = response.data;
      if (payload is Map && payload.containsKey('data')) {
        payload = payload['data'];
      }

      if (payload is Map<String, dynamic>) {
        return TravellerModel.fromJson(payload);
      } else {
        throw Exception(
          'Unexpected profile payload shape: ${payload.runtimeType}',
        );
      }
    } else {
      throw Exception('Failed to load profile: status=${response.statusCode}');
    }
  }

 Future<List<BlogsTraveller>> fetchBlogsByTraveller(String userID) async {
  print('➡️ [ProfileAPI] GET /blogs/by-user -> service=default');
  final response = await api.get('user', '/api/blogs/userblogs/$userID');

  print('⬅️ [ProfileAPI] GET /blogs/by-user status=${response.statusCode} data=${response.data}');

  if (response.statusCode != null &&
      response.statusCode! >= 200 &&
      response.statusCode! < 300) {
    dynamic payload = response.data;
    if (payload is Map && payload.containsKey('data')) {
      payload = payload['data'];
    }

    if (payload is List) {
      return payload
          .map((e) => BlogsTraveller.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Unexpected blogs payload shape: ${payload.runtimeType}');
    }
  } else {
    throw Exception('Failed to load blogs: status=${response.statusCode}');
  }
}

}