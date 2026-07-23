import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/student.dart';
import '../../domain/entities/student_address.dart';
import '/features/auth/data/models/user_model.dart';

part 'student_model.freezed.dart';
part 'student_model.g.dart';

// Returns the raw nested map, not a parsed StudentAddress — json_serializable
// itself calls StudentAddress.fromJson on whatever readValue returns, so
// returning an already-built StudentAddress here double-converts and throws
// "type 'StudentAddress' is not a subtype of type 'Map<String, dynamic>'".
Map<String, dynamic>? _readStudentAddress(Map<dynamic, dynamic> json, String key) {
  final raw = json[key];
  if (raw is! Map) return null;
  return Map<String, dynamic>.from(raw);
}

Map<String, dynamic>? _writeStudentAddress(StudentAddress? address) =>
    address?.toJson();

Object? _readUniversityName(Map<dynamic, dynamic> json, String key) =>
    json['university_name'] ??
    (json['university'] is Map ? json['university']['name'] : null);

Object? _readDepartmentName(Map<dynamic, dynamic> json, String key) =>
    json['department_name'] ??
    (json['department'] is Map ? json['department']['name'] : null);

Object? _readBatchName(Map<dynamic, dynamic> json, String key) =>
    json['batch_name'] ?? (json['batch'] is Map ? json['batch']['name'] : null);

Object? _readSessionName(Map<dynamic, dynamic> json, String key) =>
    json['session_name'] ??
    (json['session'] is Map ? json['session']['name'] : null);

@freezed
abstract class StudentModel with _$StudentModel {
  const StudentModel._();

  const factory StudentModel({
    required String id,
    required String studentId,
    required String universityId,
    required String departmentId,
    required String batchId,
    required String sessionId,
    String? hallId,
    required String bloodGroup,
    required String verificationCode,
    @Default(false) bool isClaimed,
    @JsonKey(name: 'name') String? studentName,
    String? email,
    String? phone,
    @Default(true) bool isRegular,
    @Default(false) bool isCR,
    String? userId,
    UserModel? user,
    String? hallName,
    @JsonKey(readValue: _readBatchName) String? batchName,
    @JsonKey(readValue: _readDepartmentName) String? departmentName,
    @JsonKey(readValue: _readUniversityName) String? universityName,
    @JsonKey(readValue: _readSessionName) String? sessionName,
    @JsonKey(name: 'present_address', readValue: _readStudentAddress, toJson: _writeStudentAddress)
    StudentAddress? presentAddress,
    @JsonKey(name: 'permanent_address', readValue: _readStudentAddress, toJson: _writeStudentAddress)
    StudentAddress? permanentAddress,
  }) = _StudentModel;

  factory StudentModel.fromJson(Map<String, dynamic> json) =>
      _$StudentModelFromJson(json);

  Student toEntity() => Student(
    id: id,
    studentId: studentId,
    universityId: universityId,
    departmentId: departmentId,
    batchId: batchId,
    sessionId: sessionId,
    hallId: hallId,
    bloodGroup: bloodGroup,
    verificationCode: verificationCode,
    isClaimed: isClaimed,
    studentName: studentName,
    email: email,
    phone: phone,
    isRegular: isRegular,
    isCR: isCR,
    userId: userId,
    user: user?.toEntity(),
    hallName: hallName,
    batchName: batchName,
    departmentName: departmentName,
    universityName: universityName,
    sessionName: sessionName,
    presentAddress: presentAddress,
    permanentAddress: permanentAddress,
  );

  factory StudentModel.fromEntity(Student student) => StudentModel(
    id: student.id,
    studentId: student.studentId,
    universityId: student.universityId,
    departmentId: student.departmentId,
    batchId: student.batchId,
    sessionId: student.sessionId,
    hallId: student.hallId,
    bloodGroup: student.bloodGroup,
    verificationCode: student.verificationCode,
    isClaimed: student.isClaimed,
    studentName: student.studentName,
    email: student.email,
    phone: student.phone,
    isRegular: student.isRegular,
    isCR: student.isCR,
    userId: student.userId,
    user: student.user != null ? UserModel.fromEntity(student.user!) : null,
    hallName: student.hallName,
    batchName: student.batchName,
    departmentName: student.departmentName,
    universityName: student.universityName,
    sessionName: student.sessionName,
    presentAddress: student.presentAddress,
    permanentAddress: student.permanentAddress,
  );
}
