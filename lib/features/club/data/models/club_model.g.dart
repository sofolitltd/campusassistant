// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClubModel _$ClubModelFromJson(Map<String, dynamic> json) => _ClubModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  clubType: json['club_type'] as String,
  universityId: json['university_id'] as String,
  departmentId: json['department_id'] as String?,
  logoUrl: json['logo_url'] as String?,
  bannerUrl: json['banner_url'] as String?,
  foundedYear: (json['founded_year'] as num?)?.toInt(),
  isActive: json['is_active'] as bool? ?? true,
  socialLinks: json['social_links'] as Map<String, dynamic>?,
  contactEmail: json['contact_email'] as String?,
  contactPhone: json['contact_phone'] as String?,
  followersCount: (json['followers_count'] as num?)?.toInt() ?? 0,
  isFollowing: json['is_following'] as bool? ?? false,
  category: json['category'] as String?,
  isVerified: json['is_verified'] as bool? ?? false,
  membersCount: (json['members_count'] as num?)?.toInt() ?? 0,
  isMember: json['is_member'] as bool? ?? false,
);

Map<String, dynamic> _$ClubModelToJson(_ClubModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'club_type': instance.clubType,
      'university_id': instance.universityId,
      'department_id': ?instance.departmentId,
      'logo_url': ?instance.logoUrl,
      'banner_url': ?instance.bannerUrl,
      'founded_year': ?instance.foundedYear,
      'is_active': instance.isActive,
      'social_links': ?instance.socialLinks,
      'contact_email': ?instance.contactEmail,
      'contact_phone': ?instance.contactPhone,
      'followers_count': instance.followersCount,
      'is_following': instance.isFollowing,
      'category': ?instance.category,
      'is_verified': instance.isVerified,
      'members_count': instance.membersCount,
      'is_member': instance.isMember,
    };
