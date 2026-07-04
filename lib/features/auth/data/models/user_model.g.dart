// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  role: json['role'] as String,
  profileImage: json['avatar_url'] as String?,
  phone: json['phone'] as String?,
  gender: json['gender'] as String?,
  batch: json['batch'] as String?,
  profession: json['profession'] as String?,
  session: json['session'] as String?,
  hall: json['hall'] as String?,
  blood: json['blood'] as String?,
  isActive: json['is_active'] as bool? ?? true,
  isVerified: json['is_verified'] as bool? ?? false,
  isPhonePublic: json['is_phone_public'] as bool? ?? false,
  isEmailPublic: json['is_email_public'] as bool? ?? false,
  subscriptionStatus: json['subscription_status'] as String? ?? 'basic',
  isModerator: json['is_moderator'] as bool? ?? false,
  isAdmin: json['is_admin'] as bool? ?? false,
  isCr: json['is_cr'] as bool? ?? false,
  universityId: json['university_id'] as String?,
  departmentId: json['department_id'] as String?,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'role': instance.role,
      'avatar_url': ?instance.profileImage,
      'phone': ?instance.phone,
      'gender': ?instance.gender,
      'batch': ?instance.batch,
      'profession': ?instance.profession,
      'session': ?instance.session,
      'hall': ?instance.hall,
      'blood': ?instance.blood,
      'is_active': instance.isActive,
      'is_verified': instance.isVerified,
      'is_phone_public': instance.isPhonePublic,
      'is_email_public': instance.isEmailPublic,
      'subscription_status': ?instance.subscriptionStatus,
      'is_moderator': instance.isModerator,
      'is_admin': instance.isAdmin,
      'is_cr': instance.isCr,
      'university_id': ?instance.universityId,
      'department_id': ?instance.departmentId,
    };
