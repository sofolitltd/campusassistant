import '../../../../core/network/api_client.dart';
import '../models/banner_model.dart';

abstract class BannerRemoteDataSource {
  Future<List<BannerModel>> getBanners({
    String? universityId,
    String? departmentId,
    String? mode,
  });
  Future<BannerModel> createBanner(BannerModel banner);
  Future<BannerModel> updateBanner(BannerModel banner);
  Future<void> deleteBanner(String id);
}

class BannerRemoteDataSourceImpl implements BannerRemoteDataSource {
  final ApiClient apiClient;

  BannerRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<BannerModel>> getBanners({
    String? universityId,
    String? departmentId,
    String? mode,
  }) async {
    final Map<String, dynamic> queryParameters = {'limit': 100};
    if (universityId != null) queryParameters['university_id'] = universityId;
    if (departmentId != null) queryParameters['department_id'] = departmentId;
    if (mode != null) queryParameters['mode'] = mode;

    final response = await apiClient.get(
      '/banners',
      queryParameters: queryParameters,
    );

    // The Go backend returns paginated response: {"count":N, "data":[...]}
    final Map<String, dynamic> body = response.data;
    final List<dynamic> data = body['data'] ?? [];
    return data.map((json) => BannerModel.fromJson(json)).toList();
  }

  @override
  Future<BannerModel> createBanner(BannerModel banner) async {
    final response = await apiClient.post('/banners', data: banner.toJson());
    return BannerModel.fromJson(response.data);
  }

  @override
  Future<BannerModel> updateBanner(BannerModel banner) async {
    final response = await apiClient.put(
      '/banners/${banner.id}',
      data: banner.toJson(),
    );
    return BannerModel.fromJson(response.data);
  }

  @override
  Future<void> deleteBanner(String id) async {
    await apiClient.delete('/banners/$id');
  }
}
