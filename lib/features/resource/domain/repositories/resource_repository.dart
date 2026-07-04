import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/resource.dart';

class PaginatedResources {
  final List<Resource> resources;
  final int total;
  PaginatedResources({required this.resources, required this.total});
}

abstract class ResourceRepository {
  Future<Either<Failure, PaginatedResources>> getResources({
    required String universityId,
    required String departmentId,
    String? type,
    String? courseCode,
    String? batch,
    String? batchId,
    int? lessonNo,
    String? uploaderUid,
    String? status,
    int? limit,
    int? offset,
    String? search,
    String? year,
  });

  Future<Either<Failure, void>> deleteResource(String id);

  Future<Either<Failure, Resource>> createResource(Resource resource);

  Future<Either<Failure, Resource>> updateResource(Resource resource);
}
