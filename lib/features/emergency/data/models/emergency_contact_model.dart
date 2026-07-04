import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/emergency_contact.dart';

part 'emergency_contact_model.freezed.dart';
part 'emergency_contact_model.g.dart';

@freezed
abstract class EmergencyContactModel with _$EmergencyContactModel {
  const EmergencyContactModel._();

  const factory EmergencyContactModel({
    required String id,
    required String title,
    String? designation,
    String? description,
    required String phone,
    String? email,
    String? category,
    @JsonKey(name: 'target_scope') required String scope,
    @JsonKey(name: 'university_id') String? universityId,
    @JsonKey(name: 'department_id') String? departmentId,
    @JsonKey(name: 'is_verified') @Default(false) bool isVerified,
    @JsonKey(name: 'logo_url') String? logoUrl,
  }) = _EmergencyContactModel;

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) =>
      _$EmergencyContactModelFromJson(json);

  EmergencyContact toEntity() => EmergencyContact(
        id: id,
        title: title,
        designation: designation,
        description: description,
        phone: phone,
        email: email,
        category: category,
        scope: scope,
        universityId: universityId,
        departmentId: departmentId,
        isVerified: isVerified,
        logoUrl: logoUrl,
      );

  factory EmergencyContactModel.fromEntity(EmergencyContact contact) =>
      EmergencyContactModel(
        id: contact.id,
        title: contact.title,
        designation: contact.designation,
        description: contact.description,
        phone: contact.phone,
        email: contact.email,
        category: contact.category,
        scope: contact.scope,
        universityId: contact.universityId,
        departmentId: contact.departmentId,
        isVerified: contact.isVerified,
        logoUrl: contact.logoUrl,
      );
}
