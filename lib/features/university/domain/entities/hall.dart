import 'package:freezed_annotation/freezed_annotation.dart';

part 'hall.freezed.dart';

@freezed
abstract class Hall with _$Hall {
  const factory Hall({
    required String id,
    required String name,
    required String slug,
    required String universityId,
  }) = _Hall;
}
