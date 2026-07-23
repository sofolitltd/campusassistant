import 'package:freezed_annotation/freezed_annotation.dart';
import '/features/auth/domain/entities/user.dart';
import 'student_address.dart';

part 'student.freezed.dart';

@freezed
abstract class Student with _$Student {
  const Student._();

  const factory Student({
    required String id,
    required String studentId,
    required String universityId,
    required String departmentId,
    required String batchId,
    required String sessionId,
    String? hallId,
    required String bloodGroup,
    required String verificationCode,
    required bool isClaimed,
    String? studentName,
    String? email,
    String? phone,
    @Default(true) bool isRegular,
    @Default(false) bool isCR,
    String? userId,
    User? user,
    String? hallName,
    String? batchName,
    String? departmentName,
    String? universityName,
    String? sessionName,
    StudentAddress? presentAddress,
    StudentAddress? permanentAddress,
  }) = _Student;

  String get name => user?.fullName ?? studentName ?? 'Unclaimed Profile';
  String get token => verificationCode;
  String get imageUrl => user?.profileImage ?? '';
  String get blood => bloodGroup;
  String get hall => hallName ?? 'None';
  String get session => sessionName ?? sessionId;
  String get batch => batchName ?? batchId;
}
