import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/student.dart';
import '../models/student_model.dart';
import '../../domain/repositories/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  final ApiClient apiClient;

  StudentRepositoryImpl({required this.apiClient});

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
    final queryParams = <String, dynamic>{};
    if (universityId != null) queryParams['university_id'] = universityId;
    if (departmentId != null) queryParams['department_id'] = departmentId;
    if (batchId != null) queryParams['batch_id'] = batchId;
    if (userId != null) queryParams['user_id'] = userId;
    if (search != null) queryParams['search'] = search;
    if (bloodGroup != null) queryParams['blood_group'] = bloodGroup;
    if (limit != null) queryParams['limit'] = limit.toString();
    if (offset != null) queryParams['offset'] = offset.toString();
    
    // Always preload relationships so we get names for University, Department, etc.
    queryParams['preload'] = 'true';

    final response = await apiClient.get(
      ApiEndpoints.students,
      queryParameters: queryParams,
    );

    final Map<String, dynamic> body = response.data;
    final List<dynamic> data = body['data'] ?? [];
    final int total = body['count'] ?? data.length;

    return PaginatedStudents(
      students: data.map((json) => StudentModel.fromJson(json).toEntity()).toList(),
      total: total,
    );
  }

  @override
  Future<Student?> getStudentByAcademicId(
    String studentId,
  ) async {
    final response = await apiClient.get(
      ApiEndpoints.students,
      queryParameters: {'student_id': studentId},
    );

    final Map<String, dynamic> body = response.data;
    final List<dynamic> data = body['data'] ?? [];
    if (data.isEmpty) return null;
    return StudentModel.fromJson(data.first).toEntity();
  }

  @override
  Future<Student> createStudent(Student student) async {
    final model = StudentModel.fromEntity(student);
    final response = await apiClient.post(
      ApiEndpoints.students,
      data: model.toJson(),
    );

    return StudentModel.fromJson(response.data).toEntity();
  }

  @override
  Future<Student> verifyCode(String code) async {
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
    final model = StudentModel.fromEntity(student);
    final response = await apiClient.put(
      '${ApiEndpoints.students}/${student.id}',
      data: model.toJson(),
    );

    return StudentModel.fromJson(response.data).toEntity();
  }

  @override
  Future<void> deleteStudent(String id) async {
    await apiClient.delete('${ApiEndpoints.students}/$id');
  }
}
