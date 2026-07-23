import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'network/api_client.dart';
import 'network/api_endpoints.dart';
import '../features/auth/data/datasources/auth_local_data_source.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/career/circular/data/repositories/circular_repository.dart';
import '../features/career/jobs/data/repositories/career_job_repository.dart';
import '../features/career/reminders/data/repositories/career_reminder_repository.dart';
import '../features/community/data/repositories/community_repository.dart';
import '../features/lost_found/data/repositories/lost_found_repository.dart';
import 'cache/cache_manager.dart';
import 'cache/connectivity_service.dart';
import 'websocket/websocket_service.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(secureStorageProvider);

  return ApiClient(
    baseUrl: ApiEndpoints.baseUrl,
    getToken: () async {
      return await storage.read(key: AuthLocalDataSourceImpl.cachedTokenKey);
    },
    onUnauthorized: () async {
      final refreshToken = await storage.read(
        key: AuthLocalDataSourceImpl.cachedRefreshTokenKey,
      );
      if (refreshToken == null || refreshToken.isEmpty) return false;
      try {
        final apiKey = dotenv.env['API_KEY'];
        final dio = Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            headers: {
              if (apiKey != null && apiKey.isNotEmpty) 'X-API-Key': apiKey,
              'Content-Type': 'application/json',
            },
          ),
        );
        final response = await dio.post(
          '/auth/refresh',
          data: {'refresh_token': refreshToken},
        );
        final newToken = response.data['access_token']?.toString();
        if (newToken == null || newToken.isEmpty) return false;
        await storage.write(
          key: AuthLocalDataSourceImpl.cachedTokenKey,
          value: newToken,
        );
        return true;
      } catch (_) {
        return false;
      }
    },
  );
});

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final cacheManager = ref.watch(cacheManagerProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  final wsService = ref.watch(websocketServiceProvider);

  return CommunityRepository(
    apiClient,
    cacheManager: cacheManager,
    connectivity: connectivity,
    webSocketService: wsService,
  );
});

final lostFoundRepositoryProvider = Provider<LostFoundRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return LostFoundRepository(apiClient);
});

final circularRepositoryProvider = Provider<CircularRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CircularRepository(apiClient);
});

final careerJobRepositoryProvider = Provider<CareerJobRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CareerJobRepository(apiClient);
});

final careerReminderRepositoryProvider = Provider<CareerReminderRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CareerReminderRepository(apiClient);
});

// Syllabus repository is provided via riverpod_generator in
// lib/features/syllabus/presentation/providers/syllabus_provider.dart

class CommunityRefreshNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void increment() => state++;
}

final communityRefreshProvider =
    NotifierProvider<CommunityRefreshNotifier, int>(
      CommunityRefreshNotifier.new,
    );
