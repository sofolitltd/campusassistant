import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const User._();

  const factory User({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    String? profileImage,
    String? phone,
    String? gender,
    String? batch,
    String? batchId,
    String? profession,
    String? session,
    String? hall,
    String? blood,
    @Default(true) bool isActive,
    @Default(false) bool isVerified,
    @Default(false) bool isPhonePublic,
    @Default(false) bool isEmailPublic,
    @Default('basic') String? subscriptionStatus,
    @Default(false) bool isModerator,
    @Default(false) bool isAdmin,
    @Default(false) bool isCr,
    String? universityId,
    String? departmentId,
  }) = _User;

  String get fullName => '$firstName $lastName';
}
