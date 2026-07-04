import '../../../../core/network/api_client.dart';
import '../models/transport_model.dart';

abstract class TransportRemoteDataSource {
  Future<List<TransportModel>> getTransports({required String universityId});
}

class TransportRemoteDataSourceImpl implements TransportRemoteDataSource {
  final ApiClient apiClient;

  TransportRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<TransportModel>> getTransports({
    required String universityId,
  }) async {
    final response = await apiClient.get(
      '/transports',
      queryParameters: {'university_id': universityId},
    );

    final Map<String, dynamic> body = response.data;
    final List<dynamic> data = body['data'] ?? [];
    return data.map((json) => TransportModel.fromJson(json)).toList();
  }
}
