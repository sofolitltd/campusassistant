import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/di.dart';
import '../../data/datasources/notice_remote_data_source.dart';
import '../../data/repositories/notice_repository_impl.dart';
import '../../domain/repositories/notice_repository.dart';
import '../../data/models/notice_model.dart';
import '../../../university/presentation/providers/university_provider.dart';
import '../../../department/presentation/providers/department_provider.dart';

part 'notice_provider.g.dart';

@Riverpod(keepAlive: true)
NoticeRemoteDataSource noticeRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NoticeRemoteDataSourceImpl(apiClient: apiClient);
}

@Riverpod(keepAlive: true)
NoticeRepository noticeRepository(Ref ref) {
  final remoteDataSource = ref.watch(noticeRemoteDataSourceProvider);
  final cacheManager = ref.watch(cacheManagerProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  return NoticeRepositoryImpl(
    remoteDataSource: remoteDataSource,
    cacheManager: cacheManager,
    connectivity: connectivity,
  );
}

@riverpod
Future<List<NoticeModel>> departmentNotices(Ref ref) async {
  final university = await ref.watch(myUniversityProvider.future);
  final department = await ref.watch(myDepartmentProvider.future);

  if (university.id.isEmpty || department.id.isEmpty) {
    return [];
  }

  final repository = ref.watch(noticeRepositoryProvider);
  final result = await repository.getNotices(
    universityId: university.id,
    departmentId: department.id,
  );

  return result;
}
