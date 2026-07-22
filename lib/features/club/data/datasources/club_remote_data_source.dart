import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/club_model.dart';

abstract class ClubRemoteDataSource {
  Future<List<ClubModel>> getClubs({
    required String universityId,
    String? departmentId,
    required String type,
  });
  Future<void> followClub(String clubId);
  Future<void> unfollowClub(String clubId);
  Future<void> joinClub(String clubId);
  Future<void> leaveClub(String clubId);
  Future<ClubModel> suggestClub(ClubModel club);
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

    // /clubs-by-location is always-active-only and returns a raw array,
    // unlike the admin-facing /clubs endpoint which wraps in {"data": [...]}
    // and includes pending/inactive clubs.
    final response = await apiClient.get(
      ApiEndpoints.clubsByLocation,
      queryParameters: queryParameters,
    );

    final List<dynamic> data = response.data;
    return data.map((json) => ClubModel.fromJson(json)).toList();
  }

  @override
  Future<void> followClub(String clubId) async {
    await apiClient.post('${ApiEndpoints.clubs}/$clubId/follow');
  }

  @override
  Future<void> unfollowClub(String clubId) async {
    await apiClient.delete('${ApiEndpoints.clubs}/$clubId/follow');
  }

  @override
  Future<void> joinClub(String clubId) async {
    await apiClient.post('${ApiEndpoints.clubs}/$clubId/join');
  }

  @override
  Future<void> leaveClub(String clubId) async {
    await apiClient.delete('${ApiEndpoints.clubs}/$clubId/join');
  }

  @override
  Future<ClubModel> suggestClub(ClubModel club) async {
    final response = await apiClient.post(
      '${ApiEndpoints.clubs}/suggest',
      data: club.toJson(),
    );
    return ClubModel.fromJson(response.data);
  }
}
