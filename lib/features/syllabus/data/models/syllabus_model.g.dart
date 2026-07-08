// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'syllabus_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyllabusModel _$SyllabusModelFromJson(Map<String, dynamic> json) =>
    _SyllabusModel(
      id: json['id'] as String,
      title: json['title'] as String,
      courseCode: json['course_code'] as String,
      courseTitle: json['course_title'] as String?,
      description: json['description'] as String,
      fileUrl: json['file_url'] as String,
      uploaderName: json['uploader_name'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      batches: (json['batches'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      years: json['years'] as List<dynamic>?,
      universityId: json['university_id'] as String,
      departmentId: json['department_id'] as String,
    );

Map<String, dynamic> _$SyllabusModelToJson(_SyllabusModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'course_code': instance.courseCode,
      'course_title': ?instance.courseTitle,
      'description': instance.description,
      'file_url': instance.fileUrl,
      'uploader_name': instance.uploaderName,
      'created_at': ?instance.createdAt?.toIso8601String(),
      'batches': ?instance.batches,
      'years': ?instance.years,
      'university_id': instance.universityId,
      'department_id': instance.departmentId,
    };
