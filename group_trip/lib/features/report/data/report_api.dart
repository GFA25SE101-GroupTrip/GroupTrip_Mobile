import 'package:dio/dio.dart';
import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/features/report/data/create_report_model.dart';
import 'package:group_trip/features/report/data/report_model.dart';
import 'package:group_trip/features/report/data/report_response.dart';

class ReportRemoteDataSource {
  final ApiClient apiClient;
  ReportRemoteDataSource({required this.apiClient});

  Future<List<ReportModel>> fetchReports(String userID) async {
    final response = await apiClient.get(
      'user',
      '/api/report/requests/$userID',
    );
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      dynamic payload = response.data;
      print('Reports payload: $payload');
      if (payload is Map && payload.containsKey('data')) {
        payload = payload['data'];
      }

      if (payload is List) {
        return payload
            .map((item) => ReportModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Unexpected reports payload shape: ${payload.runtimeType}',
        );
      }
    } else {
      throw Exception('Failed to load reports: status=${response.statusCode}');
    }
  }

  Future<ReportResponse> fetchReportDetail(String reportID) async {
    // https://gt-user.grouptrip.site/api/report/request/40e1a8db-9843-45cc-aa7d-adef67468707
    final response = await apiClient.get(
      'user',
      '/api/report/request/$reportID',
    );
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      dynamic payload = response.data;
      print('Report detail payload: $payload');
      if (payload is Map && payload.containsKey('data')) {
        payload = payload['data'];
      }

      if (payload is Map<String, dynamic>) {
        return ReportResponse.fromJson(payload);
      } else {
        throw Exception(
          'Unexpected report detail payload shape: ${payload.runtimeType}',
        );
      }
    } else {
      throw Exception(
        'Failed to load report detail: status=${response.statusCode}',
      );
    }
  }

 Future<void> submitReport(CreateReportModel report) async {
  try {
    final formData = await report.toFormData();
    print('Submitting report with FormData: ${formData.fields}, files count: ${formData.files.length}');
    await apiClient.postWithOptions(
      'user',
      '/api/report',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

  } on DioException catch (e) {
    // 👉 LẤY MESSAGE BACKEND
    final data = e.response?.data;

    String errorMessage = 'Gửi báo cáo thất bại';

    if (data is Map && data['errorMessage'] != null) {
      errorMessage = data['errorMessage'];
    }

    // 👉 THROW LẠI MESSAGE ĐÚNG
    throw Exception(errorMessage);

  } catch (e) {
    throw Exception('Lỗi không xác định: $e');
  }
}


  // Implementation of ReportRemoteDataSource
}
