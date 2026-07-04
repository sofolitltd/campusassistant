// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BatchModel _$BatchModelFromJson(Map<String, dynamic> json) => _BatchModel(
  id: json['id'] as String,
  name: json['name'] as String,
  slug: json['slug'] as String,
  isStudying: json['is_studying'] as bool? ?? true,
  departmentId: json['department_id'] as String,
  universityId: json['university_id'] as String,
  sessions:
      (json['sessions'] as List<dynamic>?)
          ?.map((e) => SessionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$BatchModelToJson(_BatchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'is_studying': instance.isStudying,
      'department_id': instance.departmentId,
      'university_id': instance.universityId,
      'sessions': instance.sessions,
    };
