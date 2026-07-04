// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BannerModel _$BannerModelFromJson(Map<String, dynamic> json) => _BannerModel(
  id: json['id'] as String,
  title: json['title'] as String,
  imageUrl: json['image_url'] as String,
  clickUrl: json['click_url'] as String,
  priority: (json['priority'] as num).toInt(),
  isActive: json['is_active'] as bool,
  startAt: DateTime.parse(json['start_at'] as String),
  endAt: DateTime.parse(json['end_at'] as String),
  targetScope: json['target_scope'] as String,
  targets:
      (json['targets'] as List<dynamic>?)
          ?.map((e) => BannerTargetModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$BannerModelToJson(_BannerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image_url': instance.imageUrl,
      'click_url': instance.clickUrl,
      'priority': instance.priority,
      'is_active': instance.isActive,
      'start_at': instance.startAt.toIso8601String(),
      'end_at': instance.endAt.toIso8601String(),
      'target_scope': instance.targetScope,
      'targets': instance.targets,
    };

_BannerTargetModel _$BannerTargetModelFromJson(Map<String, dynamic> json) =>
    _BannerTargetModel(
      id: (json['id'] as num?)?.toInt(),
      bannerId: json['banner_id'] as String,
      universityId: json['university_id'] as String?,
      departmentId: json['department_id'] as String?,
    );

Map<String, dynamic> _$BannerTargetModelToJson(_BannerTargetModel instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'banner_id': instance.bannerId,
      'university_id': ?instance.universityId,
      'department_id': ?instance.departmentId,
    };
