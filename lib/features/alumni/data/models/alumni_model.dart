import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/alumni.dart';
import 'alumni_organization_model.dart';

part 'alumni_model.freezed.dart';
part 'alumni_model.g.dart';

@freezed
abstract class AlumniModel with _$AlumniModel {
  const AlumniModel._();

  const factory AlumniModel({
    required String id,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'student_id') required String studentId,
    required String email,
    required String phone,
    required String batch,
    @JsonKey(name: 'passing_year') required String passingYear,
    @JsonKey(name: 'current_status') required String currentStatus,
    @Default('') String organization,
    @Default('') String designation,
    @Default('') String location,
    @Default('') String bio,
    @JsonKey(name: 'profile_image') @Default('') String profileImage,
    @JsonKey(name: 'social_links') Map<String, dynamic>? socialLinks,
    @JsonKey(name: 'created_by') @Default('') String createdBy,
    @JsonKey(name: 'university_id') required String universityId,
    @JsonKey(name: 'department_id') required String departmentId,
    @JsonKey(name: 'organization_id') String? organizationId,
    @JsonKey(name: 'organization_ref') AlumniOrganizationModel? organizationRef,
  }) = _AlumniModel;

  factory AlumniModel.fromJson(Map<String, dynamic> json) =>
      _$AlumniModelFromJson(json);

  /// Converts this Model to the Domain Entity
  Alumni toEntity() => Alumni(
    id: id,
    fullName: fullName,
    studentId: studentId,
    email: email,
    phone: phone,
    batch: batch,
    passingYear: passingYear,
    currentStatus: currentStatus,
    organization: organization,
    designation: designation,
    location: location,
    bio: bio,
    profileImage: profileImage,
    socialLinks: socialLinks,
    createdBy: createdBy,
    universityId: universityId,
    departmentId: departmentId,
    organizationId: organizationId,
    organizationRef: organizationRef?.toEntity(),
  );

  /// Creates a Model from a Domain Entity (for outgoing requests)
  factory AlumniModel.fromEntity(Alumni alumni) => AlumniModel(
    id: alumni.id,
    fullName: alumni.fullName,
    studentId: alumni.studentId,
    email: alumni.email,
    phone: alumni.phone,
    batch: alumni.batch,
    passingYear: alumni.passingYear,
    currentStatus: alumni.currentStatus,
    organization: alumni.organization,
    designation: alumni.designation,
    location: alumni.location,
    bio: alumni.bio,
    profileImage: alumni.profileImage,
    socialLinks: alumni.socialLinks,
    createdBy: alumni.createdBy,
    universityId: alumni.universityId,
    departmentId: alumni.departmentId,
    organizationId: alumni.organizationId,
    organizationRef: alumni.organizationRef != null
        ? AlumniOrganizationModel.fromEntity(alumni.organizationRef!)
        : null,
  );
}
