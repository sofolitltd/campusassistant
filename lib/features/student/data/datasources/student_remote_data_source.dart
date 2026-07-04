import '../../../../core/network/api_client.dart';
import '../models/student_model.dart';

abstract class StudentRemoteDataSource {
  Future<List<StudentModel>> getStudents({
    required String universityId,
    required String departmentId,
    required String batch,
  });
}

class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  final ApiClient apiClient;

  StudentRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<StudentModel>> getStudents({
    required String universityId,
    required String departmentId,
    required String batch,
  }) async {
    final response = await apiClient.get(
      '/students',
      queryParameters: {
        'university_id': universityId,
        'department_id': departmentId,
        'batch': batch,
      },
    );

    final List<dynamic> data = response.data;
    return data.map((json) => StudentModel.fromJson(json)).toList();
  }
}
