import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';

/// A global admission period — "2017-2018" (academic year) or "Spring 2023"
/// (semester intake). One per period across all universities; which ones
/// apply to a department is decided by its batches (`Batch.sessions`).
@freezed
abstract class Session with _$Session {
  const factory Session({
    required String id,
    required String name,
    @Default('academic_year') String kind,
    @Default(0) int startYear,
    @Default('') String term,
  }) = _Session;
}
