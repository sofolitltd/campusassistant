import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';
import 'auth_local_data_source.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(
    String email,
    String password,
    String firstName,
    String lastName,
    String? phone,
    String? gender,
    String? universityId,
    String? departmentId,
  );
  Future<UserModel> getCurrentUser();
  Future<void> forgotPassword(String email);
  Future<String> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final AuthLocalDataSource localDataSource;

  AuthRemoteDataSourceImpl({
    required this.apiClient,
    required this.localDataSource,
  });

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await apiClient.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    // Cache access token
    if (response.data is Map && response.data['access_token'] != null) {
      await localDataSource.cacheToken(
        response.data['access_token'].toString(),
      );
    }
    // Cache refresh token
    if (response.data is Map && response.data['refresh_token'] != null) {
      await localDataSource.cacheRefreshToken(
        response.data['refresh_token'].toString(),
      );
    }

    final userData = (response.data is Map && response.data['user'] != null)
        ? response.data['user']
        : response.data;

    return UserModel.fromJson(userData);
  }

  @override
  Future<UserModel> register(
    String email,
    String password,
    String firstName,
    String lastName,
    String? phone,
    String? gender,
    String? universityId,
    String? departmentId,
  ) async {
    final data = <String, dynamic>{
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
    };

    // Add optional fields if provided
    if (phone != null && phone.isNotEmpty) {
      data['phone'] = phone;
    }
    if (gender != null && gender.isNotEmpty) {
      data['gender'] = gender;
    }
    if (universityId != null && universityId.isNotEmpty) {
      data['university_id'] = universityId;
    }
    if (departmentId != null && departmentId.isNotEmpty) {
      data['department_id'] = departmentId;
    }

    final response = await apiClient.post('/auth/register', data: data);

    // Cache access token
    if (response.data is Map && response.data['access_token'] != null) {
      await localDataSource.cacheToken(
        response.data['access_token'].toString(),
      );
    }
    // Cache refresh token
    if (response.data is Map && response.data['refresh_token'] != null) {
      await localDataSource.cacheRefreshToken(
        response.data['refresh_token'].toString(),
      );
    }

    final userData = (response.data is Map && response.data['user'] != null)
        ? response.data['user']
        : response.data;

    return UserModel.fromJson(userData);
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await apiClient.get('/auth/me'); // Or /users/me
    return UserModel.fromJson(response.data);
  }

  @override
  Future<void> forgotPassword(String email) async {
    // Backend implementation pending
    return;
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    final response = await apiClient.post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );
    final newAccessToken = response.data['access_token']?.toString();
    if (newAccessToken == null || newAccessToken.isEmpty) {
      throw Exception('Failed to refresh token');
    }
    await localDataSource.cacheToken(newAccessToken);
    return newAccessToken;
  }
}
