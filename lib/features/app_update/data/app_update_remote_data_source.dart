import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import 'app_config_model.dart';

abstract class AppUpdateRemoteDataSource {
  Future<AppConfig> getAppConfig();
}

class AppUpdateRemoteDataSourceImpl implements AppUpdateRemoteDataSource {
  final ApiClient apiClient;

  AppUpdateRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AppConfig> getAppConfig() async {
    final response = await apiClient.get(ApiEndpoints.appConfig);
    return AppConfig.fromJson(response.data as Map<String, dynamic>);
  }
}
