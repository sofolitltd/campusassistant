import '../../../../core/network/api_client.dart';
import '../models/staff_model.dart';

abstract class StaffRemoteDataSource {
  Future<List<StaffModel>> getStaff({
    required String universityId,
    required String departmentId,
  });

  Future<StaffModel> createStaff(StaffModel staff);
  Future<StaffModel> updateStaff(StaffModel staff);
  Future<void> deleteStaff(String id);
}

class StaffRemoteDataSourceImpl implements StaffRemoteDataSource {
  final ApiClient apiClient;

  StaffRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<StaffModel>> getStaff({
    required String universityId,
    required String departmentId,
  }) async {
    final response = await apiClient.get(
      '/staffs',
      queryParameters: {
        'university_id': universityId,
        'department_id': departmentId,
      },
    );

    final Map<String, dynamic> body = response.data;
    final List<dynamic> data = body['data'] ?? [];
    return data.map((json) => StaffModel.fromJson(json)).toList();
  }

  @override
  Future<StaffModel> createStaff(StaffModel staff) async {
    final response = await apiClient.post('/staffs', data: staff.toJson());
    return StaffModel.fromJson(response.data);
  }

  @override
  Future<StaffModel> updateStaff(StaffModel staff) async {
    final response = await apiClient.put(
      '/staffs/${staff.id}',
      data: staff.toJson(),
    );
    return StaffModel.fromJson(response.data);
  }

  @override
  Future<void> deleteStaff(String id) async {
    await apiClient.delete('/staffs/$id');
  }
}
