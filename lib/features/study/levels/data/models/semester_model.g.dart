// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'semester_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SemesterModel _$SemesterModelFromJson(Map<String, dynamic> json) =>
    _SemesterModel(
      id: json['id'] as String,
      name: json['name'] as String,
      order: (json['order'] as num).toInt(),
      status: json['status'] as String,
      universityId: json['university_id'] as String,
      departmentId: json['department_id'] as String,
      totalCourses: (json['total_courses'] as num).toInt(),
      totalCredits: (json['total_credits'] as num).toDouble(),
      totalMarks: (json['total_marks'] as num).toInt(),
      batches: json['batches'] as List<dynamic>,
      createdById: json['created_by_id'] as String?,
      updatedById: json['updated_by_id'] as String?,
    );

Map<String, dynamic> _$SemesterModelToJson(_SemesterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'order': instance.order,
      'status': instance.status,
      'university_id': instance.universityId,
      'department_id': instance.departmentId,
      'total_courses': instance.totalCourses,
      'total_credits': instance.totalCredits,
      'total_marks': instance.totalMarks,
      'batches': instance.batches,
      'created_by_id': ?instance.createdById,
      'updated_by_id': ?instance.updatedById,
    };
