// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_prefix_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoursePrefixModel _$CoursePrefixModelFromJson(Map<String, dynamic> json) =>
    _CoursePrefixModel(
      id: json['id'] as String,
      prefix: json['prefix'] as String,
      description: json['description'] as String,
      departmentId: json['department_id'] as String,
      universityId: json['university_id'] as String,
    );

Map<String, dynamic> _$CoursePrefixModelToJson(_CoursePrefixModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'prefix': instance.prefix,
      'description': instance.description,
      'department_id': instance.departmentId,
      'university_id': instance.universityId,
    };
