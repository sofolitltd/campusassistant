import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di.dart';
import '../../../../core/providers/app_refresh_provider.dart';
import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../../data/repositories/course_repository_impl.dart';

part 'course_provider.g.dart';

@Riverpod(keepAlive: true)
CourseRepository courseRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CourseRepositoryImpl(apiClient: apiClient);
}

@riverpod
Future<List<Course>> courses(
  Ref ref, {
  required String universityId,
  required String departmentId,
  String? courseYear,
  String? batchId,
}) async {
  ref.watch(appRefreshProvider);
  final repo = ref.watch(courseRepositoryProvider);
  final result = await repo.getCourses(
    universityId: universityId,
    departmentId: departmentId,
    courseYear: courseYear,
    batchId: batchId,
  );
  return result.fold((failure) => throw failure, (courses) => courses);
}

@riverpod
Future<Course?> courseByCode(
  Ref ref, {
  required String universityId,
  required String departmentId,
  required String courseCode,
}) async {
  final repo = ref.watch(courseRepositoryProvider);
  final result = await repo.getCourseByCode(
    universityId: universityId,
    departmentId: departmentId,
    courseCode: courseCode,
  );
  return result.fold((failure) => null, (course) => course);
}

@riverpod
Future<Map<String, List<Course>>> groupedCourses(
  Ref ref, {
  required String universityId,
  required String departmentId,
  String? courseYear,
  String? batchId,
}) async {
  final coursesList = await ref.watch(
    coursesProvider(
      universityId: universityId,
      departmentId: departmentId,
      courseYear: courseYear,
      batchId: batchId,
    ).future,
  );
  final Map<String, List<Course>> grouped = {};
  for (final course in coursesList) {
    // Group by category using the enterprise display logic
    final category = (course.courseCategory?.name ?? course.courseCategoryId ?? 'Unknown');
    grouped.putIfAbsent(category, () => []).add(course);
  }
  return grouped;
}
