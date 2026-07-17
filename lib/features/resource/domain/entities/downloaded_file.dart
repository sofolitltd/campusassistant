import 'dart:io';

import 'resource.dart';

class DownloadedFile {
  final Resource resource;
  final String localPath;
  final int fileSizeBytes;
  final DateTime modifiedAt;
  final DateTime downloadedAt;

  DownloadedFile({
    required this.resource,
    required this.localPath,
    required this.fileSizeBytes,
    required this.modifiedAt,
    required this.downloadedAt,
  });

  File get file => File(localPath);
  bool get exists => file.existsSync();
  String get fileName => localPath.split('/').last;
  String get shortId {
    // filename pattern: {courseCode}-{lessonNo} {sanitizedTitle}_{type}_{shortId}.pdf
    final parts = fileName.replaceAll('.pdf', '').split('_');
    return parts.length > 1 ? parts.last : '';
  }
}
