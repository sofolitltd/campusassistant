import '../../../../core/network/api_client.dart';
import '../models/staff_model.dart';

abstract class StaffRemoteDataSource {
  Future<List<StaffModel>> getStaff({
    required String universityId,
    required String departmentId,
  });

  Future<int> getStaffCount({
    required String universityId,
    required String departmentId,
  });

  Future<StaffModel> getStaffById({
    required String universityId,
    required String departmentId,
    required String staffId,
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
  Future<int> getStaffCount({
    required String universityId,
    required String departmentId,
  }) async {
    // Request a single row and read the paginated envelope's `count` field so
    // we never download the full staff list just to show a total.
    final response = await apiClient.get(
      '/staffs',
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
  Future<StaffModel> getStaffById({
    required String universityId,
    required String departmentId,
    required String staffId,
  }) async {
    final response = await apiClient.get(
      '/staffs/$staffId',
      queryParameters: {
        'university_id': universityId,
        'department_id': departmentId,
      },
    );
    return StaffModel.fromJson(response.data);
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
