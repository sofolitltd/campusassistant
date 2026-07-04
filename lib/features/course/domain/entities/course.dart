import 'package:freezed_annotation/freezed_annotation.dart';
import 'course_category.dart';
import '../../../batch/domain/entities/batch.dart';

part 'course.freezed.dart';

@freezed
abstract class Course with _$Course {
  const factory Course({
    required String id,
    required String courseCode,
    required String courseTitle,
    required String universityId,
    required String departmentId,
    @Default([]) List<Batch> batches,
    @Default(0.0) double totalCredits,
    @Default(0) int totalMarks,
    @Default('') String thumbnailURL,
    String? courseCategoryId,
    CourseCategory? courseCategory,
    String? semesterId,
    String? semesterName,
  }) = _Course;
}
