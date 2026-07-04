import 'package:freezed_annotation/freezed_annotation.dart';

part 'semester.freezed.dart';

@freezed
abstract class Semester with _$Semester {
  const factory Semester({
    required String id,
    required String name,
    required int order,
    required String status,
    required String universityId,
    required String departmentId,
    required int totalCourses,
    required double totalCredits,
    required int totalMarks,
    required List<String> batches,
    String? createdById,
    String? updatedById,
  }) = _Semester;
}
