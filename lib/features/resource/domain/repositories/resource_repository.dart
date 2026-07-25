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

  /// Records that [id] was opened/viewed. Best-effort — callers should not
  /// block or fail their own flow if this fails.
  Future<void> recordView(String id);

  /// Records that [id] was downloaded. Best-effort — callers should not
  /// block or fail their own flow if this fails.
  Future<void> recordDownload(String id);

  /// Submits (or updates) the current user's 1-5 star rating for [id].
  /// Returns the resource's recomputed rating_avg/rating_count.
  Future<Either<Failure, ResourceRatingResult>> rateResource(
    String id,
    int rating,
  );
}

class ResourceRatingResult {
  final double ratingAvg;
  final int ratingCount;
  final int yourRating;
  ResourceRatingResult({
    required this.ratingAvg,
    required this.ratingCount,
    required this.yourRating,
  });
}
