import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/course.dart';

abstract class CourseRepository {
  Future<Either<Failure, List<Course>>> getCourses({
    required String universityId,
    required String departmentId,
    String? semesterId,
    String? batchId,
  });

  Future<Either<Failure, Course>> getCourseByCode({
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
