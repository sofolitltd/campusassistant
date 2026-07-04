import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/resource.dart';
import '../../domain/repositories/resource_repository.dart';
import '../models/resource_model.dart';

class ResourceRepositoryImpl implements ResourceRepository {
  final ApiClient apiClient;

  ResourceRepositoryImpl({required this.apiClient});

  @override
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
  }) async {
    try {
      final queryParams = {
        'university_id': universityId,
        'department_id': departmentId,
      };
      if (type != null) queryParams['type'] = type;
      if (courseCode != null) queryParams['course_code'] = courseCode;
      if (batch != null) queryParams['batch'] = batch;
      if (batchId != null) queryParams['batch_id'] = batchId;
      if (lessonNo != null) queryParams['lesson_no'] = lessonNo.toString();
      if (uploaderUid != null) queryParams['uploader_uid'] = uploaderUid;
      if (status != null) queryParams['status'] = status;
      if (limit != null) queryParams['limit'] = limit.toString();
      if (offset != null) queryParams['offset'] = offset.toString();
      if (search != null) queryParams['search'] = search;
      if (year != null) queryParams['year'] = year;

      final response = await apiClient.get(
        '/resources',
        queryParameters: queryParams,
      );
      final List<dynamic> dataList = response.data['data'] ?? [];
      final int totalCount = response.data['count'] ?? 0;

      final resources = dataList
          .map((json) => ResourceModel.fromJson(json).toEntity())
          .toList();

      return Right(
        PaginatedResources(
          resources: resources,
          total: totalCount,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteResource(String id) async {
    try {
      await apiClient.delete('/resources/$id');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Resource>> createResource(Resource resource) async {
    try {
      final model = ResourceModel.fromEntity(resource);
      final response = await apiClient.post(
        '/resources',
        data: model.toJson(),
      );
      return Right(ResourceModel.fromJson(response.data).toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Resource>> updateResource(Resource resource) async {
    try {
      final model = ResourceModel.fromEntity(resource);
      final response = await apiClient.put(
        '/resources/${resource.id}',
        data: model.toJson(),
      );
      return Right(ResourceModel.fromJson(response.data).toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
