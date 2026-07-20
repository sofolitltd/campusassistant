import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/club.dart';

part 'club_model.freezed.dart';
part 'club_model.g.dart';

@freezed
abstract class ClubModel with _$ClubModel {
  const ClubModel._();

  const factory ClubModel({
    required String id,
    required String name,
    required String description,
    required String clubType,
    required String universityId,
    String? departmentId,
    String? logoUrl,
    String? bannerUrl,
    int? foundedYear,
    @Default(true) bool isActive,
    Map<String, dynamic>? socialLinks,
    String? contactEmail,
    String? contactPhone,
  }) = _ClubModel;

  factory ClubModel.fromJson(Map<String, dynamic> json) =>
      _$ClubModelFromJson(json);

  Club toEntity() => Club(
    id: id,
    name: name,
    description: description,
    clubType: clubType,
    universityId: universityId,
    departmentId: departmentId,
    logoUrl: logoUrl,
    bannerUrl: bannerUrl,
    foundedYear: foundedYear,
    isActive: isActive,
    socialLinks: socialLinks,
    contactEmail: contactEmail,
    contactPhone: contactPhone,
  );

  factory ClubModel.fromEntity(Club club) => ClubModel(
    id: club.id,
    name: club.name,
    description: club.description,
    clubType: club.clubType,
    universityId: club.universityId,
    departmentId: club.departmentId,
    logoUrl: club.logoUrl,
    bannerUrl: club.bannerUrl,
    foundedYear: club.foundedYear,
    isActive: club.isActive,
    socialLinks: club.socialLinks,
    contactEmail: club.contactEmail,
    contactPhone: club.contactPhone,
  );
}
