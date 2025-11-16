import 'package:group_trip/features/report/data/report_api.dart';
import 'package:group_trip/features/report/data/report_model.dart';
import 'package:group_trip/features/report/data/report_response.dart';

class ReportRepository {
  final ReportRemoteDataSource remoteDataSource;
  ReportRepository({required this.remoteDataSource});

  Future<List<ReportModel>> getReports(String userID) async {
    return await remoteDataSource.fetchReports(userID);
  }

  Future<ReportResponse> getReportDetail(String reportID) async {
    return await remoteDataSource.fetchReportDetail(reportID);
  }
  // Define methods for reporting functionality here
}