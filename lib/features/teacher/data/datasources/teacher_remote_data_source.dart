import '../../../../core/network/api_client.dart';
import '../models/teacher_model.dart';

abstract class TeacherRemoteDataSource {
  Future<List<TeacherModel>> getTeachers({
    required String universityId,
    required String departmentId,
    bool? isPresent,
  });

  Future<int> getTeacherCount({
    required String universityId,
    required String departmentId,
  });

  Future<TeacherModel> getTeacherById({
    required String universityId,
    required String departmentId,
    required String teacherId,
  });

  Future<TeacherModel> createTeacher(TeacherModel teacher);
  Future<TeacherModel> updateTeacher(TeacherModel teacher);
  Future<void> deleteTeacher(String teacherId);
}

class TeacherRemoteDataSourceImpl implements TeacherRemoteDataSource {
  final ApiClient apiClient;

  TeacherRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<TeacherModel>> getTeachers({
    required String universityId,
    required String departmentId,
    bool? isPresent,
  }) async {
    final queryParameters = {
      'university_id': universityId,
      'department_id': departmentId,
    };
    if (isPresent != null) {
      queryParameters['is_present'] = isPresent.toString();
    }

    final response = await apiClient.get(
      '/teachers',
      queryParameters: queryParameters,
    );

    // Support both direct list and paginated response
    final dynamic responseData = response.data;
    final List<dynamic> teacherList = (responseData is Map)
        ? (responseData['data'] as List<dynamic>? ?? [])
        : (responseData as List<dynamic>? ?? []);

    return teacherList.map((json) => TeacherModel.fromJsonData(json)).toList();
  }

  @override
  Future<int> getTeacherCount({
    required String universityId,
    required String departmentId,
  }) async {
    // Request a single row and read the paginated envelope's `count` field so
    // we never download the full teacher list just to show a total.
    final response = await apiClient.get(
      '/teachers',
      queryParameters: {
        'university_id': universityId,
        'department_id': departmentId,
        'limit': '1',
      },
    );

    final dynamic data = response.data;
    if (data is Map) {
      final count = data['count'];
      if (count is num) return count.toInt();
      return (data['data'] as List<dynamic>?)?.length ?? 0;
    }
    if (data is List) return data.length;
    return 0;
  }

  @override
  Future<TeacherModel> getTeacherById({
    required String universityId,
    required String departmentId,
    required String teacherId,
  }) async {
    final response = await apiClient.get(
      '/teachers/$teacherId',
      queryParameters: {
        'university_id': universityId,
        'department_id': departmentId,
      },
    );

    return TeacherModel.fromJsonData(response.data);
  }

  @override
  Future<TeacherModel> createTeacher(TeacherModel teacher) async {
    final response = await apiClient.post('/teachers', data: teacher.toJson());
    return TeacherModel.fromJsonData(response.data);
  }

  @override
  Future<TeacherModel> updateTeacher(TeacherModel teacher) async {
    final response = await apiClient.put(
      '/teachers/${teacher.id}',
      data: teacher.toJson(),
    );
    return TeacherModel.fromJsonData(response.data);
  }

  @override
  Future<void> deleteTeacher(String teacherId) async {
    await apiClient.delete('/teachers/$teacherId');
  }
}
