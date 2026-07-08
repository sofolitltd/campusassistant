import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/resource.dart';

part 'resource_model.freezed.dart';
part 'resource_model.g.dart';

/// Custom DateTime converter that handles Go zero time values (0001-01-01)
DateTime? _parseDateTime(String? value) {
  if (value == null || value.isEmpty) return null;
  // Go zero time (0001-01-01) or invalid dates return null
  if (value.startsWith('0001-01-01') || value.startsWith('0000-01-01')) {
    return null;
  }
  try {
    return DateTime.parse(value);
  } catch (_) {
    return null;
  }
}

/// Custom DateTime? to JSON converter
String? _dateTimeToJson(DateTime? value) => value?.toIso8601String();

@freezed
abstract class ResourceModel with _$ResourceModel {
  const ResourceModel._();

  const factory ResourceModel({
    required String id,
    required String type,
    required String title,
    required String description,
    @JsonKey(name: 'course_code') required String courseCode,
    @JsonKey(name: 'file_url') required String fileUrl,
    @JsonKey(name: 'thumbnail_url') required String thumbnailUrl,
    @JsonKey(name: 'lesson_no') required int lessonNo,
    required String status,
    @JsonKey(name: 'access_level') required String accessLevel,
    @JsonKey(name: 'rejected_note') String? rejectedNote,
    @JsonKey(name: 'reviewed_by_id') String? reviewedBy,
    @JsonKey(name: 'reviewed_at', fromJson: _parseDateTime, toJson: _dateTimeToJson) DateTime? reviewedAt,
    @JsonKey(name: 'uploader_id') String? uploaderId,
    @JsonKey(name: 'uploader_uid') required String uploaderUid,
    @JsonKey(name: 'uploader_name') required String uploaderName,
    @JsonKey(name: 'university_id') required String universityId,
    @JsonKey(name: 'department_id') required String departmentId,
    @JsonKey(name: 'file_size_bytes') required int fileSizeBytes,
    @JsonKey(name: 'page_count') required int pageCount,
    @JsonKey(name: 'download_count') required int downloadCount,
    @JsonKey(name: 'view_count') required int viewCount,
    @JsonKey(name: 'rating_avg') required double ratingAvg,
    @JsonKey(name: 'rating_count') required int ratingCount,
    @JsonKey(name: 'is_verified') required bool isVerified,
    required List<String> tags,
    @JsonKey(name: 'is_public') required bool isPublic,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'course_title') String? courseTitle,
    List<String>? years,
    List<dynamic>? batches,
    @JsonKey(name: 'created_at', fromJson: _parseDateTime, toJson: _dateTimeToJson) DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _parseDateTime, toJson: _dateTimeToJson) DateTime? updatedAt,
  }) = _ResourceModel;

  factory ResourceModel.fromJson(Map<String, dynamic> json) =>
      _$ResourceModelFromJson(json);

  Resource toEntity() => Resource(
        id: id,
        type: type,
        title: title,
        description: description,
        courseCode: courseCode,
        fileUrl: fileUrl,
        thumbnailUrl: thumbnailUrl,
        lessonNo: lessonNo,
        status: status,
        accessLevel: accessLevel,
        rejectedNote: rejectedNote ?? '',
        reviewedBy: reviewedBy ?? '',
        reviewedAt: reviewedAt,
        uploaderId: uploaderId ?? '',
        uploaderUid: uploaderUid,
        uploaderName: uploaderName,
        universityId: universityId,
        departmentId: departmentId,
        fileSizeBytes: fileSizeBytes,
        pageCount: pageCount,
        downloadCount: downloadCount,
        viewCount: viewCount,
        ratingAvg: ratingAvg,
        ratingCount: ratingCount,
        isVerified: isVerified,
        tags: tags,
        isPublic: isPublic,
        metadata: metadata ?? <String, dynamic>{},
        courseTitle: courseTitle ?? '',
        years: years ?? <String>[],
        batches: (batches ?? <dynamic>[]).map((e) {
          if (e is Map && e.containsKey('id')) return e['id'].toString();
          return e.toString();
        }).toList(),
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  factory ResourceModel.fromEntity(Resource resource) => ResourceModel(
        id: resource.id,
        type: resource.type,
        title: resource.title,
        description: resource.description,
        courseCode: resource.courseCode,
        fileUrl: resource.fileUrl,
        thumbnailUrl: resource.thumbnailUrl,
        lessonNo: resource.lessonNo,
        status: resource.status,
        accessLevel: resource.accessLevel,
        rejectedNote: resource.rejectedNote,
        reviewedBy: resource.reviewedBy,
        reviewedAt: resource.reviewedAt,
        uploaderId: resource.uploaderId,
        uploaderUid: resource.uploaderUid,
        uploaderName: resource.uploaderName,
        universityId: resource.universityId,
        departmentId: resource.departmentId,
        fileSizeBytes: resource.fileSizeBytes,
        pageCount: resource.pageCount,
        downloadCount: resource.downloadCount,
        viewCount: resource.viewCount,
        ratingAvg: resource.ratingAvg,
        ratingCount: resource.ratingCount,
        isVerified: resource.isVerified,
        tags: resource.tags,
        isPublic: resource.isPublic,
        metadata: resource.metadata,
        courseTitle: resource.courseTitle,
        years: resource.years,
        batches: resource.batches.map((id) => {'id': id}).toList(),
        createdAt: resource.createdAt,
        updatedAt: resource.updatedAt,
      );
}
