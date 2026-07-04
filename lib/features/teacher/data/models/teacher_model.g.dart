// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeacherModel _$TeacherModelFromJson(Map<String, dynamic> json) =>
    _TeacherModel(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      departmentId: json['department_id'] as String,
      present: json['present'] as bool,
      chairman: json['chairman'] as bool,
      serial: (json['serial'] as num).toInt(),
      name: json['name'] as String,
      post: json['post'] as String,
      phd: json['phd'] as String,
      mobile: json['mobile'] as String,
      email: json['email'] as String,
      imageUrl: json['image_url'] as String,
      interests: json['interests'] as String,
      publications: json['publications'] as String,
      token: json['token'] as String,
    );

Map<String, dynamic> _$TeacherModelToJson(_TeacherModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'university_id': instance.universityId,
      'department_id': instance.departmentId,
      'present': instance.present,
      'chairman': instance.chairman,
      'serial': instance.serial,
      'name': instance.name,
      'post': instance.post,
      'phd': instance.phd,
      'mobile': instance.mobile,
      'email': instance.email,
      'image_url': instance.imageUrl,
      'interests': instance.interests,
      'publications': instance.publications,
      'token': instance.token,
    };
