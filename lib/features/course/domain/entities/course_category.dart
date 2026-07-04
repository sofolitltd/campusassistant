import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_category.freezed.dart';

@freezed
abstract class CourseCategory with _$CourseCategory {
  const factory CourseCategory({
    required String id,
    required String name,
    required int order,
    required String departmentId,
    required String universityId,
  }) = _CourseCategory;
}
