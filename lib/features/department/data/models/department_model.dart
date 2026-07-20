import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/department.dart';

part 'department_model.freezed.dart';
part 'department_model.g.dart';

@freezed
abstract class DepartmentModel with _$DepartmentModel {
  const DepartmentModel._();

  const factory DepartmentModel({
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
  }) = _DepartmentModel;

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelFromJson(json);

  Department toEntity() => Department(
    id: id,
    name: name,
    acronym: acronym,
    slug: slug,
    universityId: universityId,
    establishedYear: establishedYear,
    about: about,
    logoUrl: logoUrl,
    websiteUrl: websiteUrl,
    images: images,
  );

  factory DepartmentModel.fromEntity(Department department) => DepartmentModel(
    id: department.id,
    name: department.name,
    acronym: department.acronym,
    slug: department.slug,
    universityId: department.universityId,
    establishedYear: department.establishedYear,
    about: department.about,
    logoUrl: department.logoUrl,
    websiteUrl: department.websiteUrl,
    images: department.images,
  );
}
