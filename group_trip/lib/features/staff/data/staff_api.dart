import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/core/config/secure_storage_service.dart';
import 'package:group_trip/features/staff/data/staff_data.dart';

class StaffRemoteDataSource {
    final ApiClient api;
    StaffRemoteDataSource({required this.api});

    Future<List<DepartureStaff>> fetchStaffs() async {
      // Get userId from secure storage
      
        final storage = SecureStorageService();
        final userId = await storage.getUserResponseFromJson().then((user) => user?.userId ?? '');

      
        final response = await api.get(
            'trip',
            'api/trips/departures/$userId',
        );
        if(response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 300) {
            dynamic payload = response.data;
            print('Staffs payload: $payload');
            if (payload is Map && payload.containsKey('data')) {
                payload = payload['data'];
            }

            if (payload is List) {
                return payload.map((item) {
                    final itemMap = Map<String, dynamic>.from(item as Map);
                    return DepartureStaff.fromJson(itemMap);
                }).toList();
            } else {
                throw Exception(
                    'Unexpected staffs payload shape: ${payload.runtimeType}',
                );
            }
        } else {
            throw Exception('Failed to load staffs: status=${response.statusCode}');
        }
    }


    
} 