import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/api_client_provider.dart';
import 'package:group_trip/features/staff/data/staff_api.dart';
import 'package:group_trip/features/staff/data/staff_data.dart';
import 'package:group_trip/features/staff/domain/staff_repository.dart';
import 'package:group_trip/features/trip/data/trip_rel_model.dart';
import 'package:group_trip/features/trip/providers/tripProvider.dart';


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

/// 📍 Model để chứa một vị trí (địa điểm) trên bản đồ
class LocationPoint {
  final double latitude;
  final double longitude;
  final String name;
  final String type; // 'trip', 'segment', 'poi'

  LocationPoint({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.type,
  });
}

/// 📍 Provider: Extract tất cả các vị trí (long/lat) từ Trip Detail
/// Tập hợp từ:
/// - TripModel (fromLat, fromLong - toLat, toLong)
/// - TripSegment (fromLat, fromLong - toLat, toLong)
/// - SegmentPOIs (poiLatitude, poiLongtitude)
final tripLocationsProvider = FutureProvider.autoDispose.family<List<LocationPoint>, String>(
  (ref, tripId) async {
    final tripDetailAsyncValue = ref.watch(TripDetailModelProvider(tripId));
    
    return tripDetailAsyncValue.when(
      loading: () => [],
      error: (err, st) {
        print('❌ Error fetching trip locations: $err');
        return [];
      },
      data: (tripModel) {
        if (tripModel == null) return [];
        
        final locations = <LocationPoint>[];
        
        // 1️⃣ Thêm vị trí khởi đầu của Trip
        if (tripModel.fromLatitude != null && tripModel.fromLongtitude != null) {
          try {
            final lat = double.parse(tripModel.fromLatitude!);
            final lng = double.parse(tripModel.fromLongtitude!);
            locations.add(LocationPoint(
              latitude: lat,
              longitude: lng,
              name: tripModel.fromDestination ?? 'Điểm đầu',
              type: 'trip',
            ));
          } catch (_) {}
        }
        
        // 2️⃣ Thêm vị trí kết thúc của Trip
        if (tripModel.finalLatitude != null && tripModel.finalLongtitude != null) {
          try {
            final lat = double.parse(tripModel.finalLatitude!);
            final lng = double.parse(tripModel.finalLongtitude!);
            locations.add(LocationPoint(
              latitude: lat,
              longitude: lng,
              name: tripModel.finalDestination ?? 'Điểm cuối',
              type: 'trip',
            ));
          } catch (_) {}
        }
        
        // 3️⃣ Thêm vị trí từ các Segment
        for (final segment in tripModel.tripSegments) {
          // Vị trí bắt đầu segment
          if (segment.fromLatitude != null && segment.fromLongtitude != null) {
            try {
              final lat = double.parse(segment.fromLatitude!);
              final lng = double.parse(segment.fromLongtitude!);
              locations.add(LocationPoint(
                latitude: lat,
                longitude: lng,
                name: segment.fromDestination,
                type: 'segment',
              ));
            } catch (_) {}
          }
          
          // Vị trí kết thúc segment
          if (segment.toLatitude != null && segment.toLongtitude != null) {
            try {
              final lat = double.parse(segment.toLatitude!);
              final lng = double.parse(segment.toLongtitude!);
              locations.add(LocationPoint(
                latitude: lat,
                longitude: lng,
                name: segment.toDestination,
                type: 'segment',
              ));
            } catch (_) {}
          }
          
          // 4️⃣ Thêm vị trí từ các POI (Point of Interest)
          for (final poi in segment.segmentPOIs) {
            if (poi.poiLatitude != null && poi.poiLongtitude != null) {
              try {
                final lat = double.parse(poi.poiLatitude!);
                final lng = double.parse(poi.poiLongtitude!);
                locations.add(LocationPoint(
                  latitude: lat,
                  longitude: lng,
                  name: poi.name,
                  type: 'poi',
                ));
              } catch (_) {}
            }
          }
        }
        
        // ✅ Lọc bỏ các vị trí trùng lặp (dựa trên latitude + longitude)
        final uniqueLocations = <LocationPoint>[];
        final seenCoordinates = <String>{};
        
        for (final loc in locations) {
          final key = '${loc.latitude},${loc.longitude}';
          if (!seenCoordinates.contains(key)) {
            seenCoordinates.add(key);
            uniqueLocations.add(loc);
          }
        }
        
        print('📍 Tập hợp ${uniqueLocations.length} vị trí (từ ${locations.length} vị trí sau lọc trùng) từ trip $tripId');
        print(uniqueLocations.map((e) => '${e.type}: ${e.name} (${e.latitude}, ${e.longitude})').join('\n'));
        return uniqueLocations;
      },
    );
  },
);
