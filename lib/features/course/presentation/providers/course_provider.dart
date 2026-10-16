import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/di.dart';
import '../../../../core/providers/app_refresh_provider.dart';
import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../../data/repositories/course_repository_impl.dart';
import '../../../../core/providers/cache_for.dart';

part 'course_provider.g.dart';

@Riverpod(keepAlive: true)
CourseRepository courseRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  final cacheManager = ref.watch(cacheManagerProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  return CourseRepositoryImpl(
    apiClient: apiClient,
    cacheManager: cacheManager,
    connectivity: connectivity,
  );
}

@riverpod
Stream<List<Course>> courses(
  Ref ref, {
  required String universityId,
  required String departmentId,
  String? semesterId,
  String? batchId,
}) {
  ref.cacheFor(kParamProviderCacheTime);
  ref.watch(appRefreshProvider);
  debugPrint('[courses] Fetching: semesterId=$semesterId batchId=$batchId');
  final repo = ref.watch(courseRepositoryProvider);
  return repo.watchCourses(
    universityId: universityId,
    departmentId: departmentId,
    semesterId: semesterId,
    batchId: batchId,
  );
}

@riverpod
Stream<Course?> courseByCode(
  Ref ref, {
  required String universityId,
  required String departmentId,
  required String courseCode,
  String? batchId,
  String? semesterId,
}) async* {
  ref.cacheFor(kParamProviderCacheTime);
  final repo = ref.watch(courseRepositoryProvider);
  try {
    yield* repo.watchCourseByCode(
      universityId: universityId,
      departmentId: departmentId,
      courseCode: courseCode,
      batchId: batchId,
      semesterId: semesterId,
    );
  } catch (_) {
    // The details page treats "no course" and "couldn't load" the same.
    yield null;
  }
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
    final category =
        (course.courseCategory?.name ?? course.courseCategoryId ?? 'Unknown');
    grouped.putIfAbsent(category, () => []).add(course);
  }
  return grouped;
}
