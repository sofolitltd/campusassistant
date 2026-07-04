// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hall_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HallModel _$HallModelFromJson(Map<String, dynamic> json) => _HallModel(
  id: json['id'] as String,
  name: json['name'] as String,
  slug: json['slug'] as String,
  universityId: json['university_id'] as String,
);

Map<String, dynamic> _$HallModelToJson(_HallModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'university_id': instance.universityId,
    };
