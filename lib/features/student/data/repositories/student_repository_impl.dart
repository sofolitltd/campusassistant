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
      limit: limit,
      offset: offset,
    );

    // 1. Try remote if online
    if (connectivity.isConnected) {
      try {
        final queryParams = <String, dynamic>{};
        if (universityId != null) queryParams['university_id'] = universityId;
        if (departmentId != null) queryParams['department_id'] = departmentId;
        if (batchId != null) queryParams['batch_id'] = batchId;
        if (userId != null) queryParams['user_id'] = userId;
        if (search != null) queryParams['search'] = search;
        if (bloodGroup != null) queryParams['blood_group'] = bloodGroup;
        if (limit != null) queryParams['limit'] = limit.toString();
        if (offset != null) queryParams['offset'] = offset.toString();
        queryParams['preload'] = 'true';

        final response = await apiClient.get(
          ApiEndpoints.students,
          queryParameters: queryParams,
        );

        final Map<String, dynamic> body = response.data;
        final List<dynamic> data = body['data'] ?? [];
        final int total = body['count'] ?? data.length;

        // Cache the result
        final cacheItems = data.cast<Map<String, dynamic>>();
        await cacheManager.cacheList(
          entityType: 'student_$cacheKey',
          items: cacheItems,
          ttl: CacheTTL.student,
        );

        return PaginatedStudents(
          students: data.map((json) => StudentModel.fromJson(json).toEntity()).toList(),
          total: total,
        );
      } catch (e) {
        debugPrint('[StudentRepo] Remote fetch failed: $e');
      }
    }

    // 2. Try cached data
    try {
      final cachedData = await cacheManager.getCachedList(
        entityType: 'student_$cacheKey',
      );

      if (cachedData.isNotEmpty) {
        final students = cachedData
            .map((json) => StudentModel.fromJson(json).toEntity())
            .toList();
        debugPrint('[StudentRepo] Returning ${students.length} cached students');
        return PaginatedStudents(students: students, total: students.length);
      }
    } catch (e) {
      debugPrint('[StudentRepo] Cache read failed: $e');
    }

    // 3. No data
    if (!connectivity.isConnected) {
      return PaginatedStudents(students: [], total: 0);
    }

    throw Exception('Failed to fetch students');
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
    return StudentModel.fromJson(response.data).toEntity();
  }

  @override
  Future<void> deleteStudent(String id) async {
    if (!connectivity.isConnected) {
      throw Exception('Internet connection required to delete student');
    }
    await apiClient.delete('${ApiEndpoints.students}/$id');
  }

  String _buildCacheKey({
    String? universityId,
    String? departmentId,
    String? batchId,
    String? userId,
    int? limit,
    int? offset,
  }) {
    final parts = <String>[
      if (universityId != null) 'uni_$universityId',
      if (departmentId != null) 'dept_$departmentId',
      if (batchId != null) 'batch_$batchId',
      if (userId != null) 'user_$userId',
      if (limit != null) 'lmt_$limit',
      if (offset != null) 'off_$offset',
    ];
    return parts.isEmpty ? 'global' : parts.join('_');
  }
}
