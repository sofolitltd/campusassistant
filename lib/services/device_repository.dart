import '/core/network/api_client.dart';
import '/core/network/api_endpoints.dart';

class Device {
  final String id;
  final String platform;
  final DateTime lastSeenAt;
  final bool isCurrent;

  Device({
    required this.id,
    required this.platform,
    required this.lastSeenAt,
    required this.isCurrent,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as String,
      platform: json['platform'] as String,
      lastSeenAt: DateTime.parse(json['last_seen_at'] as String),
      isCurrent: json['is_current'] as bool? ?? false,
    );
  }
}

/// Registers/unregisters this app install's FCM token with the backend, and
/// manages the user's full list of logged-in devices/sessions.
class DeviceRepository {
  final ApiClient apiClient;

  DeviceRepository({required this.apiClient});

  Future<void> registerDevice(String fcmToken, String platform) async {
    await apiClient.post(
      ApiEndpoints.devices,
      data: {'fcm_token': fcmToken, 'platform': platform},
    );
  }

  Future<void> unregisterDevice(String fcmToken) async {
    await apiClient.post(
      ApiEndpoints.devicesUnregister,
      data: {'fcm_token': fcmToken},
    );
  }

  Future<List<Device>> listDevices({String? currentFcmToken}) async {
    final response = await apiClient.get(
      ApiEndpoints.devices,
      queryParameters: currentFcmToken != null
          ? {'current_fcm_token': currentFcmToken}
          : null,
    );
    final data = response.data as List;
    return data.map((e) => Device.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> removeDevice(String id) async {
    await apiClient.delete(ApiEndpoints.deviceDetail(id));
  }

  /// Bumps the account's TokenVersion (invalidating every issued access
  /// token, including this one) and clears every device row.
  Future<void> logoutAll() async {
    await apiClient.post(ApiEndpoints.devicesLogoutAll);
  }

  /// Bumps TokenVersion but returns a fresh access token for the caller, so
  /// every other device is signed out while this one stays logged in.
  Future<String> logoutOthers({String? currentFcmToken}) async {
    final response = await apiClient.post(
      ApiEndpoints.devicesLogoutOthers,
      data: currentFcmToken != null
          ? {'current_fcm_token': currentFcmToken}
          : null,
    );
    return response.data['access_token'] as String;
  }
}
