import 'package:freezed_annotation/freezed_annotation.dart';

part 'club.freezed.dart';

@freezed
abstract class Club with _$Club {
  const factory Club({
    required String id,
    required String name,
    required String description,
    required String clubType,
    required String universityId,
    String? departmentId,
    String? logoUrl,
    String? bannerUrl,
    int? foundedYear,
    required bool isActive,
    Map<String, dynamic>? socialLinks,
    String? contactEmail,
    String? contactPhone,
    @Default(0) int followersCount,
    @Default(false) bool isFollowing,
    String? category,
    @Default(false) bool isVerified,
    @Default(0) int membersCount,
    @Default(false) bool isMember,
  }) = _Club;
}
