import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher.freezed.dart';

@freezed
abstract class Teacher with _$Teacher {
  const factory Teacher({
    required String id,
    required String universityId,
    required String departmentId,
    required bool present,
    required bool chairman,
    required int serial,
    required String name,
    required String post,
    required String phd,
    required String mobile,
    required String email,
    required String imageUrl,
    required String interests,
    required String publications,
    required String token,
  }) = _Teacher;
}
