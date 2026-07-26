import '/core/network/api_client.dart';
import '../models/search_result.dart';

/// Talks to the unified global search endpoint (`GET /search`), which fans
/// out to resources/notices/courses/clubs/associations/teachers/staff/
/// marketplace/lost & found/career in a single round trip.
class SearchRepository {
  final ApiClient apiClient;

  SearchRepository(this.apiClient);

  Future<SearchResults> search({
    required String query,
    List<String>? types,
    String? universityId,
    String? departmentId,
    int? limitPerType,
  }) async {
    final response = await apiClient.get(
      '/search',
      queryParameters: {
        'q': query,
        if (types != null && types.isNotEmpty) 'types': types.join(','),
        if (universityId != null && universityId.isNotEmpty)
          'university_id': universityId,
        if (departmentId != null && departmentId.isNotEmpty)
          'department_id': departmentId,
        'limit_per_type': ?limitPerType,
      },
    );
    final data = response.data as Map<String, dynamic>;
    return SearchResults.fromJson(data['data'] as Map<String, dynamic>);
  }
}
