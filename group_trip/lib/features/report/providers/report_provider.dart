import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/api_client_provider.dart';
import 'package:group_trip/features/report/data/create_report_model.dart';
import 'package:group_trip/features/report/data/report_api.dart';
import 'package:group_trip/features/report/data/report_model.dart';
import 'package:group_trip/features/report/data/report_response.dart';
import 'package:group_trip/features/report/domain/report_respository.dart';

final reportRemoteDataSourceProvider = Provider<ReportRemoteDataSource>((ref) {
  return ReportRemoteDataSource(apiClient: ref.read(apiClientProvider));
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepository(
      remoteDataSource: ref.read(reportRemoteDataSourceProvider));
});

final reportListProvider =
    FutureProvider.family<List<ReportModel>, String>((ref, userID) async {
  final repository = ref.read(reportRepositoryProvider);
  return repository.getReports(userID);
});

final reportDetailProvider =
    FutureProvider.family<ReportResponse, String>((ref, reportID) async {
  final repository = ref.read(reportRepositoryProvider);
  return repository.getReportDetail(reportID);
});

// Provider để submit báo cáo
final submitReportProvider =
    FutureProvider.family<void, CreateReportModel>((ref, report) async {
  final repository = ref.read(reportRepositoryProvider);
  return repository.submitReport(report);
});