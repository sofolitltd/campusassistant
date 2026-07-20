import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/batch.dart';
import '../../../session/data/models/session_model.dart';

part 'batch_model.freezed.dart';
part 'batch_model.g.dart';

@freezed
abstract class BatchModel with _$BatchModel {
  const BatchModel._();

  const factory BatchModel({
    required String id,
    required String name,
    required String slug,
    @Default(true) bool isStudying,
    required String departmentId,
    required String universityId,
    @Default([]) List<SessionModel> sessions,
  }) = _BatchModel;

  factory BatchModel.fromJson(Map<String, dynamic> json) =>
      _$BatchModelFromJson(json);

  Batch toEntity() => Batch(
    id: id,
    name: name,
    slug: slug,
    isStudying: isStudying,
    departmentId: departmentId,
    universityId: universityId,
    sessions: sessions.map((s) => s.toEntity()).toList(),
  );

  factory BatchModel.fromEntity(Batch batch) => BatchModel(
    id: batch.id,
    name: batch.name,
    slug: batch.slug,
    isStudying: batch.isStudying,
    departmentId: batch.departmentId,
    universityId: batch.universityId,
    sessions: batch.sessions.map((s) => SessionModel.fromEntity(s)).toList(),
  );
}
