import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add API Key from .env
          final apiKey = dotenv.env['API_KEY'];
          if (apiKey != null && apiKey.isNotEmpty) {
            options.headers['X-API-Key'] = apiKey;
          }

          // Add JWT token if available
          final token = await getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
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
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      dio.get(path, queryParameters: queryParameters, options: options);

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      dio.post(path, data: data, queryParameters: queryParameters, options: options);

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
  }) =>
      dio.put(path, data: data, queryParameters: queryParameters, options: options);

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      dio.delete(path, data: data, queryParameters: queryParameters, options: options);
}
