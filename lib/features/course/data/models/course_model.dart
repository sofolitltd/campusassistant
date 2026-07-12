import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/course.dart';
import 'course_category_model.dart';
import '../../../batch/data/models/batch_model.dart';

part 'course_model.freezed.dart';
part 'course_model.g.dart';

@Freezed(fromJson: true, toJson: true)
abstract class CourseModel with _$CourseModel {
  const CourseModel._();

  const factory CourseModel({
    required String id,
    @JsonKey(name: 'course_code') required String courseCode,
    @JsonKey(name: 'course_title') required String courseTitle,
    @JsonKey(name: 'university_id') required String universityId,
    @JsonKey(name: 'department_id') required String departmentId,
    @Default([]) List<BatchModel> batches,
    @JsonKey(name: 'total_credits') @Default(0.0) double totalCredits,
    @JsonKey(name: 'total_marks') @Default(0) int totalMarks,
    @JsonKey(name: 'thumbnail_url') @Default('') String thumbnailURL,
    @JsonKey(name: 'course_category_id') String? courseCategoryId,
    @JsonKey(name: 'course_category') CourseCategoryModel? courseCategory,
    @JsonKey(name: 'level_id') String? semesterId,
    String? semesterName,
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final level = json['level'];
    String? name;
    if (level is Map<String, dynamic>) {
      name = level['name'] as String?;
    }
    return _$CourseModelFromJson(json).copyWith(semesterName: name);
  }

  Course toEntity() => Course(
        id: id,
        courseCode: courseCode,
        courseTitle: courseTitle,
        universityId: universityId,
        departmentId: departmentId,
        batches: batches.map((b) => b.toEntity()).toList(),
        totalCredits: totalCredits,
        totalMarks: totalMarks,
        thumbnailURL: thumbnailURL,
        courseCategoryId: courseCategoryId,
        courseCategory: courseCategory?.toEntity(),
        semesterId: semesterId,
        semesterName: semesterName,
      );

  factory CourseModel.fromEntity(Course course) => CourseModel(
        id: course.id,
        courseCode: course.courseCode,
        courseTitle: course.courseTitle,
        universityId: course.universityId,
        departmentId: course.departmentId,
        batches: course.batches
            .map((b) => BatchModel.fromEntity(b))
            .toList(),
        totalCredits: course.totalCredits,
        totalMarks: course.totalMarks,
        thumbnailURL: course.thumbnailURL,
        courseCategoryId: course.courseCategoryId,
        courseCategory: course.courseCategory != null
            ? CourseCategoryModel.fromEntity(course.courseCategory!)
            : null,
        semesterId: course.semesterId,
        semesterName: course.semesterName,
      );
}
