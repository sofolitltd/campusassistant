import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/hall.dart';

part 'hall_model.freezed.dart';
part 'hall_model.g.dart';

@freezed
abstract class HallModel with _$HallModel {
  const HallModel._();

  const factory HallModel({
    required String id,
    required String name,
    required String slug,
    required String universityId,
  }) = _HallModel;

  factory HallModel.fromJson(Map<String, dynamic> json) =>
      _$HallModelFromJson(json);

  Hall toEntity() =>
      Hall(id: id, name: name, slug: slug, universityId: universityId);

  factory HallModel.fromEntity(Hall hall) => HallModel(
    id: hall.id,
    name: hall.name,
    slug: hall.slug,
    universityId: hall.universityId,
  );
}
