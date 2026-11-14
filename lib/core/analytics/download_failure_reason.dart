import 'dart:io';

import 'package:dio/dio.dart';

/// Reason codes sent with `resource_download_failed` / `_blocked` analytics
/// events. The admin downloads report groups them into system / connection /
/// device, so a new code must also be added to `downloadFailureGroups` in the
/// API's analytics_downloads_handler.go — otherwise it lands under "unknown".
abstract final class DownloadFailureReason {
  // Our side: the file or the servers.
  static const notFound = 'not_found';
  static const forbidden = 'forbidden';
  static const serverError = 'server_error';
  static const badResponse = 'bad_response';
  // The network between the device and storage.
  static const network = 'network';
  static const timeout = 'timeout';
  // The device.
  static const storageFull = 'storage_full';
  static const fileError = 'file_error';
  static const unknown = 'unknown';

  // Blocked, not failed: the paywall did its job.
  static const proRequired = 'pro_required';
  static const outOfCoins = 'out_of_coins';
}

/// True when [error] is the user pausing/cancelling, which is not a failure.
bool isDownloadCancelled(Object error) =>
    error is DioException && error.type == DioExceptionType.cancel;

/// True when [error] is a definite answer from the server (an HTTP status),
/// as opposed to never reaching it.
bool isDownloadServerAnswer(Object error) =>
    error is DioException && error.type == DioExceptionType.badResponse;

/// Maps a download error to a [DownloadFailureReason] code.
String downloadFailureReason(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return DownloadFailureReason.timeout;
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return DownloadFailureReason.network;
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode ?? 0;
        if (status == 404 || status == 410) {
          return DownloadFailureReason.notFound;
        }
        if (status == 401 || status == 403) {
          return DownloadFailureReason.forbidden;
        }
        if (status >= 500) return DownloadFailureReason.serverError;
        return DownloadFailureReason.badResponse;
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        final cause = error.error;
        return cause == null
            ? DownloadFailureReason.unknown
            : downloadFailureReason(cause);
    }
  }
  if (error is FileSystemException) {
    // ENOSPC: no space left on device.
    return error.osError?.errorCode == 28
        ? DownloadFailureReason.storageFull
        : DownloadFailureReason.fileError;
  }
  if (error is SocketException ||
      error is HandshakeException ||
      error is HttpException) {
    return DownloadFailureReason.network;
  }
  return DownloadFailureReason.unknown;
}
