import 'package:freezed_annotation/freezed_annotation.dart';

part 'banner.freezed.dart';

@freezed
abstract class Banner with _$Banner {
  const factory Banner({
    required String id,
    required String title,
    required String imageUrl,
    required String clickUrl,
    required int priority,
    required bool isActive,
    required DateTime startAt,
    required DateTime endAt,
    required String targetScope, // National, University, Department
    @Default([]) List<BannerTarget> targets,
  }) = _Banner;
}

@freezed
abstract class BannerTarget with _$BannerTarget {
  const factory BannerTarget({
    int? id,
    required String bannerId,
    String? universityId,
    String? departmentId,
  }) = _BannerTarget;
}
