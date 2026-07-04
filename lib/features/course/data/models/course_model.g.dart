// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CourseModel _$CourseModelFromJson(Map<String, dynamic> json) => _CourseModel(
  id: json['id'] as String,
  courseCode: json['course_code'] as String,
  courseTitle: json['course_title'] as String,
  universityId: json['university_id'] as String,
  departmentId: json['department_id'] as String,
  batches:
      (json['batches'] as List<dynamic>?)
          ?.map((e) => BatchModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  totalCredits: (json['total_credits'] as num?)?.toDouble() ?? 0.0,
  totalMarks: (json['total_marks'] as num?)?.toInt() ?? 0,
  thumbnailURL: json['thumbnail_url'] as String? ?? '',
  courseCategoryId: json['course_category_id'] as String?,
  courseCategory: json['course_category'] == null
      ? null
      : CourseCategoryModel.fromJson(
          json['course_category'] as Map<String, dynamic>,
        ),
  semesterId: json['semester_id'] as String?,
  semesterName: json['semester_name'] as String?,
);

Map<String, dynamic> _$CourseModelToJson(_CourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'course_code': instance.courseCode,
      'course_title': instance.courseTitle,
      'university_id': instance.universityId,
      'department_id': instance.departmentId,
      'batches': instance.batches,
      'total_credits': instance.totalCredits,
      'total_marks': instance.totalMarks,
      'thumbnail_url': instance.thumbnailURL,
      'course_category_id': ?instance.courseCategoryId,
      'course_category': ?instance.courseCategory,
      'semester_id': ?instance.semesterId,
      'semester_name': ?instance.semesterName,
    };
