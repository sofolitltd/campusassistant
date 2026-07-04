import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/club_model.dart';

abstract class ClubRemoteDataSource {
  Future<List<ClubModel>> getClubs({
    required String universityId,
    String? departmentId,
    required String type,
  });
}

class ClubRemoteDataSourceImpl implements ClubRemoteDataSource {
  final ApiClient apiClient;

  ClubRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ClubModel>> getClubs({
    required String universityId,
    String? departmentId,
    required String type,
  }) async {
    final queryParameters = {'university_id': universityId, 'club_type': type};
    if (departmentId != null) {
      queryParameters['department_id'] = departmentId;
    }

    final response = await apiClient.get(
      ApiEndpoints.clubs,
      queryParameters: queryParameters,
    );

    final List<dynamic> data = response.data['data'];
    return data.map((json) => ClubModel.fromJson(json)).toList();
  }
}
