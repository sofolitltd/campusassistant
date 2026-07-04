// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudentModel _$StudentModelFromJson(Map<String, dynamic> json) =>
    _StudentModel(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      universityId: json['university_id'] as String,
      departmentId: json['department_id'] as String,
      batchId: json['batch_id'] as String,
      sessionId: json['session_id'] as String,
      hallId: json['hall_id'] as String?,
      bloodGroup: json['blood_group'] as String,
      verificationCode: json['verification_code'] as String,
      isClaimed: json['is_claimed'] as bool? ?? false,
      studentName: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      isRegular: json['is_regular'] as bool? ?? true,
      isCR: json['is_c_r'] as bool? ?? false,
      userId: json['user_id'] as String?,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      hallName: json['hall_name'] as String?,
      batchName: _readBatchName(json, 'batch_name') as String?,
      departmentName: _readDepartmentName(json, 'department_name') as String?,
      universityName: _readUniversityName(json, 'university_name') as String?,
      sessionName: _readSessionName(json, 'session_name') as String?,
    );

Map<String, dynamic> _$StudentModelToJson(_StudentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'student_id': instance.studentId,
      'university_id': instance.universityId,
      'department_id': instance.departmentId,
      'batch_id': instance.batchId,
      'session_id': instance.sessionId,
      'hall_id': ?instance.hallId,
      'blood_group': instance.bloodGroup,
      'verification_code': instance.verificationCode,
      'is_claimed': instance.isClaimed,
      'name': ?instance.studentName,
      'email': ?instance.email,
      'phone': ?instance.phone,
      'is_regular': instance.isRegular,
      'is_c_r': instance.isCR,
      'user_id': ?instance.userId,
      'user': ?instance.user,
      'hall_name': ?instance.hallName,
      'batch_name': ?instance.batchName,
      'department_name': ?instance.departmentName,
      'university_name': ?instance.universityName,
      'session_name': ?instance.sessionName,
    };
