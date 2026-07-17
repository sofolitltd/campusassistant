import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/cache/sync_manager.dart';
import '../../../../core/di.dart';
import '../../data/datasources/banner_remote_data_source.dart';
import '../../data/repositories/banner_repository_impl.dart';
import '../../domain/entities/banner.dart';
import '../../domain/repositories/banner_repository.dart';
import '../../domain/usecases/get_banners.dart';
import '../../../university/presentation/providers/university_provider.dart';
import '../../../department/presentation/providers/department_provider.dart';

// Datasource
final bannerRemoteDataSourceProvider = Provider<BannerRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BannerRemoteDataSourceImpl(apiClient: apiClient);
});

// Repository
final bannerRepositoryProvider = Provider<BannerRepository>((ref) {
  final remoteDataSource = ref.watch(bannerRemoteDataSourceProvider);
  final cacheManager = ref.watch(cacheManagerProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  final syncManager = ref.watch(syncManagerProvider);

  return BannerRepositoryImpl(
    remoteDataSource: remoteDataSource,
    cacheManager: cacheManager,
    connectivity: connectivity,
    syncManager: syncManager,
  );
});

// UseCase
final getBannersProvider = Provider<GetBanners>((ref) {
  final repository = ref.watch(bannerRepositoryProvider);
  return GetBanners(repository);
});

// Banner List Notifier — keeps last state so loading is not shown on rebuilds
class BannersListNotifier extends AsyncNotifier<List<Banner>> {
  @override
  Future<List<Banner>> build() async {
    String? uniId;
    String? deptId;

    // Try to get uni and dept for student targeting
    try {
      final university = await ref.watch(myUniversityProvider.future);
      uniId = university.id;
      final department = await ref.watch(myDepartmentProvider.future);
      deptId = department.id;
    } catch (_) {
      // If guest or no uni/dept, fetch global only
    }

    final getBanners = ref.watch(getBannersProvider);
    final result = await getBanners(
      GetBannersParams(universityId: uniId, departmentId: deptId),
    ).timeout(const Duration(seconds: 8));

    return result.fold((failure) => throw failure, (banners) => banners);
  }

  /// Manual refresh — silently updates data without showing loading
  Future<void> refresh() async {
    try {
      state = AsyncData(await build());
    } catch (e) {
      debugPrint('[BannersList] Refresh failed: $e');
    }
  }
}

// Presentation Providers
final bannersListProvider =
    AsyncNotifierProvider<BannersListNotifier, List<Banner>>(
  BannersListNotifier.new,
);

// Admin management providers
final createBannerProvider = Provider((ref) {
  final repository = ref.watch(bannerRepositoryProvider);
  return (Banner banner) => repository.createBanner(banner);
});

final updateBannerProvider = Provider((ref) {
  final repository = ref.watch(bannerRepositoryProvider);
  return (Banner banner) => repository.updateBanner(banner);
});

final deleteBannerProvider = Provider((ref) {
  final repository = ref.watch(bannerRepositoryProvider);
  return (String id) => repository.deleteBanner(id);
});

// Fetch all banners for admin list
final allBannersProvider = FutureProvider<List<Banner>>((ref) async {
  final repository = ref.watch(bannerRepositoryProvider);
  final result = await repository.getBanners(mode: 'admin');
  return result.fold((failure) => throw failure, (banners) => banners);
});
