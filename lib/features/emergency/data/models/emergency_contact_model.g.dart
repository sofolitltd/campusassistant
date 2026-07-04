// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_contact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmergencyContactModel _$EmergencyContactModelFromJson(
  Map<String, dynamic> json,
) => _EmergencyContactModel(
  id: json['id'] as String,
  title: json['title'] as String,
  designation: json['designation'] as String?,
  description: json['description'] as String?,
  phone: json['phone'] as String,
  email: json['email'] as String?,
  category: json['category'] as String?,
  scope: json['target_scope'] as String,
  universityId: json['university_id'] as String?,
  departmentId: json['department_id'] as String?,
  isVerified: json['is_verified'] as bool? ?? false,
  logoUrl: json['logo_url'] as String?,
);

Map<String, dynamic> _$EmergencyContactModelToJson(
  _EmergencyContactModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'designation': ?instance.designation,
  'description': ?instance.description,
  'phone': instance.phone,
  'email': ?instance.email,
  'category': ?instance.category,
  'target_scope': instance.scope,
  'university_id': ?instance.universityId,
  'department_id': ?instance.departmentId,
  'is_verified': instance.isVerified,
  'logo_url': ?instance.logoUrl,
};
