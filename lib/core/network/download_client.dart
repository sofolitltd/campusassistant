import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Shared client for fetching files by absolute URL: images to share, PDFs,
/// attachments, notification pictures. Separate from [ApiClient] because
/// these hit storage/CDN URLs, not the API, and must not carry the bearer
/// token or JSON headers.
///
/// A top-level instance rather than a provider so code without a `ref` (the
/// FCM handler, which can run in a background isolate) uses it too.
final Dio downloadClient = Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    // Inactivity between chunks, not total time, so large files still finish.
    receiveTimeout: const Duration(seconds: 30),
  ),
);

/// GETs [url] and returns the body as bytes. Throws on non-2xx.
Future<Uint8List> downloadBytes(String url) async {
  final response = await downloadClient.get<List<int>>(
    url,
    options: Options(responseType: ResponseType.bytes),
  );
  final data = response.data!;
  return data is Uint8List ? data : Uint8List.fromList(data);
}
