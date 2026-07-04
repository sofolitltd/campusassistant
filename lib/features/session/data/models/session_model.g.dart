// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionModel _$SessionModelFromJson(Map<String, dynamic> json) =>
    _SessionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      universityId: json['university_id'] as String,
      departmentId: json['department_id'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$SessionModelToJson(_SessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'university_id': instance.universityId,
      'department_id': ?instance.departmentId,
      'is_active': instance.isActive,
    };
