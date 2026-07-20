import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/banner.dart';

part 'banner_model.freezed.dart';
part 'banner_model.g.dart';

@freezed
abstract class BannerModel with _$BannerModel {
  const BannerModel._();

  const factory BannerModel({
    required String id,
    required String title,
    @JsonKey(name: 'image_url') required String imageUrl,
    @JsonKey(name: 'click_url') required String clickUrl,
    required int priority,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'start_at') required DateTime startAt,
    @JsonKey(name: 'end_at') required DateTime endAt,
    @JsonKey(name: 'target_scope') required String targetScope,
    @Default([]) List<BannerTargetModel> targets,
  }) = _BannerModel;

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);

  Banner toEntity() => Banner(
    id: id,
    title: title,
    imageUrl: imageUrl,
    clickUrl: clickUrl,
    priority: priority,
    isActive: isActive,
    startAt: startAt,
    endAt: endAt,
    targetScope: targetScope,
    targets: targets.map((t) => t.toEntity()).toList(),
  );

  factory BannerModel.fromEntity(Banner banner) => BannerModel(
    id: banner.id,
    title: banner.title,
    imageUrl: banner.imageUrl,
    clickUrl: banner.clickUrl,
    priority: banner.priority,
    isActive: banner.isActive,
    startAt: banner.startAt,
    endAt: banner.endAt,
    targetScope: banner.targetScope,
    targets: banner.targets
        .map((t) => BannerTargetModel.fromEntity(t))
        .toList(),
  );
}

@freezed
abstract class BannerTargetModel with _$BannerTargetModel {
  const BannerTargetModel._();

  const factory BannerTargetModel({
    int? id,
    @JsonKey(name: 'banner_id') required String bannerId,
    @JsonKey(name: 'university_id') String? universityId,
    @JsonKey(name: 'department_id') String? departmentId,
  }) = _BannerTargetModel;

  factory BannerTargetModel.fromJson(Map<String, dynamic> json) =>
      _$BannerTargetModelFromJson(json);

  BannerTarget toEntity() => BannerTarget(
    id: id,
    bannerId: bannerId,
    universityId: universityId,
    departmentId: departmentId,
  );

  factory BannerTargetModel.fromEntity(BannerTarget target) =>
      BannerTargetModel(
        id: target.id,
        bannerId: target.bannerId,
        universityId: target.universityId,
        departmentId: target.departmentId,
      );
}
