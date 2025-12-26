import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/features/insurance/data/insurance_data.dart';

class InsuranceRemoteDataSource {
  final ApiClient apiClient;

  InsuranceRemoteDataSource({required this.apiClient});


  Future<List<InsuranceUser>> fetchUserInsurance() async {
    final response = await apiClient.get('trip', '/api/insurance/user-insurance');
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      dynamic payload = response.data;
      print('User Insurance payload: $payload');
      if (payload is Map && payload.containsKey('data')) {
        payload = payload['data'];
      }

      if (payload is List) {
        return payload
            .map((item) => InsuranceUser.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (payload is Map<String, dynamic>) {
        return payload.entries.map((entry) {
          final itemMap = Map<String, dynamic>.from(entry.value as Map);
          return InsuranceUser.fromJson(itemMap);
        }).toList();
      } else {
        throw Exception(
          'Unexpected user insurance payload shape: ${payload.runtimeType}',
        );
      }
    } else {
      throw Exception('Failed to load user insurance: status=${response.statusCode}');
    }
  }
}