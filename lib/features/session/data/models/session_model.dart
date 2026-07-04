import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/session.dart';

part 'session_model.freezed.dart';
part 'session_model.g.dart';

@freezed
abstract class SessionModel with _$SessionModel {
  const SessionModel._();

  const factory SessionModel({
    required String id,
    required String name,
    required String slug,
    required String universityId,
    String? departmentId,
    @Default(true) bool isActive,
  }) = _SessionModel;

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);

  Session toEntity() => Session(
        id: id,
        name: name,
        slug: slug,
        universityId: universityId,
        departmentId: departmentId,
        isActive: isActive,
      );

  factory SessionModel.fromEntity(Session session) => SessionModel(
        id: session.id,
        name: session.name,
        slug: session.slug,
        universityId: session.universityId,
        departmentId: session.departmentId,
        isActive: session.isActive,
      );
}
