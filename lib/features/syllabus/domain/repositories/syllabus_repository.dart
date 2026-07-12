import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/syllabus.dart';

class PaginatedSyllabi {
  final List<Syllabus> syllabi;
  final int total;
  PaginatedSyllabi({required this.syllabi, required this.total});
}

abstract class SyllabusRepository {
  Future<Either<Failure, PaginatedSyllabi>> getSyllabi({
    required String universityId,
    required String departmentId,
    String? search,
    int? limit,
    int? offset,
  });
}
