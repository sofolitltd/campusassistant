import '/core/network/api_client.dart';
import '../models/career_circular.dart';
import '../models/circular_category.dart';

class CircularRepository {
  final ApiClient apiClient;

  CircularRepository(this.apiClient);

  Future<List<CircularCategory>> getCategories() async {
    final response = await apiClient.get('/career-circular-categories');
    final data = response.data;
    final items = data is List
        ? data
        : (data as Map<String, dynamic>)['data'] as List? ?? [];
    return items
        .map((e) => CircularCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CareerCircular>> getCircularsByLocation({
    required String universityId,
    required String departmentId,
    String? categoryId,
    String? search,
  }) async {
    final response = await apiClient.get(
      '/career-circulars-by-location',
      queryParameters: {
        'university_id': universityId,
        'department_id': departmentId,
        if (categoryId != null && categoryId.isNotEmpty) 'category_id': categoryId,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    final data = response.data as Map<String, dynamic>;
    final items = data['data'] as List? ?? [];
    return items
        .map((e) => CareerCircular.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CareerCircular> getCircularById(String id) async {
    final response = await apiClient.get('/career-circulars/$id');
    return CareerCircular.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> recordView(String id) async {
    await apiClient.post('/career-circulars/$id/view');
  }

  /// "Save to My Jobs" — copies the circular into a job owned by the caller.
  Future<Map<String, dynamic>> saveToMyJobs(String circularId) async {
    final response = await apiClient.post('/my/career-jobs/from-circular/$circularId');
    return response.data as Map<String, dynamic>;
  }
}
