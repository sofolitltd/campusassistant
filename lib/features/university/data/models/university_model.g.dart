// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'university_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UniversityModel _$UniversityModelFromJson(Map<String, dynamic> json) =>
    _UniversityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      acronym: json['acronym'] as String,
      slug: json['slug'] as String,
      establishedYear: json['established_year'] as String,
      address: json['address'] as String,
      about: json['about'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      websiteUrl: json['website_url'] as String,
      logoUrl: json['logo_url'] as String? ?? '',
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      totalFaculties: json['total_faculties'] as String? ?? '0',
      totalDepartments: json['total_departments'] as String? ?? '0',
      totalHalls: json['total_halls'] as String? ?? '0',
      campusArea: json['campus_area'] as String? ?? '',
    );

Map<String, dynamic> _$UniversityModelToJson(_UniversityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'acronym': instance.acronym,
      'slug': instance.slug,
      'established_year': instance.establishedYear,
      'address': instance.address,
      'about': instance.about,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'website_url': instance.websiteUrl,
      'logo_url': instance.logoUrl,
      'images': instance.images,
      'total_faculties': instance.totalFaculties,
      'total_departments': instance.totalDepartments,
      'total_halls': instance.totalHalls,
      'campus_area': instance.campusArea,
    };
