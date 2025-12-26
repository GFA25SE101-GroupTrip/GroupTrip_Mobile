import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/api_client_provider.dart';
import 'package:group_trip/features/auth/providers/user_provider.dart';
import 'package:group_trip/features/staff/data/staff_api.dart';
import 'package:group_trip/features/staff/data/staff_data.dart';

// Provider for API data source
final staffRemoteDataSourceProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return StaffRemoteDataSource(api: apiClient);
});

// Provider for fetching staff departures
final staffDeparturesProvider =
    FutureProvider<List<DepartureStaff>>((ref) async {
  // Watch auth state to invalidate cache when logout/login changes
  ref.watch(authNotifierProvider);
  
  final remoteDataSource = ref.watch(staffRemoteDataSourceProvider);
  return remoteDataSource.fetchStaffs();
});

// Model for Staff Trip Display
class StaffTripModel {
  final String id;
  final String name;
  final String? image;
  final String startDate;
  final String endDate;
  final String statusGroup; // "Sắp diễn ra", "Đang diễn ra", "Đã diễn ra"
  final String departureStatus; // Original status
  final int memberCount;

  StaffTripModel({
    required this.id,
    required this.name,
    required this.image,
    required this.startDate,
    required this.endDate,
    required this.statusGroup,
    required this.departureStatus,
    required this.memberCount,
  });
}

// Helper function to map departure status to group
String _mapStatusToGroup(String status) {
  final lowerStatus = status.toLowerCase();
  
  // Sắp diễn ra (Upcoming)
  if (['ready', 'full', 'fullpayment', 'deposit', 'pending']
      .contains(lowerStatus)) {
    return 'Sắp diễn ra';
  }
  
  // Đang diễn ra (In Progress)
  if (lowerStatus == 'inprogress') {
    return 'Đang diễn ra';
  }
  
  // Đã diễn ra (Completed)
  if (['completed', 'canceled'].contains(lowerStatus)) {
    return 'Đã diễn ra';
  }
  
  return 'Khác';
}

// Provider to transform DepartureStaff to StaffTripModel
final staffTripsProvider = FutureProvider<List<StaffTripModel>>((ref) async {
  final departures = await ref.watch(staffDeparturesProvider.future);
  
  return departures
      .map((departure) => StaffTripModel(
            id: departure.id,
            name: departure.tripName,
            image: departure.tripImages.isNotEmpty
                ? departure.tripImages.first
                : null,
            startDate: departure.startDate,
            endDate: departure.endDate,
            statusGroup: _mapStatusToGroup(departure.departureStatus),
            departureStatus: departure.departureStatus,
            memberCount: departure.numberMemberIn,
          ))
      .toList();
});

// Provider to get trips grouped by status
final staffTripsByStatusProvider =
    FutureProvider.family<List<StaffTripModel>, String>((ref, statusGroup) async {
  final trips = await ref.watch(staffTripsProvider.future);
  print('Filtering trips for status group: $statusGroup');
  return trips.where((trip) => trip.statusGroup == statusGroup).toList();
});


final staffUpdateCheckingProvider = FutureProvider.family<void, Map<String, String>>(
    (ref, params) async {
  final remoteDataSource = ref.watch(staffRemoteDataSourceProvider);
  await remoteDataSource.updateSegmentStatus(
    activityId: params['activityId']!,
    tripId: params['tripId']!,
    departureId: params['departureId']!,
    activityPhase: params['activityPhase']!,
  );
});