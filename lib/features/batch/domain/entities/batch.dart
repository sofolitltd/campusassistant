import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../session/domain/entities/session.dart';

part 'batch.freezed.dart';

@freezed
abstract class Batch with _$Batch {
  const factory Batch({
    required String id,
    required String name,
    required String slug,
    required bool isStudying,
    required String departmentId,
    required String universityId,
    required List<Session> sessions,
    // 'honours' | 'masters' — Honors and Masters intakes are separate batches.
    @Default('honours') String program,
    // 16:9 WebP cover photo; '' = none (the card draws the batch number).
    @Default('') String imageUrl,
  }) = _Batch;
}
