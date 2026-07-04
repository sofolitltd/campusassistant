import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/batch_model.dart';

abstract class BatchRemoteDataSource {
  Future<List<BatchModel>> getBatches({required String departmentId});
  Future<BatchModel> createBatch(BatchModel batch);
  Future<BatchModel> updateBatch(BatchModel batch);
  Future<void> deleteBatch(String id);
}

class BatchRemoteDataSourceImpl implements BatchRemoteDataSource {
  final ApiClient apiClient;

  BatchRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<BatchModel>> getBatches({required String departmentId}) async {
    final response = await apiClient.get(
      ApiEndpoints.batches,
      queryParameters: {'department_id': departmentId},
    );

    final Map<String, dynamic> body = response.data;
    final List<dynamic> data = body['data'] ?? [];
    return data.map((json) => BatchModel.fromJson(json)).toList();
  }

  @override
  Future<BatchModel> createBatch(BatchModel batch) async {
    final response = await apiClient.post(
      ApiEndpoints.batches,
      data: batch.toJson(),
    );

    return BatchModel.fromJson(response.data);
  }

  @override
  Future<BatchModel> updateBatch(BatchModel batch) async {
    final response = await apiClient.put(
      '${ApiEndpoints.batches}/${batch.id}',
      data: batch.toJson(),
    );

    return BatchModel.fromJson(response.data);
  }

  @override
  Future<void> deleteBatch(String id) async {
    await apiClient.delete('${ApiEndpoints.batches}/$id');
  }
}
