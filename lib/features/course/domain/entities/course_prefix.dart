import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_prefix.freezed.dart';

@freezed
abstract class CoursePrefix with _$CoursePrefix {
  const factory CoursePrefix({
    required String id,
    required String prefix,
    required String description,
    required String departmentId,
    required String universityId,
  }) = _CoursePrefix;
}
