import 'package:freezed_annotation/freezed_annotation.dart';

part 'university.freezed.dart';

@freezed
abstract class University with _$University {
  const factory University({
    required String id,
    required String name,
    required String acronym,
    required String slug,
    required String establishedYear,
    required String address,
    required String about,
    required double latitude,
    required double longitude,
    required String websiteUrl,
    @Default('') String logoUrl,
    @Default([]) List<String> images,
    @Default('0') String totalFaculties,
    @Default('0') String totalDepartments,
    @Default('0') String totalHalls,
    @Default('') String campusArea,
  }) = _University;
}
