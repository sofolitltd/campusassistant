import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth/token_store.dart';
import 'network/api_client.dart';
import 'network/api_endpoints.dart';
import '../features/career/circular/data/repositories/circular_repository.dart';
import '../features/career/jobs/data/repositories/career_job_repository.dart';
import '../features/career/reminders/data/repositories/career_reminder_repository.dart';
import '../features/community/data/repositories/community_repository.dart';
import '../features/lost_found/data/repositories/lost_found_repository.dart';
import '../features/search/data/repositories/search_repository.dart';
import 'cache/cache_manager.dart';
import 'cache/connectivity_service.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final tokens = TokenStore.instance;

  return ApiClient(
    baseUrl: ApiEndpoints.baseUrl,
    getToken: tokens.getAccessToken,
    onUnauthorized: () async {
      final refreshToken = await tokens.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) return false;
      try {
        final dio = Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            headers: {'Content-Type': 'application/json'},
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
          ),
        );
        final response = await dio.post(
          '/auth/refresh',
          data: {'refresh_token': refreshToken},
        );
        final newToken = response.data['access_token']?.toString();
        if (newToken == null || newToken.isEmpty) return false;
        await tokens.setAccessToken(newToken);
        // The server may rotate the refresh token; keeping the old one would
        // fail the next refresh and log the user out.
        final newRefresh = response.data['refresh_token']?.toString();
        if (newRefresh != null && newRefresh.isNotEmpty) {
          await tokens.setRefreshToken(newRefresh);
        }
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
  return CommunityRepository(
    apiClient,
    cacheManager: cacheManager,
    connectivity: connectivity,
  );
});

final lostFoundRepositoryProvider = Provider<LostFoundRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return LostFoundRepository(apiClient);
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SearchRepository(apiClient);
});

final circularRepositoryProvider = Provider<CircularRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CircularRepository(apiClient);
});

final careerJobRepositoryProvider = Provider<CareerJobRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CareerJobRepository(apiClient);
});

final careerReminderRepositoryProvider = Provider<CareerReminderRepository>((
  ref,
) {
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
