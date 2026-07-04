// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StaffModel _$StaffModelFromJson(Map<String, dynamic> json) => _StaffModel(
  id: json['id'] as String,
  universityId: json['university_id'] as String,
  departmentId: json['department_id'] as String,
  name: json['name'] as String,
  post: json['post'] as String,
  mobile: json['mobile'] as String,
  imageUrl: json['image_url'] as String,
  serial: (json['serial'] as num).toInt(),
  verificationCode: json['verification_code'] as String? ?? '',
  isClaimed: json['is_claimed'] as bool? ?? false,
);

Map<String, dynamic> _$StaffModelToJson(_StaffModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'university_id': instance.universityId,
      'department_id': instance.departmentId,
      'name': instance.name,
      'post': instance.post,
      'mobile': instance.mobile,
      'image_url': instance.imageUrl,
      'serial': instance.serial,
      'verification_code': instance.verificationCode,
      'is_claimed': instance.isClaimed,
    };
