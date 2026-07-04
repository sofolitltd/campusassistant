import 'package:freezed_annotation/freezed_annotation.dart';

part 'resource.freezed.dart';

@freezed
abstract class Resource with _$Resource {
  const factory Resource({
    required String id,
    required String type,
    required String title,
    required String description,
    required String courseCode,
    required String fileUrl,
    required String thumbnailUrl,
    required int lessonNo,
    required String status,
    required String accessLevel,
    required String rejectedNote,
    required String reviewedBy,
    DateTime? reviewedAt,
    required String uploaderId,
    required String uploaderUid,
    required String uploaderName,
    required String universityId,
    required String departmentId,
    required int fileSizeBytes,
    required int pageCount,
    required int downloadCount,
    required int viewCount,
    required double ratingAvg,
    required int ratingCount,
    required bool isVerified,
    required List<String> tags,
    required bool isPublic,
    required Map<String, dynamic> metadata,
    // Legacy support fields
    required String courseTitle,
    required List<String> years,
    required List<String> batches,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Resource;
}
