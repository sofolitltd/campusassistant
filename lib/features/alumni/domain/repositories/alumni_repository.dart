import '../entities/alumni.dart';
import '../entities/alumni_organization.dart';

class PaginatedAlumni {
  final List<Alumni> alumniList;
  final int total;
  PaginatedAlumni({required this.alumniList, required this.total});
}

abstract class AlumniRepository {
  Future<PaginatedAlumni> getAlumni({
    String? universityId,
    String? departmentId,
    String? batch,
    String? search,
    String? organizationId,
    int? limit,
    int? offset,
  });

  Future<Alumni> getAlumniById(String id);

  Future<void> createAlumni(Alumni alumni);

  Future<List<AlumniOrganization>> getOrganizations({String? search});
}
