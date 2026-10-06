import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
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

  /// Exchanges a 6-digit code for a single-use reset token.
  Future<String> verifyResetCode(String email, String code);

  /// Consumes the reset token and sets the new password.
  Future<void> resetPassword(
    String email,
    String resetToken,
    String newPassword,
  );

  Future<Map<String, dynamic>> changePassword(
    String oldPassword,
    String newPassword, {
    bool logoutOtherDevices = true,
  });

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
    // Always succeeds server-side, whether or not the account exists — the
    // response is deliberately identical either way so the endpoint can't be
    // used to discover which emails are registered.
    await apiClient.post(
      ApiEndpoints.authForgotPassword,
      data: {'email': email, 'account_type': 'user'},
    );
  }

  @override
  Future<String> verifyResetCode(String email, String code) async {
    final response = await apiClient.post(
      ApiEndpoints.authVerifyResetCode,
      data: {'email': email, 'account_type': 'user', 'code': code},
    );

    final token = response.data is Map
        ? response.data['reset_token']?.toString()
        : null;
    if (token == null || token.isEmpty) {
      throw Exception('Invalid or expired code');
    }
    return token;
  }

  @override
  Future<void> resetPassword(
    String email,
    String resetToken,
    String newPassword,
  ) async {
    await apiClient.post(
      ApiEndpoints.authResetPassword,
      data: {
        'email': email,
        'account_type': 'user',
        'reset_token': resetToken,
        'new_password': newPassword,
      },
    );
  }

  @override
  Future<Map<String, dynamic>> changePassword(
    String oldPassword,
    String newPassword, {
    bool logoutOtherDevices = true,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.authChangePassword,
      data: {
        'old_password': oldPassword,
        'new_password': newPassword,
        'logout_other_devices': logoutOtherDevices,
      },
    );

    final data = response.data as Map<String, dynamic>;

    // Cache the new access and refresh tokens
    if (data['access_token'] != null) {
      await localDataSource.cacheToken(data['access_token'].toString());
    }
    if (data['refresh_token'] != null) {
      await localDataSource.cacheRefreshToken(data['refresh_token'].toString());
    }

    return data;
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
