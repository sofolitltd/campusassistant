import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/course_category.dart';
import '../entities/course_prefix.dart';

abstract class AcademicConfigRepository {
  // Categories
  Future<Either<Failure, List<CourseCategory>>> getCategories({
    required String universityId,
    required String departmentId,
  });
  Future<Either<Failure, CourseCategory>> createCategory(
    CourseCategory category,
  );
  Future<Either<Failure, Unit>> deleteCategory(String id);

  // Prefixes
  Future<Either<Failure, List<CoursePrefix>>> getPrefixes({
    required String universityId,
    required String departmentId,
  });
  Future<Either<Failure, CoursePrefix>> createPrefix(CoursePrefix prefix);
  Future<Either<Failure, Unit>> deletePrefix(String id);
}
