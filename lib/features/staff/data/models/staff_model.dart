import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/staff.dart';

part 'staff_model.freezed.dart';
part 'staff_model.g.dart';

@freezed
abstract class StaffModel with _$StaffModel {
  const StaffModel._();

  const factory StaffModel({
    required String id,
    @JsonKey(name: 'university_id') required String universityId,
    @JsonKey(name: 'department_id') required String departmentId,
    required String name,
    required String post,
    required String mobile,
    @JsonKey(name: 'image_url') required String imageUrl,
    required int serial,
    @JsonKey(name: 'verification_code') @Default('') String verificationCode,
    @JsonKey(name: 'is_claimed') @Default(false) bool isClaimed,
  }) = _StaffModel;

  factory StaffModel.fromJson(Map<String, dynamic> json) =>
      _$StaffModelFromJson(json);

  Staff toEntity() => Staff(
        id: id,
        universityId: universityId,
        departmentId: departmentId,
        name: name,
        post: post,
        mobile: mobile,
        imageUrl: imageUrl,
        serial: serial,
        verificationCode: verificationCode,
        isClaimed: isClaimed,
      );

  factory StaffModel.fromEntity(Staff staff) => StaffModel(
        id: staff.id,
        universityId: staff.universityId,
        departmentId: staff.departmentId,
        name: staff.name,
        post: staff.post,
        mobile: staff.mobile,
        imageUrl: staff.imageUrl,
        serial: staff.serial,
        verificationCode: staff.verificationCode,
        isClaimed: staff.isClaimed,
      );
}
