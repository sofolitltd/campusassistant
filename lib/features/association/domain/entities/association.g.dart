// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'association.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Association _$AssociationFromJson(Map<String, dynamic> json) => _Association(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  associationType: json['association_type'] as String,
  universityId: json['university_id'] as String,
  districtId: json['district_id'] as String,
  districtName: json['district_name'] as String,
  subDistrictId: json['sub_district_id'] as String?,
  subDistrictName: json['sub_district_name'] as String?,
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
  isPendingMember: json['is_pending_member'] as bool? ?? false,
);

Map<String, dynamic> _$AssociationToJson(_Association instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'association_type': instance.associationType,
      'university_id': instance.universityId,
      'district_id': instance.districtId,
      'district_name': instance.districtName,
      'sub_district_id': ?instance.subDistrictId,
      'sub_district_name': ?instance.subDistrictName,
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
      'is_pending_member': instance.isPendingMember,
    };
