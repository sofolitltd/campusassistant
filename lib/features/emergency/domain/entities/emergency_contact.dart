import 'package:freezed_annotation/freezed_annotation.dart';

part 'emergency_contact.freezed.dart';

@freezed
abstract class EmergencyContact with _$EmergencyContact {
  const factory EmergencyContact({
    required String id,
    required String title,
    String? designation,
    String? description,
    required String phone,
    String? email,
    String? category,
    required String scope,
    String? universityId,
    String? departmentId,
    @Default(false) bool isVerified,
    String? logoUrl,
  }) = _EmergencyContact;
}
