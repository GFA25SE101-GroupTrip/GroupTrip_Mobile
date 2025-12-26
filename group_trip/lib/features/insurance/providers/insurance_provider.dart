import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/api_client_provider.dart';
import 'package:group_trip/features/insurance/data/insurance_api.dart';
import 'package:group_trip/features/insurance/data/insurance_data.dart';
import 'package:group_trip/features/insurance/domain/insurance_repository.dart';

final InsuranceRemoteDataSourceProvider = Provider((ref) {
  print('✅ InsuranceRemoteDataSourceProvider initialized');
  return InsuranceRemoteDataSource(apiClient: ref.watch(apiClientProvider));
});

final insuranceRepositoryProvider = Provider((ref) {
  print('✅ insuranceRepositoryProvider initialized');
  return InsuranceRepository(
      remoteDataSource: ref.watch(InsuranceRemoteDataSourceProvider));
});

final insuranceListProvider =
    FutureProvider.autoDispose<List<InsuranceUser>>((ref) async {
  print('✅ insuranceListProvider initialized');
  final repository = ref.watch(insuranceRepositoryProvider);
  return await repository.fetchUserInsurance();
});