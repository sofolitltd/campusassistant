import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/semester.dart';

part 'semester_model.freezed.dart';
part 'semester_model.g.dart';

@freezed
abstract class SemesterModel with _$SemesterModel {
  const SemesterModel._();

  const factory SemesterModel({
    required String id,
    required String name,
    required int order,
    required String status,
    @JsonKey(name: 'university_id') required String universityId,
    @JsonKey(name: 'department_id') required String departmentId,
    @JsonKey(name: 'total_courses') required int totalCourses,
    @JsonKey(name: 'total_credits') required double totalCredits,
    @JsonKey(name: 'total_marks') required int totalMarks,
    required List<dynamic> batches, // Use dynamic to handle flexible parsing
    @JsonKey(name: 'created_by_id') String? createdById,
    @JsonKey(name: 'updated_by_id') String? updatedById,
  }) = _SemesterModel;

  factory SemesterModel.fromJson(Map<String, dynamic> json) =>
      _$SemesterModelFromJson(json);

  Semester toEntity() => Semester(
        id: id,
        name: name,
        order: order,
        status: status,
        universityId: universityId,
        departmentId: departmentId,
        totalCourses: totalCourses,
        totalCredits: totalCredits,
        totalMarks: totalMarks,
        batches: batches.map((e) {
          if (e is Map<String, dynamic>) return e['id'].toString();
          return e.toString();
        }).toList(),
        createdById: createdById,
        updatedById: updatedById,
      );

  factory SemesterModel.fromEntity(Semester semester) => SemesterModel(
        id: semester.id,
        name: semester.name,
        order: semester.order,
        status: semester.status,
        universityId: semester.universityId,
        departmentId: semester.departmentId,
        totalCourses: semester.totalCourses,
        totalCredits: semester.totalCredits,
        totalMarks: semester.totalMarks,
        batches: semester.batches,
        createdById: semester.createdById,
        updatedById: semester.updatedById,
      );
}
