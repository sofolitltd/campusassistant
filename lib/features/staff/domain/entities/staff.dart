import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff.freezed.dart';

@freezed
abstract class Staff with _$Staff {
  const Staff._();

  const factory Staff({
    required String id,
    required String universityId,
    required String departmentId,
    required String name,
    required String post,
    required String mobile,
    required String imageUrl,
    required int serial,
    @Default('') String verificationCode,
    @Default(false) bool isClaimed,
  }) = _Staff;

  String get phone => mobile;
}
