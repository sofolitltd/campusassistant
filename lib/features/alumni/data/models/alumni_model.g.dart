// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alumni_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlumniModel _$AlumniModelFromJson(Map<String, dynamic> json) => _AlumniModel(
  id: json['id'] as String,
  fullName: json['full_name'] as String,
  studentId: json['student_id'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  batch: json['batch'] as String,
  passingYear: json['passing_year'] as String,
  currentStatus: json['current_status'] as String,
  organization: json['organization'] as String? ?? '',
  designation: json['designation'] as String? ?? '',
  location: json['location'] as String? ?? '',
  bio: json['bio'] as String? ?? '',
  profileImage: json['profile_image'] as String? ?? '',
  socialLinks: json['social_links'] as Map<String, dynamic>?,
  createdBy: json['created_by'] as String? ?? '',
  universityId: json['university_id'] as String,
  departmentId: json['department_id'] as String,
  organizationId: json['organization_id'] as String?,
  organizationRef: json['organization_ref'] == null
      ? null
      : AlumniOrganizationModel.fromJson(
          json['organization_ref'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$AlumniModelToJson(_AlumniModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'student_id': instance.studentId,
      'email': instance.email,
      'phone': instance.phone,
      'batch': instance.batch,
      'passing_year': instance.passingYear,
      'current_status': instance.currentStatus,
      'organization': instance.organization,
      'designation': instance.designation,
      'location': instance.location,
      'bio': instance.bio,
      'profile_image': instance.profileImage,
      'social_links': ?instance.socialLinks,
      'created_by': instance.createdBy,
      'university_id': instance.universityId,
      'department_id': instance.departmentId,
      'organization_id': ?instance.organizationId,
      'organization_ref': ?instance.organizationRef,
    };
