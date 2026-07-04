import 'package:freezed_annotation/freezed_annotation.dart';

part 'alumni_organization.freezed.dart';

@freezed
abstract class AlumniOrganization with _$AlumniOrganization {
  const factory AlumniOrganization({
    required String id,
    required String name,
    required String logoUrl,
    required String website,
  }) = _AlumniOrganization;
}
