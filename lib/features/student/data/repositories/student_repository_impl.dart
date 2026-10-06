import 'package:flutter/foundation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/student.dart';
import '../models/student_model.dart';
import '../../domain/repositories/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  final ApiClient apiClient;
  final CacheManager cacheManager;
  final ConnectivityService connectivity;

  StudentRepositoryImpl({
    required this.apiClient,
    required this.cacheManager,
    required this.connectivity,
  });

  // Each list page is one cache row ({total, items}) so the total survives a
  // cache hit and a page is replaced atomically. Kept short: a fresh hit skips
  // the network entirely, and every write below invalidates the whole type.
  static const _pageType = 'student_page';
  static const _pageTtl = Duration(minutes: 30);

  bool _isSearch(String? search) => search != null && search.isNotEmpty;

  Future<PaginatedStudents?> _readPage(String key) async {
    try {
      if (!await cacheManager.isFresh(entityType: _pageType, entityKey: key)) {
        return null;
      }
      final cached = await cacheManager.getCachedSingle(
        entityType: _pageType,
        entityKey: key,
      );
      if (cached == null) return null;
      final items = (cached['items'] as List).cast<Map<String, dynamic>>();
      return PaginatedStudents(
        students: items
            .map((json) => StudentModel.fromJson(json).toEntity())
            .toList(),
        total: cached['total'] as int? ?? items.length,
      );
    } catch (e) {
      debugPrint('[StudentRepo] Cache read failed: $e');
      return null;
    }
  }

  Future<PaginatedStudents> _fetchPage({
    String? universityId,
    String? departmentId,
    String? batchId,
    String? userId,
    String? search,
    String? bloodGroup,
    int? limit,
    int? offset,
    required String cacheKey,
  }) async {
    final queryParams = <String, dynamic>{};
    if (universityId != null) queryParams['university_id'] = universityId;
    if (departmentId != null) queryParams['department_id'] = departmentId;
    if (batchId != null) queryParams['batch_id'] = batchId;
    if (userId != null) queryParams['user_id'] = userId;
    if (_isSearch(search)) queryParams['search'] = search;
    if (bloodGroup != null) queryParams['blood_group'] = bloodGroup;
    if (limit != null) queryParams['limit'] = limit.toString();
    if (offset != null) queryParams['offset'] = offset.toString();
    // Count-only requests (limit=1) don't need the joined user/batch/hall.
    if (limit != 1) queryParams['preload'] = 'true';

    final response = await apiClient.get(
      ApiEndpoints.students,
      queryParameters: queryParams,
    );

    final Map<String, dynamic> body = response.data;
    final List<dynamic> data = body['data'] ?? [];
    final int total = body['count'] ?? data.length;

    // Every distinct search string would otherwise leave a row behind.
    if (!_isSearch(search)) {
      try {
        await cacheManager.cacheSingle(
          entityType: _pageType,
          entityKey: cacheKey,
          data: {'total': total, 'items': data},
          ttl: _pageTtl,
        );
      } catch (e) {
        debugPrint('[StudentRepo] Cache write failed: $e');
      }
    }

    return PaginatedStudents(
      students: data
          .map((json) => StudentModel.fromJson(json).toEntity())
          .toList(),
      total: total,
    );
  }

  @override
  Future<PaginatedStudents> getStudents({
    String? universityId,
    String? departmentId,
    String? batchId,
    String? userId,
    String? search,
    String? bloodGroup,
    int? limit,
    int? offset,
  }) async {
    final cacheKey = _buildCacheKey(
      universityId: universityId,
      departmentId: departmentId,
      batchId: batchId,
      userId: userId,
      search: search,
      bloodGroup: bloodGroup,
      limit: limit,
      offset: offset,
    );

    if (!_isSearch(search)) {
      final hit = await _readPage(cacheKey);
      if (hit != null) return hit;
    }

    if (connectivity.isConnected) {
      try {
        return await _fetchPage(
          universityId: universityId,
          departmentId: departmentId,
          batchId: batchId,
          userId: userId,
          search: search,
          bloodGroup: bloodGroup,
          limit: limit,
          offset: offset,
          cacheKey: cacheKey,
        );
      } catch (e) {
        debugPrint('[StudentRepo] Remote fetch failed: $e');
      }
    }

    if (!connectivity.isConnected) {
      return PaginatedStudents(students: [], total: 0);
    }
    throw Exception('Failed to fetch students');
  }

  @override
  Stream<PaginatedStudents> watchStudents({
    String? universityId,
    String? departmentId,
    String? batchId,
    String? userId,
    String? search,
    String? bloodGroup,
    int? limit,
    int? offset,
  }) async* {
    // A fresh cached page is served as-is; the network is only hit once it
    // has expired, was invalidated by a write, or for a search.
    yield await getStudents(
      universityId: universityId,
      departmentId: departmentId,
      batchId: batchId,
      userId: userId,
      search: search,
      bloodGroup: bloodGroup,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<Student?> getStudentByAcademicId(String studentId) async {
    // This is a specific lookup - try remote first, fall back to cache
    if (connectivity.isConnected) {
      try {
        final response = await apiClient.get(
          ApiEndpoints.students,
          queryParameters: {'student_id': studentId},
        );

        final Map<String, dynamic> body = response.data;
        final List<dynamic> data = body['data'] ?? [];
        if (data.isEmpty) return null;

        final student = StudentModel.fromJson(data.first).toEntity();

        // Cache this specific student
        await cacheManager.cacheSingle(
          entityType: 'student_detail',
          entityKey: studentId,
          data: data.first as Map<String, dynamic>,
          ttl: CacheTTL.student,
        );

        return student;
      } catch (e) {
        debugPrint('[StudentRepo] Remote fetch failed for academicId: $e');
      }
    }

    // Try cache
    try {
      final cached = await cacheManager.getCachedSingle(
        entityType: 'student_detail',
        entityKey: studentId,
      );
      if (cached != null) {
        return StudentModel.fromJson(cached).toEntity();
      }
    } catch (e) {
      debugPrint('[StudentRepo] Cache read failed for academicId: $e');
    }

    return null;
  }

  @override
  Future<Student> createStudent(Student student) async {
    if (!connectivity.isConnected) {
      throw Exception('Internet connection required to create student');
    }
    final model = StudentModel.fromEntity(student);
    final response = await apiClient.post(
      ApiEndpoints.students,
      data: model.toJson(),
    );
    await cacheManager.invalidate(_pageType);
    return StudentModel.fromJson(response.data).toEntity();
  }

  @override
  Future<Student> verifyCode(String code) async {
    if (!connectivity.isConnected) {
      throw Exception('Internet connection required to verify code');
    }
    final response = await apiClient.post(
      '${ApiEndpoints.students}/verify-code',
      data: {'code': code},
    );
    return StudentModel.fromJson(response.data).toEntity();
  }

  @override
  Future<Student> claimProfile({
    required String code,
    required String userId,
    String? studentId,
    String? phone,
    String? bloodGroup,
    String? hallId,
    String? batchId,
    String? sessionId,
    String? departmentId,
    String? universityId,
  }) async {
    if (!connectivity.isConnected) {
      throw Exception('Internet connection required to claim profile');
    }
    final data = <String, dynamic>{'code': code, 'user_id': userId};
    if (studentId != null) data['student_id'] = studentId;
    if (phone != null) data['phone'] = phone;
    if (bloodGroup != null) data['blood_group'] = bloodGroup;
    if (hallId != null) data['hall_id'] = hallId;
    if (batchId != null) data['batch_id'] = batchId;
    if (sessionId != null) data['session_id'] = sessionId;
    if (departmentId != null) data['department_id'] = departmentId;
    if (universityId != null) data['university_id'] = universityId;

    final response = await apiClient.post(
      '${ApiEndpoints.students}/claim-profile',
      data: data,
    );
    await cacheManager.invalidate(_pageType);
    return StudentModel.fromJson(response.data).toEntity();
  }

  @override
  Future<Student> updateStudent(Student student) async {
    if (!connectivity.isConnected) {
      throw Exception('Internet connection required to update student');
    }
    final model = StudentModel.fromEntity(student);
    final response = await apiClient.put(
      '${ApiEndpoints.students}/${student.id}',
      data: model.toJson(),
    );
    await cacheManager.invalidate(_pageType);
    return StudentModel.fromJson(response.data).toEntity();
  }

  @override
  Future<void> deleteStudent(String id) async {
    if (!connectivity.isConnected) {
      throw Exception('Internet connection required to delete student');
    }
    await apiClient.delete('${ApiEndpoints.students}/$id');
    await cacheManager.invalidate(_pageType);
  }

  String _buildCacheKey({
    String? universityId,
    String? departmentId,
    String? batchId,
    String? userId,
    String? search,
    String? bloodGroup,
    int? limit,
    int? offset,
  }) {
    final parts = <String>[
      if (universityId != null) 'uni_$universityId',
      if (departmentId != null) 'dept_$departmentId',
      if (batchId != null) 'batch_$batchId',
      if (userId != null) 'user_$userId',
      // Without this a search would be served the unfiltered cached page.
      if (search != null && search.isNotEmpty) 'q_$search',
      if (bloodGroup != null) 'blood_$bloodGroup',
      if (limit != null) 'lmt_$limit',
      if (offset != null) 'off_$offset',
    ];
    return parts.isEmpty ? 'global' : parts.join('_');
  }
}
