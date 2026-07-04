import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/course_prefix.dart';

part 'course_prefix_model.freezed.dart';
part 'course_prefix_model.g.dart';

@freezed
abstract class CoursePrefixModel with _$CoursePrefixModel {
  const CoursePrefixModel._();

  const factory CoursePrefixModel({
    required String id,
    required String prefix,
    required String description,
    required String departmentId,
    required String universityId,
  }) = _CoursePrefixModel;

  factory CoursePrefixModel.fromJson(Map<String, dynamic> json) =>
      _$CoursePrefixModelFromJson(json);

  CoursePrefix toEntity() => CoursePrefix(
        id: id,
        prefix: prefix,
        description: description,
        departmentId: departmentId,
        universityId: universityId,
      );

  factory CoursePrefixModel.fromEntity(CoursePrefix prefix) =>
      CoursePrefixModel(
        id: prefix.id,
        prefix: prefix.prefix,
        description: prefix.description,
        departmentId: prefix.departmentId,
        universityId: prefix.universityId,
      );
}
