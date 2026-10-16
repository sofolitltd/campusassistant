import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/course.dart';

abstract class CourseRepository {
  /// Stale-while-revalidate: emits cached courses first (if any), then the
  /// fresh list from the API when it differs. Errors only when there's
  /// neither cache nor network.
  Stream<List<Course>> watchCourses({
    required String universityId,
    required String departmentId,
    String? semesterId,
    String? batchId,
  });

  /// Stale-while-revalidate, like [watchCourses]. Emits null when the API
  /// has no course with this code.
  Stream<Course?> watchCourseByCode({
    required String universityId,
    required String departmentId,
    required String courseCode,
    String? batchId,
    String? semesterId,
  });

  Future<Either<Failure, Course>> createCourse(Course course);
  Future<Either<Failure, Course>> updateCourse(Course course);
  Future<Either<Failure, Unit>> deleteCourse(String id);
}
