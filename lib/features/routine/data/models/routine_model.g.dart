// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoutineModel _$RoutineModelFromJson(Map<String, dynamic> json) =>
    _RoutineModel(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['image_url'] as String,
      time: json['time'] as String,
      universityId: json['university_id'] as String,
      departmentId: json['department_id'] as String,
    );

Map<String, dynamic> _$RoutineModelToJson(_RoutineModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image_url': instance.imageUrl,
      'time': instance.time,
      'university_id': instance.universityId,
      'department_id': instance.departmentId,
    };
