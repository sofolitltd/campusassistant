// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChapterModel _$ChapterModelFromJson(Map<String, dynamic> json) =>
    _ChapterModel(
      id: json['id'] as String,
      courseCode: json['course_code'] as String,
      chapterNo: (json['chapter_no'] as num).toInt(),
      chapterTitle: json['chapter_title'] as String,
      universityId: json['university_id'] as String,
      departmentId: json['department_id'] as String,
      batches: json['batches'] as List<dynamic>,
    );

Map<String, dynamic> _$ChapterModelToJson(_ChapterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'course_code': instance.courseCode,
      'chapter_no': instance.chapterNo,
      'chapter_title': instance.chapterTitle,
      'university_id': instance.universityId,
      'department_id': instance.departmentId,
      'batches': instance.batches,
    };
