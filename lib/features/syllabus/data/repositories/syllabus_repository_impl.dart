import '../../../../core/network/api_client.dart';
import '../../domain/repositories/syllabus_repository.dart';
import '../models/syllabus_model.dart';

class SyllabusRepositoryImpl implements SyllabusRepository {
  final ApiClient apiClient;

  SyllabusRepositoryImpl({required this.apiClient});

  @override
  Future<PaginatedSyllabi> getSyllabi({
    required String universityId,
    required String departmentId,
    String? search,
    int? limit,
    int? offset,
  }) async {
    final Map<String, dynamic> params = {
      'type': 'syllabus',
      'university_id': universityId,
      'department_id': departmentId,
    };
    if (search != null && search.isNotEmpty) {
      params['search'] = search;
    }
    if (limit != null) {
      params['limit'] = limit;
    } else {
      params['limit'] = 20;
    }
    if (offset != null) {
      params['offset'] = offset;
    }

    final response = await apiClient.get(
      '/resources',
      queryParameters: params,
    );
    final envelope = response.data as Map<String, dynamic>;
    final List<dynamic> data = envelope['data'] ?? [];
    final int count = envelope['count'] ?? 0;
    final list = data
        .map((json) =>
            SyllabusModel.fromJson(json as Map<String, dynamic>).toEntity())
        .toList();
    return PaginatedSyllabi(syllabi: list, total: count);
  }
}
