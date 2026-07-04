// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DepartmentModel _$DepartmentModelFromJson(Map<String, dynamic> json) =>
    _DepartmentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      acronym: json['acronym'] as String,
      slug: json['slug'] as String,
      universityId: json['university_id'] as String,
      establishedYear: (json['established_year'] as num).toInt(),
      about: json['about'] as String,
      logoUrl: json['logo_url'] as String? ?? '',
      websiteUrl: json['website_url'] as String? ?? '',
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DepartmentModelToJson(_DepartmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'acronym': instance.acronym,
      'slug': instance.slug,
      'university_id': instance.universityId,
      'established_year': instance.establishedYear,
      'about': instance.about,
      'logo_url': instance.logoUrl,
      'website_url': instance.websiteUrl,
      'images': instance.images,
    };
