import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    @JsonKey(name: 'avatar_url') String? profileImage,
    String? phone,
    String? gender,
    String? batch,
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
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  User toEntity() => User(
        id: id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        role: role,
        profileImage: profileImage,
        phone: phone,
        gender: gender,
        batch: batch,
        profession: profession,
        session: session,
        hall: hall,
        blood: blood,
        isActive: isActive,
        isVerified: isVerified,
        isPhonePublic: isPhonePublic,
        isEmailPublic: isEmailPublic,
        subscriptionStatus: subscriptionStatus,
        isModerator: isModerator,
        isAdmin: isAdmin,
        isCr: isCr,
        universityId: universityId,
        departmentId: departmentId,
      );

  factory UserModel.fromEntity(User user) => UserModel(
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        role: user.role,
        profileImage: user.profileImage,
        phone: user.phone,
        gender: user.gender,
        batch: user.batch,
        profession: user.profession,
        session: user.session,
        hall: user.hall,
        blood: user.blood,
        isActive: user.isActive,
        isVerified: user.isVerified,
        isPhonePublic: user.isPhonePublic,
        isEmailPublic: user.isEmailPublic,
        subscriptionStatus: user.subscriptionStatus,
        isModerator: user.isModerator,
        isAdmin: user.isAdmin,
        isCr: user.isCr,
        universityId: user.universityId,
        departmentId: user.departmentId,
      );
}
