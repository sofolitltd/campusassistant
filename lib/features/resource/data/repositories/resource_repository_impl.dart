import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/cache/sync_manager.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/resource.dart';
import '../../domain/repositories/resource_repository.dart';
import '../models/resource_model.dart';

class ResourceRepositoryImpl implements ResourceRepository {
  final ApiClient apiClient;
  final CacheManager cacheManager;
  final ConnectivityService connectivity;
  final SyncManager syncManager;

  final Map<String, PaginatedResources> _resourcesCache = {};

  ResourceRepositoryImpl({
    required this.apiClient,
    required this.cacheManager,
    required this.connectivity,
    required this.syncManager,
  });

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
    final cacheKey = _buildCacheKey(
      universityId: universityId,
      departmentId: departmentId,
      type: type,
      courseCode: courseCode,
      batch: batch,
      lessonNo: lessonNo,
      search: search,
      limit: limit,
      offset: offset,
      batchId: batchId,
      uploaderUid: uploaderUid,
      status: status,
      year: year,
    );

    // 0. In-memory cache (instant)
    if (_resourcesCache.containsKey(cacheKey)) {
      debugPrint('[ResourceRepo] Returning resources from in-memory cache');
      return Right(_resourcesCache[cacheKey]!);
    }

    // 1. Try DB cache
    try {
      final cachedData = await cacheManager.getCachedList(
        entityType: 'resource_$cacheKey',
      );

      if (cachedData.isNotEmpty) {
        final resources = <Resource>[];
        for (final json in cachedData) {
          try {
            resources.add(ResourceModel.fromJson(json).toEntity());
          } catch (e) {
            debugPrint('[ResourceRepo] Skipping cached item due to parse error: $e');
          }
        }

        int total = cachedData.length;
        final totalEntry = await cacheManager.getCachedSingle(
          entityType: 'resource_total_$cacheKey',
          entityKey: 'total',
        );
        if (totalEntry != null && totalEntry['total'] is int) {
          total = totalEntry['total'] as int;
        }

        debugPrint('[ResourceRepo] Returning ${resources.length} cached resources');
        final result = PaginatedResources(
          resources: resources,
          total: total,
        );
        _resourcesCache[cacheKey] = result;
        return Right(result);
      }
    } catch (e) {
      debugPrint('[ResourceRepo] Cache read failed: $e');
    }

    // 2. Try remote if online
    if (connectivity.isConnected) {
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

        final resources = <Resource>[];
        final cacheItems = <Map<String, dynamic>>[];
        for (final item in dataList) {
          try {
            final map = item as Map<String, dynamic>;
            resources.add(ResourceModel.fromJson(map).toEntity());
            cacheItems.add(map);
          } catch (e) {
            debugPrint('[ResourceRepo] Skipping item due to parse error: $e');
            debugPrint('[ResourceRepo] Item: $item');
          }
        }
        try {
          await cacheManager.cacheList(
            entityType: 'resource_$cacheKey',
            items: cacheItems,
            ttl: CacheTTL.resource,
          );
          await cacheManager.cacheSingle(
            entityType: 'resource_total_$cacheKey',
            entityKey: 'total',
            data: {'total': totalCount},
            ttl: CacheTTL.resource,
          );
        } catch (e) {
          debugPrint('[ResourceRepo] Cache write failed (non-fatal): $e');
        }

        final result = PaginatedResources(
          resources: resources,
          total: totalCount,
        );
        _resourcesCache[cacheKey] = result;
        return Right(result);
      } catch (e) {
        debugPrint('[ResourceRepo] Remote fetch failed: $e');
      }
    }

    // 3. No data
    if (!connectivity.isConnected) {
      return const Left(NetworkFailure(
        'No internet connection and no cached resources available',
      ));
    }

    return Left(ServerFailure('Failed to fetch resources'));
  }

  @override
  Future<Either<Failure, void>> deleteResource(String id) async {
    if (connectivity.isConnected) {
      try {
        await apiClient.delete('/resources/$id');
        return const Right(null);
      } catch (e) {
        debugPrint('[ResourceRepo] Remote delete failed: $e');
      }
    }

    return Left(NetworkFailure(
      'Delete operation requires internet connection',
    ));
  }

  @override
  Future<Either<Failure, Resource>> createResource(Resource resource) async {
    final model = ResourceModel.fromEntity(resource);

    if (connectivity.isConnected) {
      try {
        final response = await apiClient.post(
          '/resources',
          data: model.toJson(),
        );
        return Right(ResourceModel.fromJson(response.data).toEntity());
      } catch (e) {
        debugPrint('[ResourceRepo] Remote create failed: $e');
      }
    }

    await syncManager.enqueue(
      operation: 'CREATE',
      entityType: 'resource',
      entityKey: resource.id,
      payload: model.toJson(),
      endpoint: '/resources',
      method: 'POST',
    );

    return Left(NetworkFailure(
      'Resource creation queued for sync when connection is restored',
    ));
  }

  @override
  Future<Either<Failure, Resource>> updateResource(Resource resource) async {
    final model = ResourceModel.fromEntity(resource);

    if (connectivity.isConnected) {
      try {
        final response = await apiClient.put(
          '/resources/${resource.id}',
          data: model.toJson(),
        );
        return Right(ResourceModel.fromJson(response.data).toEntity());
      } catch (e) {
        debugPrint('[ResourceRepo] Remote update failed: $e');
      }
    }

    await syncManager.enqueue(
      operation: 'UPDATE',
      entityType: 'resource',
      entityKey: resource.id,
      payload: model.toJson(),
      endpoint: '/resources/${resource.id}',
      method: 'PUT',
    );

    return Left(NetworkFailure(
      'Resource update queued for sync when connection is restored',
    ));
  }

  String _buildCacheKey({
    required String universityId,
    required String departmentId,
    String? type,
    String? courseCode,
    String? batch,
    int? lessonNo,
    String? search,
    int? limit,
    int? offset,
    String? batchId,
    String? uploaderUid,
    String? status,
    String? year,
  }) {
    final parts = <String>[
      'uni_$universityId',
      'dept_$departmentId',
      if (type != null) 'type_$type',
      if (courseCode != null) 'course_$courseCode',
      if (batch != null) 'batch_$batch',
      if (lessonNo != null) 'lesson_$lessonNo',
      if (search != null && search.isNotEmpty) 'search_${search.hashCode}',
      if (limit != null) 'lim_$limit',
      if (offset != null) 'off_$offset',
      if (batchId != null) 'batchId_$batchId',
      if (uploaderUid != null) 'uploader_$uploaderUid',
      if (status != null) 'status_$status',
      if (year != null) 'year_$year',
    ];
    return parts.join('_');
  }
}
