// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alumni_organization_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlumniOrganizationModel _$AlumniOrganizationModelFromJson(
  Map<String, dynamic> json,
) => _AlumniOrganizationModel(
  id: json['id'] as String,
  name: json['name'] as String,
  logoUrl: json['logo_url'] as String? ?? '',
  website: json['website'] as String? ?? '',
);

Map<String, dynamic> _$AlumniOrganizationModelToJson(
  _AlumniOrganizationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'logo_url': instance.logoUrl,
  'website': instance.website,
};
