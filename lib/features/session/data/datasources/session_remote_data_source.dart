import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/session_model.dart';

abstract class SessionRemoteDataSource {
  Future<List<SessionModel>> getSessions({required String universityId});
  Future<SessionModel> createSession(SessionModel session);
  Future<SessionModel> updateSession(SessionModel session);
  Future<void> deleteSession(String id);
}

class SessionRemoteDataSourceImpl implements SessionRemoteDataSource {
  final ApiClient apiClient;

  SessionRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<SessionModel>> getSessions({required String universityId}) async {
    final response = await apiClient.get(
      ApiEndpoints.sessions,
      queryParameters: {'university_id': universityId},
    );

    final Map<String, dynamic> body = response.data;
    final List<dynamic> data = body['data'] ?? [];
    return data.map((json) => SessionModel.fromJson(json)).toList();
  }

  @override
  Future<SessionModel> createSession(SessionModel session) async {
    final response = await apiClient.post(
      ApiEndpoints.sessions,
      data: session.toJson(),
    );

    return SessionModel.fromJson(response.data);
  }

  @override
  Future<SessionModel> updateSession(SessionModel session) async {
    final response = await apiClient.put(
      '${ApiEndpoints.sessions}/${session.id}',
      data: session.toJson(),
    );

    return SessionModel.fromJson(response.data);
  }

  @override
  Future<void> deleteSession(String id) async {
    await apiClient.delete('${ApiEndpoints.sessions}/$id');
  }
}
