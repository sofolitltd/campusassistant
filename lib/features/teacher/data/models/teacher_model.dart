import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/teacher.dart';

part 'teacher_model.freezed.dart';
part 'teacher_model.g.dart';

@freezed
abstract class TeacherModel with _$TeacherModel {
  const TeacherModel._();

  const factory TeacherModel({
    required String id,
    @JsonKey(name: 'university_id') required String universityId,
    @JsonKey(name: 'department_id') required String departmentId,
    required bool present,
    required bool chairman,
    required int serial,
    required String name,
    required String post,
    required String phd,
    required String mobile,
    required String email,
    @JsonKey(name: 'image_url') required String imageUrl,
    required String interests,
    required String publications,
    required String token,
  }) = _TeacherModel;

  factory TeacherModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherModelFromJson(json);

  static TeacherModel fromJsonData(Map<String, dynamic> json) {
    // Custom handling for legacy/nested fields
    final userJson = json['user'] as Map<String, dynamic>?;

    final Map<String, dynamic> processedJson = Map<String, dynamic>.from(json);

    // Normalize ID
    processedJson['id'] = json['id'] ?? json['_id'] ?? '';

    // Normalize names/emails from nested user or alternate keys
    processedJson['name'] = userJson?['name'] ?? json['name'] ?? '';
    processedJson['email'] = userJson?['email'] ?? json['email'] ?? '';
    processedJson['mobile'] =
        userJson?['phone'] ?? json['phone'] ?? json['mobile'] ?? '';

    // Normalize keys to match Freezed fields with @JsonKey or direct names
    processedJson['university_id'] = json['university_id'] ?? '';
    processedJson['department_id'] = json['department_id'] ?? '';
    processedJson['present'] = json['present'] ?? json['is_present'] ?? false;
    processedJson['chairman'] =
        json['chairman'] ?? json['is_chairman'] ?? false;
    processedJson['serial'] = json['serial'] ?? json['weight'] ?? 0;
    processedJson['post'] = json['post'] ?? json['designation'] ?? '';
    processedJson['image_url'] = json['image_url'] ?? json['imageUrl'] ?? '';
    processedJson['phd'] = json['phd'] ?? '';
    processedJson['interests'] = json['interests'] ?? '';
    processedJson['publications'] = json['publications'] ?? '';
    processedJson['token'] = json['token'] ?? json['verification_code'] ?? '';

    return TeacherModel.fromJson(processedJson);
  }

  Teacher toEntity() => Teacher(
    id: id,
    universityId: universityId,
    departmentId: departmentId,
    present: present,
    chairman: chairman,
    serial: serial,
    name: name,
    post: post,
    phd: phd,
    mobile: mobile,
    email: email,
    imageUrl: imageUrl,
    interests: interests,
    publications: publications,
    token: token,
  );

  factory TeacherModel.fromEntity(Teacher teacher) => TeacherModel(
    id: teacher.id,
    universityId: teacher.universityId,
    departmentId: teacher.departmentId,
    present: teacher.present,
    chairman: teacher.chairman,
    serial: teacher.serial,
    name: teacher.name,
    post: teacher.post,
    phd: teacher.phd,
    mobile: teacher.mobile,
    email: teacher.email,
    imageUrl: teacher.imageUrl,
    interests: teacher.interests,
    publications: teacher.publications,
    token: teacher.token,
  );
}
