import 'package:freezed_annotation/freezed_annotation.dart';

part 'routine.freezed.dart';

@freezed
abstract class Routine with _$Routine {
  const factory Routine({
    required String id,
    required String title,
    required String imageUrl,
    required String time,
    required String universityId,
    required String departmentId,
  }) = _Routine;
}
