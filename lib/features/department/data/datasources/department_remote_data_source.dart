import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/department_model.dart';

abstract class DepartmentRemoteDataSource {
  Future<List<DepartmentModel>> getDepartments({required String universityId});
  Future<DepartmentModel> createDepartment(DepartmentModel department);
  Future<DepartmentModel> updateDepartment(DepartmentModel department);
  Future<void> deleteDepartment(String id);
  Future<String> uploadLogo(String filePath);
}

class DepartmentRemoteDataSourceImpl implements DepartmentRemoteDataSource {
  final ApiClient apiClient;

  DepartmentRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<DepartmentModel>> getDepartments({
    required String universityId,
  }) async {
    final response = await apiClient.get(
      ApiEndpoints.departments,
      queryParameters: {'university_id': universityId},
    );

    // The Go backend returns paginated response: {"count":N, "data":[...], "limit":10, "offset":0}
    final Map<String, dynamic> body = response.data;
    final List<dynamic> data = body['data'] ?? [];
    return data.map((json) => DepartmentModel.fromJson(json)).toList();
  }

  @override
  Future<DepartmentModel> createDepartment(DepartmentModel department) async {
    final response = await apiClient.post(
      ApiEndpoints.departments,
      data: department.toJson(),
    );

    return DepartmentModel.fromJson(response.data);
  }

  @override
  Future<DepartmentModel> updateDepartment(DepartmentModel department) async {
    final response = await apiClient.put(
      '${ApiEndpoints.departments}/${department.id}',
      data: department.toJson(),
    );
    return DepartmentModel.fromJson(response.data);
  }

  @override
  Future<void> deleteDepartment(String id) async {
    await apiClient.delete('${ApiEndpoints.departments}/$id');
  }

  @override
  Future<String> uploadLogo(String filePath) async {
    final response = await apiClient.uploadFile(
      '/upload',
      filePath: filePath,
      fieldName: 'image',
    );

    return response.data['file_url'] as String;
  }
}
