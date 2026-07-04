import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  return BannerRepositoryImpl(remoteDataSource: remoteDataSource);
});

// UseCase
final getBannersProvider = Provider<GetBanners>((ref) {
  final repository = ref.watch(bannerRepositoryProvider);
  return GetBanners(repository);
});

// Presentation Providers
final bannersListProvider = FutureProvider<List<Banner>>((ref) async {
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
  );

  return result.fold((failure) => throw failure, (banners) => banners);
});

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
