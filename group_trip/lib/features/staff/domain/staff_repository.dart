import 'package:group_trip/features/staff/data/staff_api.dart';
import 'package:group_trip/features/staff/data/staff_data.dart';

class StaffRepository {
    final StaffRemoteDataSource remoteDataSource;
    StaffRepository({required this.remoteDataSource});

    Future<List<DepartureStaff>> getStaffs() async {
        return await remoteDataSource.fetchStaffs();
    }

    Future<void> updateSegmentStatus({
        required String activityId,
        required String tripId,
        required String departureId,
        required String activityPhase,
    }) async {
        return await remoteDataSource.updateSegmentStatus(
            activityId: activityId,
            tripId: tripId,
            departureId: departureId,
            activityPhase: activityPhase,
        );
    }
  
}