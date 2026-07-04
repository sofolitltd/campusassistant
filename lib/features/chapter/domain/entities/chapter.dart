import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter.freezed.dart';

@freezed
abstract class Chapter with _$Chapter {
  const factory Chapter({
    required String id,
    required String courseCode,
    required int chapterNo,
    required String chapterTitle,
    required String universityId,
    required String departmentId,
    required List<String> batches,
  }) = _Chapter;
}
