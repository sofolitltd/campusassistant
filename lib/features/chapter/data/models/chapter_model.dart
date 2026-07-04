import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/chapter.dart';

part 'chapter_model.freezed.dart';
part 'chapter_model.g.dart';

@freezed
abstract class ChapterModel with _$ChapterModel {
  const ChapterModel._();

  const factory ChapterModel({
    required String id,
    @JsonKey(name: 'course_code') required String courseCode,
    @JsonKey(name: 'chapter_no') required int chapterNo,
    @JsonKey(name: 'chapter_title') required String chapterTitle,
    @JsonKey(name: 'university_id') required String universityId,
    @JsonKey(name: 'department_id') required String departmentId,
    required List<dynamic> batches, // dynamic to handle map/string mix
  }) = _ChapterModel;

  factory ChapterModel.fromJson(Map<String, dynamic> json) =>
      _$ChapterModelFromJson(json);

  Chapter toEntity() => Chapter(
        id: id,
        courseCode: courseCode,
        chapterNo: chapterNo,
        chapterTitle: chapterTitle,
        universityId: universityId,
        departmentId: departmentId,
        batches: batches.map((e) {
          if (e is Map) return e['id'].toString();
          return e.toString();
        }).toList(),
      );

  factory ChapterModel.fromEntity(Chapter chapter) => ChapterModel(
        id: chapter.id,
        courseCode: chapter.courseCode,
        chapterNo: chapter.chapterNo,
        chapterTitle: chapter.chapterTitle,
        universityId: chapter.universityId,
        departmentId: chapter.departmentId,
        batches: chapter.batches.map((id) => {'id': id}).toList(),
      );
}
