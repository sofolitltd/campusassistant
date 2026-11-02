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
    @Default('academic_year') String kind,
    @Default(0) int startYear,
    @Default('') String term,
  }) = _SessionModel;

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);

  Session toEntity() =>
      Session(id: id, name: name, kind: kind, startYear: startYear, term: term);

  factory SessionModel.fromEntity(Session session) => SessionModel(
    id: session.id,
    name: session.name,
    kind: session.kind,
    startYear: session.startYear,
    term: session.term,
  );
}
