import '../entities/syllabus.dart';

class PaginatedSyllabi {
  final List<Syllabus> syllabi;
  final int total;
  PaginatedSyllabi({required this.syllabi, required this.total});
}

abstract class SyllabusRepository {
  Future<PaginatedSyllabi> getSyllabi({
    required String universityId,
    required String departmentId,
    String? search,
    int? limit,
    int? offset,
  });
}
