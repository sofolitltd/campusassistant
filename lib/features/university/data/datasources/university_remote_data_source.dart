import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/university_model.dart';
import '../models/hall_model.dart';

abstract class UniversityRemoteDataSource {
  Future<List<UniversityModel>> getUniversities();
  Future<UniversityModel> createUniversity(UniversityModel university);
  Future<UniversityModel> updateUniversity(UniversityModel university);
  Future<void> deleteUniversity(String id);
  Future<String> uploadLogo(String filePath, {String? folder});
  Future<String> uploadLogoBytes(
    List<int> bytes,
    String fileName, {
    String? folder,
  });
  Future<List<HallModel>> getHalls(String universityId);
  Future<HallModel> createHall(HallModel hall);
  Future<HallModel> updateHall(HallModel hall);
  Future<void> deleteHall(String id);
}

class UniversityRemoteDataSourceImpl implements UniversityRemoteDataSource {
  final ApiClient apiClient;

  UniversityRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<UniversityModel>> getUniversities() async {
    final response = await apiClient.get(ApiEndpoints.universities);

    // The Go backend returns paginated response: {"count":N, "data":[...], "limit":10, "offset":0}
    final Map<String, dynamic> body = response.data;
    final List<dynamic> data = body['data'] ?? [];
    return data.map((json) => UniversityModel.fromJson(json)).toList();
  }

  @override
  Future<UniversityModel> createUniversity(UniversityModel university) async {
    final response = await apiClient.post(
      ApiEndpoints.universities,
      data: university.toJson(),
    );

    return UniversityModel.fromJson(response.data);
  }

  @override
  Future<UniversityModel> updateUniversity(UniversityModel university) async {
    final response = await apiClient.put(
      '${ApiEndpoints.universities}/${university.id}',
      data: university.toJson(),
    );
    return UniversityModel.fromJson(response.data);
  }

  @override
  Future<void> deleteUniversity(String id) async {
    await apiClient.delete('${ApiEndpoints.universities}/$id');
  }

  @override
  Future<String> uploadLogo(String filePath, {String? folder}) async {
    final response = await apiClient.uploadFile(
      '/upload',
      filePath: filePath,
      fieldName: 'image',
      data: folder != null ? {'folder': folder} : null,
    );

    // The backend returns an attachment object with file_url
    return response.data['file_url'] as String;
  }

  @override
  Future<String> uploadLogoBytes(
    List<int> bytes,
    String fileName, {
    String? folder,
  }) async {
    final response = await apiClient.uploadBytes(
      '/upload',
      bytes: bytes,
      fileName: fileName,
      fieldName: 'image',
      data: folder != null ? {'folder': folder} : null,
    );
    return response.data['file_url'] as String;
  }

  @override
  Future<List<HallModel>> getHalls(String universityId) async {
    final response = await apiClient.get(
      ApiEndpoints.halls,
      queryParameters: {'university_id': universityId},
    );

    final Map<String, dynamic> body = response.data;
    final List<dynamic> data = body['data'] ?? [];
    return data.map((json) => HallModel.fromJson(json)).toList();
  }

  @override
  Future<HallModel> createHall(HallModel hall) async {
    final response = await apiClient.post(
      ApiEndpoints.halls,
      data: hall.toJson(),
    );
    return HallModel.fromJson(response.data);
  }

  @override
  Future<HallModel> updateHall(HallModel hall) async {
    final response = await apiClient.put(
      '${ApiEndpoints.halls}/${hall.id}',
      data: hall.toJson(),
    );
    return HallModel.fromJson(response.data);
  }

  @override
  Future<void> deleteHall(String id) async {
    await apiClient.delete('${ApiEndpoints.halls}/$id');
  }
}
