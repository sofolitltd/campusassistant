import 'package:freezed_annotation/freezed_annotation.dart';

part 'syllabus.freezed.dart';

@freezed
abstract class Syllabus with _$Syllabus {
  const factory Syllabus({
    required String id,
    required String title,
    required String courseCode,
    required String courseTitle,
    required String description,
    required String fileUrl,
    required String uploaderName,
    DateTime? createdAt,
    required List<String> batches,
    required List<String> years,
    required String universityId,
    required String departmentId,
  }) = _Syllabus;
}
