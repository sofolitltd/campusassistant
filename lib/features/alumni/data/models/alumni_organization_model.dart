import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/alumni_organization.dart';

part 'alumni_organization_model.freezed.dart';
part 'alumni_organization_model.g.dart';

@freezed
abstract class AlumniOrganizationModel with _$AlumniOrganizationModel {
  const AlumniOrganizationModel._();

  const factory AlumniOrganizationModel({
    required String id,
    required String name,
    @JsonKey(name: 'logo_url') @Default('') String logoUrl,
    @Default('') String website,
  }) = _AlumniOrganizationModel;

  factory AlumniOrganizationModel.fromJson(Map<String, dynamic> json) =>
      _$AlumniOrganizationModelFromJson(json);

  AlumniOrganization toEntity() => AlumniOrganization(
    id: id,
    name: name,
    logoUrl: logoUrl,
    website: website,
  );

  factory AlumniOrganizationModel.fromEntity(AlumniOrganization org) =>
      AlumniOrganizationModel(
        id: org.id,
        name: org.name,
        logoUrl: org.logoUrl,
        website: org.website,
      );
}
