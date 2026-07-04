import 'package:freezed_annotation/freezed_annotation.dart';
import 'alumni_organization.dart';

part 'alumni.freezed.dart';

@freezed
abstract class Alumni with _$Alumni {
  const factory Alumni({
    required String id,
    required String fullName,
    required String studentId,
    required String email,
    required String phone,
    required String batch,
    required String passingYear,
    required String currentStatus,
    required String organization,
    required String designation,
    required String location,
    required String bio,
    required String profileImage,
    Map<String, dynamic>? socialLinks,
    required String createdBy,
    required String universityId,
    required String departmentId,
    String? organizationId,
    AlumniOrganization? organizationRef,
  }) = _Alumni;
}
