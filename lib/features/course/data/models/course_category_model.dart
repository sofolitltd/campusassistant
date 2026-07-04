import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/course_category.dart';

part 'course_category_model.freezed.dart';
part 'course_category_model.g.dart';

@freezed
abstract class CourseCategoryModel with _$CourseCategoryModel {
  const CourseCategoryModel._();

  const factory CourseCategoryModel({
    required String id,
    required String name,
    required int order,
    required String departmentId,
    required String universityId,
  }) = _CourseCategoryModel;

  factory CourseCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CourseCategoryModelFromJson(json);

  CourseCategory toEntity() => CourseCategory(
        id: id,
        name: name,
        order: order,
        departmentId: departmentId,
        universityId: universityId,
      );

  factory CourseCategoryModel.fromEntity(CourseCategory category) =>
      CourseCategoryModel(
        id: category.id,
        name: category.name,
        order: category.order,
        departmentId: category.departmentId,
        universityId: category.universityId,
      );
}
