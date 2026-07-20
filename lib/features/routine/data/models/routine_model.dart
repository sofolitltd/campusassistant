import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/routine.dart';

part 'routine_model.freezed.dart';
part 'routine_model.g.dart';

@freezed
abstract class RoutineModel with _$RoutineModel {
  const RoutineModel._();

  const factory RoutineModel({
    required String id,
    required String title,
    @JsonKey(name: 'image_url') required String imageUrl,
    required String time,
    @JsonKey(name: 'university_id') required String universityId,
    @JsonKey(name: 'department_id') required String departmentId,
  }) = _RoutineModel;

  factory RoutineModel.fromJson(Map<String, dynamic> json) =>
      _$RoutineModelFromJson(json);

  Routine toEntity() => Routine(
    id: id,
    title: title,
    imageUrl: imageUrl,
    time: time,
    universityId: universityId,
    departmentId: departmentId,
  );

  factory RoutineModel.fromEntity(Routine routine) => RoutineModel(
    id: routine.id,
    title: routine.title,
    imageUrl: routine.imageUrl,
    time: routine.time,
    universityId: routine.universityId,
    departmentId: routine.departmentId,
  );
}
