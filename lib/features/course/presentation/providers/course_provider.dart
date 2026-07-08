import 'package:flutter/foundation.dart';
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
  String? semesterId,
  String? batchId,
}) async {
  ref.watch(appRefreshProvider);
  debugPrint(
    '[courses] Fetching: semesterId=$semesterId batchId=$batchId',
  );
  final repo = ref.watch(courseRepositoryProvider);
  final result = await repo.getCourses(
    universityId: universityId,
    departmentId: departmentId,
    semesterId: semesterId,
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
  String? batchId,
  String? semesterId,
}) async {
  final repo = ref.watch(courseRepositoryProvider);
  final result = await repo.getCourseByCode(
    universityId: universityId,
    departmentId: departmentId,
    courseCode: courseCode,
    batchId: batchId,
    semesterId: semesterId,
  );
  return result.fold((failure) => null, (course) => course);
}

@riverpod
Future<Map<String, List<Course>>> groupedCourses(
  Ref ref, {
  required String universityId,
  required String departmentId,
  String? semesterId,
  String? batchId,
}) async {
  final coursesList = await ref.watch(
    coursesProvider(
      universityId: universityId,
      departmentId: departmentId,
      semesterId: semesterId,
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
