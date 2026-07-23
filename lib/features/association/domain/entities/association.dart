import 'package:freezed_annotation/freezed_annotation.dart';

part 'association.freezed.dart';
part 'association.g.dart';

/// Mirrors domain.Association on the backend — a district/sub-district
/// scoped student association within a university, structurally the same
/// as Club but swapping clubType/departmentId for
/// associationType/districtId/districtName/subDistrictId/subDistrictName.
///
/// Unlike Club (which splits a pure domain entity from a JSON-mapping
/// ClubModel), this combines both in one class — matching the lighter
/// convention already used for newer club sub-features (events/posts/user
/// summaries), since there's no offline-cache repository layer here to
/// justify the extra split.
@freezed
abstract class Association with _$Association {
  const factory Association({
    required String id,
    required String name,
    required String description,
    required String associationType,
    required String universityId,
    required String districtId,
    required String districtName,
    String? subDistrictId,
    String? subDistrictName,
    String? logoUrl,
    String? bannerUrl,
    int? foundedYear,
    @Default(true) bool isActive,
    Map<String, dynamic>? socialLinks,
    String? contactEmail,
    String? contactPhone,
    @Default(0) int followersCount,
    @Default(false) bool isFollowing,
    String? category,
    @Default(false) bool isVerified,
    @Default(0) int membersCount,
    @Default(false) bool isMember,
    @Default(false) bool isPendingMember,
  }) = _Association;

  factory Association.fromJson(Map<String, dynamic> json) =>
      _$AssociationFromJson(json);
}
