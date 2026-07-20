import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/university.dart';

part 'university_model.freezed.dart';
part 'university_model.g.dart';

@freezed
abstract class UniversityModel with _$UniversityModel {
  const UniversityModel._();

  const factory UniversityModel({
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
  }) = _UniversityModel;

  factory UniversityModel.fromJson(Map<String, dynamic> json) =>
      _$UniversityModelFromJson(json);

  University toEntity() => University(
    id: id,
    name: name,
    acronym: acronym,
    slug: slug,
    establishedYear: establishedYear,
    address: address,
    about: about,
    latitude: latitude,
    longitude: longitude,
    websiteUrl: websiteUrl,
    logoUrl: logoUrl,
    images: images,
    totalFaculties: totalFaculties,
    totalDepartments: totalDepartments,
    totalHalls: totalHalls,
    campusArea: campusArea,
  );

  factory UniversityModel.fromEntity(University university) => UniversityModel(
    id: university.id,
    name: university.name,
    acronym: university.acronym,
    slug: university.slug,
    establishedYear: university.establishedYear,
    address: university.address,
    about: university.about,
    latitude: university.latitude,
    longitude: university.longitude,
    websiteUrl: university.websiteUrl,
    logoUrl: university.logoUrl,
    images: university.images,
    totalFaculties: university.totalFaculties,
    totalDepartments: university.totalDepartments,
    totalHalls: university.totalHalls,
    campusArea: university.campusArea,
  );
}
