import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/api_client_provider.dart';
import 'package:group_trip/features/staff/data/staff_api.dart';
import 'package:group_trip/features/staff/data/staff_data.dart';
import 'package:group_trip/features/staff/domain/staff_repository.dart';


final StaffRemoteDataSourceProvider = Provider<StaffRemoteDataSource>((ref) {
    final apiClient = ref.watch(apiClientProvider);
    return StaffRemoteDataSource(api: apiClient);
});

final staffRepositoryProvider = Provider<StaffRepository>((ref) {
    final remoteDataSource = ref.watch(StaffRemoteDataSourceProvider);
    return StaffRepository(remoteDataSource: remoteDataSource);
});
final StaffModelProvider = FutureProvider.autoDispose<List<DepartureStaff>>((ref) async {
    final staffRepository = ref.watch(staffRepositoryProvider);
    return staffRepository.getStaffs();
});