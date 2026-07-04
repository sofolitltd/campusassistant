import 'package:freezed_annotation/freezed_annotation.dart';

part 'department.freezed.dart';

@freezed
abstract class Department with _$Department {
  const factory Department({
    required String id,
    required String name,
    required String acronym,
    required String slug,
    required String universityId,
    required int establishedYear,
    required String about,
    @Default('') String logoUrl,
    @Default('') String websiteUrl,
    @Default([]) List<String> images,
  }) = _Department;
}
