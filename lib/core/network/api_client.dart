import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  final Dio dio;
  final Future<String?> Function() getToken;
  final Future<bool> Function()? onUnauthorized;
  Completer<bool>? _refreshCompleter;

  ApiClient({
    required String baseUrl,
    required this.getToken,
    this.onUnauthorized,
  }) : dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: const Duration(seconds: 15),
           receiveTimeout: const Duration(seconds: 15),
           headers: {
             'Content-Type': 'application/json',
             'Accept': 'application/json',
           },
         ),
       ) {
    // Debug builds only: bodies include login passwords, access/refresh tokens
    // and personal data, which must never reach a release build's logs.
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add JWT token if available
          final token = await getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          // Multipart bodies (images, PDFs) can take far longer than the 15s
          // JSON default on a slow uplink, and the server only replies after
          // receiving the whole body.
          if (options.data is FormData) {
            options.sendTimeout ??= _uploadTimeout;
            if ((options.receiveTimeout ?? Duration.zero) < _uploadTimeout) {
              options.receiveTimeout = _uploadTimeout;
            }
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 &&
              onUnauthorized != null &&
              !error.requestOptions.path.contains('/auth/login') &&
              !error.requestOptions.path.contains('/auth/refresh')) {
            // If a refresh is already in-flight, await it instead of dropping the request
            if (_refreshCompleter != null) {
              final refreshed = await _refreshCompleter!.future;
              if (refreshed) {
                final token = await getToken();
                error.requestOptions.headers['Authorization'] = 'Bearer $token';
                final response = await dio.fetch(error.requestOptions);
                return handler.resolve(response);
              }
              return handler.next(error);
            }

            _refreshCompleter = Completer<bool>();
            try {
              final refreshed = await onUnauthorized!();
              _refreshCompleter!.complete(refreshed);
              if (refreshed) {
                final token = await getToken();
                error.requestOptions.headers['Authorization'] = 'Bearer $token';
                final response = await dio.fetch(error.requestOptions);
                return handler.resolve(response);
              }
            } catch (_) {
              _refreshCompleter!.complete(false);
            } finally {
              _refreshCompleter = null;
            }
          }
          return handler.next(error);
        },
      ),
    );
    // After the auth interceptor, so a 401 is refreshed rather than retried.
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          final options = error.requestOptions;
          final attempt = options.extra[_retryAttemptKey] as int? ?? 0;
          if (options.method != 'GET' ||
              attempt >= _maxGetRetries ||
              !_isTransient(error)) {
            return handler.next(error);
          }
          // 0.5s, then 1.5s.
          await Future<void>.delayed(
            Duration(milliseconds: 500 * (attempt == 0 ? 1 : 3)),
          );
          options.extra[_retryAttemptKey] = attempt + 1;
          try {
            // Re-runs the interceptors, so a further failure retries again
            // (counted via extra) before surfacing here.
            return handler.resolve(await dio.fetch(options));
          } on DioException catch (e) {
            return handler.next(e);
          }
        },
      ),
    );
  }

  static const _uploadTimeout = Duration(minutes: 2);
  static const _maxGetRetries = 2;
  static const _retryAttemptKey = 'retry_attempt';

  /// Worth retrying an idempotent request: the network blinked or a gateway
  /// was briefly unavailable. Not 4xx/500, which won't change on retry, and
  /// not cancellations.
  static bool _isTransient(DioException e) => switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.connectionError => true,
    DioExceptionType.badResponse => const {
      502,
      503,
      504,
    }.contains(e.response?.statusCode),
    _ => false,
  };

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => dio.get(path, queryParameters: queryParameters, options: options);

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => dio.post(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
  );

  Future<Response> uploadFile(
    String path, {
    required String filePath,
    required String fieldName,
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    final formData = FormData.fromMap({
      fieldName: await MultipartFile.fromFile(filePath),
      ...?data,
    });
    return dio.post(path, data: formData, options: options);
  }

  Future<Response> uploadBytes(
    String path, {
    required List<int> bytes,
    required String fileName,
    required String fieldName,
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    final formData = FormData.fromMap({
      fieldName: MultipartFile.fromBytes(bytes, filename: fileName),
      ...?data,
    });
    return dio.post(path, data: formData, options: options);
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => dio.put(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
  );

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => dio.patch(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
  );

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => dio.delete(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
  );
}
