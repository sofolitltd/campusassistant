import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/syllabus.dart';

part 'syllabus_model.freezed.dart';
part 'syllabus_model.g.dart';

@freezed
abstract class SyllabusModel with _$SyllabusModel {
  const SyllabusModel._();

  const factory SyllabusModel({
    required String id,
    required String title,
    @JsonKey(name: 'course_code') required String courseCode,
    @JsonKey(name: 'course_title') required String courseTitle,
    required String description,
    @JsonKey(name: 'file_url') required String fileUrl,
    @JsonKey(name: 'uploader_name') required String uploaderName,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    required List<String> batches,
    required List<dynamic> years,
    @JsonKey(name: 'university_id') required String universityId,
    @JsonKey(name: 'department_id') required String departmentId,
  }) = _SyllabusModel;

  factory SyllabusModel.fromJson(Map<String, dynamic> json) =>
      _$SyllabusModelFromJson(json);

  Syllabus toEntity() => Syllabus(
        id: id,
        title: title,
        courseCode: courseCode,
        courseTitle: courseTitle,
        description: description,
        fileUrl: fileUrl,
        uploaderName: uploaderName,
        createdAt: createdAt,
        batches: batches,
        years: years.map((e) => e.toString()).toList(),
        universityId: universityId,
        departmentId: departmentId,
      );

  factory SyllabusModel.fromEntity(Syllabus syllabus) => SyllabusModel(
        id: syllabus.id,
        title: syllabus.title,
        courseCode: syllabus.courseCode,
        courseTitle: syllabus.courseTitle,
        description: syllabus.description,
        fileUrl: syllabus.fileUrl,
        uploaderName: syllabus.uploaderName,
        createdAt: syllabus.createdAt,
        batches: syllabus.batches,
        years: syllabus.years,
        universityId: syllabus.universityId,
        departmentId: syllabus.departmentId,
      );
}
