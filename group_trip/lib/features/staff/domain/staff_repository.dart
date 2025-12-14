import 'package:group_trip/features/staff/data/staff_api.dart';
import 'package:group_trip/features/staff/data/staff_data.dart';

class StaffRepository {
    final StaffRemoteDataSource remoteDataSource;
    StaffRepository({required this.remoteDataSource});

    Future<List<DepartureStaff>> getStaffs() async {
        return await remoteDataSource.fetchStaffs();
    }
  
}