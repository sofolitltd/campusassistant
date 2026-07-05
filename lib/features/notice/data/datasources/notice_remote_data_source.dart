import '../../../../core/network/api_client.dart';
import '../models/notice_model.dart';

abstract class NoticeRemoteDataSource {
  Future<List<NoticeModel>> getNotices({
    required String universityId,
    required String departmentId,
  });
}

class NoticeRemoteDataSourceImpl implements NoticeRemoteDataSource {
  final ApiClient apiClient;

  NoticeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<NoticeModel>> getNotices({
    required String universityId,
    required String departmentId,
  }) async {
    final response = await apiClient.get(
      '/notices',
      queryParameters: {
        'university_id': universityId,
        'department_id': departmentId,
      },
    );

    final Map<String, dynamic> body = response.data;
    final List<dynamic> data = body['data'] ?? [];
    return data.map((json) => NoticeModel.fromJson(json)).toList();
  }
}
