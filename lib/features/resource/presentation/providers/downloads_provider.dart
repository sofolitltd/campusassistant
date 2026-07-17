import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../data/models/resource_model.dart';
import '../../domain/entities/downloaded_file.dart';
import '../../domain/entities/resource.dart';

part 'downloads_provider.g.dart';

const _metadataEntityType = 'downloaded_resource_metadata';

/// Caches the resource metadata after a successful download.
Future<void> cacheDownloadedResourceMetadata({
  required CacheManager cacheManager,
  required Resource resource,
}) async {
  try {
    final model = ResourceModel.fromEntity(resource);
    final shortId = resource.id.length > 5
        ? resource.id.substring(0, 5)
        : resource.id;
    await cacheManager.cacheSingle(
      entityType: _metadataEntityType,
      entityKey: shortId,
      data: model.toJson(),
      ttl: const Duration(days: 30),
    );
  } catch (e) {
    debugPrint('[DownloadsProvider] Failed to cache metadata: $e');
  }
}

/// Removes the cached resource metadata (e.g. when file is deleted).
Future<void> removeDownloadedResourceMetadata({
  required CacheManager cacheManager,
  required String shortId,
}) async {
  try {
    await cacheManager.invalidateEntry(
      entityType: _metadataEntityType,
      entityKey: shortId,
    );
  } catch (e) {
    debugPrint('[DownloadsProvider] Failed to remove metadata: $e');
  }
}

/// Returns the shortId (first 5 chars of resource id) from a local filename.
///
/// Expected filename pattern:
///   {courseCode}-{lessonNo} {title}_{type}_{shortId}.pdf
String? extractShortIdFromFileName(String fileName) {
  final name = fileName.replaceAll('.pdf', '');
  final parts = name.split('_');
  if (parts.length >= 2) {
    return parts.last;
  }
  return null;
}

/// Parse a minimal Resource from filename parts when cache metadata is missing.
///
/// Expected filename pattern:
///   {courseCode}-{lessonNo} {title}_{type}_{shortId}.pdf
Resource _inferResourceFromFileName(String fileName, FileStat stat) {
  final name = fileName.replaceAll('.pdf', '');
  final parts = name.split('_');
  // First part is "{courseCode}-{lessonNo}"
  final codePart = parts.isNotEmpty ? parts.first : '';
  final dashIndex = codePart.indexOf('-');
  final courseCode = dashIndex > 0 ? codePart.substring(0, dashIndex) : codePart;
  final lessonNoStr = dashIndex > 0 ? codePart.substring(dashIndex + 1) : '0';
  final lessonNo = int.tryParse(lessonNoStr) ?? 0;
  // Type is the second-to-last part
  final type = parts.length >= 2 ? parts[parts.length - 2] : 'note';
  // Title is everything between courseCode-lessonNo and type
  final title = parts.length > 2
      ? parts.sublist(1, parts.length - 2).join(' ')
      : fileName;

  return Resource(
    id: '',
    type: type,
    title: title,
    description: '',
    courseCode: courseCode,
    fileUrl: '',
    thumbnailUrl: '',
    lessonNo: lessonNo,
    status: 'free',
    accessLevel: '',
    rejectedNote: '',
    reviewedBy: '',
    uploaderId: '',
    uploaderUid: '',
    uploaderName: '',
    universityId: '',
    departmentId: '',
    fileSizeBytes: stat.size,
    pageCount: 0,
    downloadCount: 0,
    viewCount: 0,
    ratingAvg: 0,
    ratingCount: 0,
    isVerified: false,
    tags: [],
    isPublic: false,
    metadata: {},
    courseTitle: '',
    years: [],
    batches: [],
  );
}

@Riverpod(keepAlive: true)
class DownloadedFiles extends _$DownloadedFiles {
  @override
  Future<List<DownloadedFile>> build() async {
    return _scanDownloadedFiles();
  }

  /// Re-scan the filesystem and reload.
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<List<DownloadedFile>> _scanDownloadedFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final allFiles = directory.listSync();
      final pdfFiles = allFiles
          .where((f) => f.path.endsWith('.pdf'))
          .toList()
        ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));

      final cacheManager = ref.read(cacheManagerProvider);
      final results = <DownloadedFile>[];

      for (final file in pdfFiles) {
        final path = file.path;
        final fileName = path.split('/').last;
        final stat = file.statSync();
        final shortId = extractShortIdFromFileName(fileName);

        Resource resource;

        // Try to get cached metadata
        if (shortId != null) {
          try {
            final cached = await cacheManager.getCachedSingle(
              entityType: _metadataEntityType,
              entityKey: shortId,
            );
            if (cached != null) {
              resource = ResourceModel.fromJson(cached).toEntity();
              // Patch in the local file size
              resource = resource.copyWith(fileSizeBytes: stat.size);
            } else {
              resource = _inferResourceFromFileName(fileName, stat);
            }
          } catch (_) {
            resource = _inferResourceFromFileName(fileName, stat);
          }
        } else {
          resource = _inferResourceFromFileName(fileName, stat);
        }

        results.add(DownloadedFile(
          resource: resource,
          localPath: path,
          fileSizeBytes: stat.size,
          modifiedAt: stat.modified,
          downloadedAt: stat.modified,
        ));
      }

      return results;
    } catch (e) {
      debugPrint('[DownloadsProvider] Scan error: $e');
      return [];
    }
  }
}
