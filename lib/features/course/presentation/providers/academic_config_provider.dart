import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di.dart';
import '../../data/repositories/academic_config_repository_impl.dart';
import '../../domain/entities/course_category.dart';
import '../../domain/entities/course_prefix.dart';
import '../../domain/repositories/academic_config_repository.dart';

final academicConfigRepositoryProvider = Provider<AcademicConfigRepository>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return AcademicConfigRepositoryImpl(apiClient: apiClient);
});

final courseCategoriesProvider =
    FutureProvider.family<
      List<CourseCategory>,
      ({String universityId, String departmentId})
    >((ref, params) async {
      final repository = ref.watch(academicConfigRepositoryProvider);
      final result = await repository.getCategories(
        universityId: params.universityId,
        departmentId: params.departmentId,
      );
      return result.fold((l) => throw l, (r) => r);
    });

final coursePrefixesProvider =
    FutureProvider.family<
      List<CoursePrefix>,
      ({String universityId, String departmentId})
    >((ref, params) async {
      final repository = ref.watch(academicConfigRepositoryProvider);
      final result = await repository.getPrefixes(
        universityId: params.universityId,
        departmentId: params.departmentId,
      );
      return result.fold((l) => throw l, (r) => r);
    });

final createCourseCategoryProvider = Provider((ref) {
  final repository = ref.watch(academicConfigRepositoryProvider);
  return (CourseCategory category) => repository.createCategory(category);
});

final deleteCourseCategoryProvider = Provider((ref) {
  final repository = ref.watch(academicConfigRepositoryProvider);
  return (String id) => repository.deleteCategory(id);
});

final createCoursePrefixProvider = Provider((ref) {
  final repository = ref.watch(academicConfigRepositoryProvider);
  return (CoursePrefix prefix) => repository.createPrefix(prefix);
});

final deleteCoursePrefixProvider = Provider((ref) {
  final repository = ref.watch(academicConfigRepositoryProvider);
  return (String id) => repository.deletePrefix(id);
});
