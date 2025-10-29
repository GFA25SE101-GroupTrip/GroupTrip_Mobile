import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  final Dio dio;

  ApiClient._internal(this.dio);

  factory ApiClient() {
    final options = BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL']!,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    );

    final dio = Dio(options);

    // Interceptor (thêm token, log, xử lý lỗi)
    dio.interceptors.add(InterceptorsWrapper(
      onError: (e, handler) {
        print('❌ API Error: ${e.response?.statusCode}');
        return handler.next(e);
      },
    ));

    return ApiClient._internal(dio);
  }

  Future<Response> get(String path) => dio.get(path);
  Future<Response> post(String path, {dynamic data}) => dio.post(path, data: data);
}
