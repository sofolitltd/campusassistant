// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CourseCategoryModel _$CourseCategoryModelFromJson(Map<String, dynamic> json) =>
    _CourseCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      order: (json['order'] as num).toInt(),
      departmentId: json['department_id'] as String,
      universityId: json['university_id'] as String,
    );

Map<String, dynamic> _$CourseCategoryModelToJson(
  _CourseCategoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'order': instance.order,
  'department_id': instance.departmentId,
  'university_id': instance.universityId,
};
