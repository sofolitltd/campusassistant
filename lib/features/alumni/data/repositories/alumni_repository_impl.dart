import '../../../../core/network/api_client.dart';
import '../../domain/entities/alumni.dart';
import '../../domain/entities/alumni_organization.dart';
import '../../domain/repositories/alumni_repository.dart';
import '../models/alumni_model.dart';
import '../models/alumni_organization_model.dart';

class AlumniRepositoryImpl implements AlumniRepository {
  final ApiClient apiClient;

  AlumniRepositoryImpl({required this.apiClient});

  @override
  Future<PaginatedAlumni> getAlumni({
    String? universityId,
    String? departmentId,
    String? batch,
    String? search,
    String? organizationId,
    int? limit,
    int? offset,
  }) async {
    final Map<String, dynamic> params = {
      'preload': 'true',
    };
    if (universityId != null && universityId.isNotEmpty) {
      params['university_id'] = universityId;
    }
    if (departmentId != null && departmentId.isNotEmpty) {
      params['department_id'] = departmentId;
    }
    if (batch != null && batch.isNotEmpty) {
      params['batch'] = batch;
    }
    if (search != null && search.isNotEmpty) {
      params['search'] = search;
    }
    if (organizationId != null && organizationId.isNotEmpty) {
      params['organization_id'] = organizationId;
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
      '/alumni',
      queryParameters: params,
    );
    // API returns paginated envelope: {"data": [...], "count": N, ...}
    final envelope = response.data as Map<String, dynamic>;
    final List<dynamic> data = envelope['data'] ?? [];
    final int count = envelope['count'] ?? 0;
    final list = data
        .map((json) => AlumniModel.fromJson(json as Map<String, dynamic>).toEntity())
        .toList();
    return PaginatedAlumni(alumniList: list, total: count);
  }

  @override
  Future<Alumni> getAlumniById(String id) async {
    final response = await apiClient.get('/alumni/$id');
    return AlumniModel.fromJson(response.data as Map<String, dynamic>).toEntity();
  }

  @override
  Future<void> createAlumni(Alumni alumni) async {
    final model = AlumniModel.fromEntity(alumni);
    await apiClient.post('/alumni', data: model.toJson());
  }

  @override
  Future<List<AlumniOrganization>> getOrganizations({String? search}) async {
    final Map<String, dynamic> params = {};
    if (search != null && search.isNotEmpty) {
      params['search'] = search;
    }
    final response = await apiClient.get(
      '/organizations',
      queryParameters: params,
    );
    final envelope = response.data as Map<String, dynamic>;
    final List<dynamic> data = envelope['data'] ?? [];
    return data
        .map((json) => AlumniOrganizationModel.fromJson(json as Map<String, dynamic>).toEntity())
        .toList();
  }
}
