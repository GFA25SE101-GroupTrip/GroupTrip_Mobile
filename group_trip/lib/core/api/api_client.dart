import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:group_trip/core/config/secure_storage_service.dart';

/// ApiClient that supports multiple service base URLs.
///
/// Environment variables accepted:
/// - API_BASE_URL: default base url
/// - API_BASE_<SERVICE>: service-specific base urls. Example: API_BASE_AUTH, API_BASE_USERS
class ApiClient {
  final SecureStorageService _secureStorage = SecureStorageService();

  // Map of serviceKey -> baseUrl
  final Map<String, String> _serviceBaseUrls;

  // Cache of Dio instances per serviceKey
  final Map<String, Dio> _dios = {};

  bool _isRefreshing = false;
  Future<void>? _refreshFuture;

  ApiClient._internal(this._serviceBaseUrls);

  /// Factory that reads environment variables to build service map.
  factory ApiClient.fromEnv() {
    final env = dotenv.env;

    // First, collect service-specific base urls using prefix API_BASE_
    final Map<String, String> services = {};
    env.forEach((k, v) {
      if (k.startsWith('API_BASE_') && k != 'API_BASE_URL') {
        final serviceKey = k.substring('API_BASE_'.length).toLowerCase();
        services[serviceKey] = v;
      }
    });

    // Default base url fallback
    final defaultBase = env['API_BASE_URL'] ?? '';
    if (defaultBase.isNotEmpty) {
      services['default'] = defaultBase;
    }

    if (services.isEmpty) {
      print('⚠️ No API_BASE_* entries found in .env — requests will use relative paths');
    }

    final client = ApiClient._internal(services);

    return client;
  }

  /// Get or create a Dio for [serviceKey]. If not found, falls back to 'default' or '' (relative).
  Dio _dioFor(String serviceKey) {
    final key = serviceKey.toLowerCase();
    if (_dios.containsKey(key)) return _dios[key]!;

    final baseUrl = _serviceBaseUrls[key] ?? _serviceBaseUrls['default'] ?? '';
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    );

    final dio = Dio(options);

    // Attach interceptors (request attaching token, and error refresh handling)
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.getAccessToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (err, handler) async {
        final statusCode = err.response?.statusCode;
        // Only try refresh on 401
        if (statusCode == 401) {
          final reqOptions = err.requestOptions;

          // If refresh in progress, wait
          if (_isRefreshing) {
            try {
              await (_refreshFuture ?? Future.value());
              final newToken = await _secureStorage.getAccessToken();
              if (newToken != null && newToken.isNotEmpty) {
                reqOptions.headers['Authorization'] = 'Bearer $newToken';
                final clone = await dio.fetch(reqOptions);
                return handler.resolve(clone);
              }
            } catch (_) {}
          } else {
            _isRefreshing = true;
            final completer = Completer<void>();
            _refreshFuture = completer.future;
            try {
              final refreshToken = await _secureStorage.getRefreshToken();
              if (refreshToken == null || refreshToken.isEmpty) {
                completer.complete();
                _isRefreshing = false;
                return handler.next(err);
              }

              // Use auth service if available for refresh, else current dio
              final authDio = _dios['auth'] ?? _createTempAuthDio();

              final resp = await authDio.post('api/auth/refresh-token', data: {
                'refreshToken': refreshToken,
              });

              final data = resp.data as Map<String, dynamic>;
              final newAccess = data['accessToken'] as String?;
              final newRefresh = data['refreshToken'] as String?;

              if (newAccess != null) {
                await _secureStorage.saveTokens(newAccess, newRefresh ?? refreshToken);
                reqOptions.headers['Authorization'] = 'Bearer $newAccess';
                final clone = await dio.fetch(reqOptions);
                completer.complete();
                _isRefreshing = false;
                return handler.resolve(clone);
              } else {
                completer.complete();
                _isRefreshing = false;
                return handler.next(err);
              }
            } catch (refreshErr) {
              try {
                await _secureStorage.clearAll();
              } catch (_) {}
              _isRefreshing = false;
              if (!completer.isCompleted) completer.complete();
              return handler.next(err);
            }
          }
        }

        return handler.next(err);
      },
    ));

    _dios[key] = dio;
    return dio;
  }

  /// Create a temporary Dio to call the auth refresh endpoint when no explicit 'auth' service is configured.
  Dio _createTempAuthDio() {
    final defaultBase = _serviceBaseUrls['default'] ?? '';
    final options = BaseOptions(baseUrl: defaultBase, headers: {'Content-Type': 'application/json'});
    return Dio(options);
  }

  /// Public helper: GET against a named service.
  Future<Response> get(String serviceKey, String path, {Map<String, dynamic>? queryParameters}) {
    final dio = _dioFor(serviceKey);
    return dio.get(path, queryParameters: queryParameters);
  }

  /// Public helper: POST against a named service.
  Future<Response> post(String serviceKey, String path, {dynamic data}) {
    final dio = _dioFor(serviceKey);
    return dio.post(path, data: data);
  }

  /// Convenience helpers that use 'default' service.
  Future<Response> getDefault(String path, {Map<String, dynamic>? queryParameters}) => get('default', path, queryParameters: queryParameters);
  Future<Response> postDefault(String path, {dynamic data}) => post('default', path, data: data);
}
