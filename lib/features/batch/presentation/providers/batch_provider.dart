import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/di.dart';
import '../../../../core/providers/app_refresh_provider.dart';
import '../../data/datasources/batch_remote_data_source.dart';
import '../../data/repositories/batch_repository_impl.dart';
import '../../domain/entities/batch.dart';
import '../../domain/repositories/batch_repository.dart';
import '../../domain/usecases/create_batch.dart';

part 'batch_provider.g.dart';

@Riverpod(keepAlive: true)
BatchRemoteDataSource batchRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BatchRemoteDataSourceImpl(apiClient: apiClient);
}

@Riverpod(keepAlive: true)
BatchRepository batchRepository(Ref ref) {
  final remoteDataSource = ref.watch(batchRemoteDataSourceProvider);
  final cacheManager = ref.watch(cacheManagerProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  return BatchRepositoryImpl(
    remoteDataSource: remoteDataSource,
    cacheManager: cacheManager,
    connectivity: connectivity,
  );
}

@Riverpod(keepAlive: true)
CreateBatch createBatch(Ref ref) {
  final repository = ref.watch(batchRepositoryProvider);
  return CreateBatch(repository);
}

@riverpod
Future<List<Batch>> batchesByDepartment(Ref ref, String departmentId) async {
  ref.watch(appRefreshProvider);
  final repository = ref.watch(batchRepositoryProvider);
  final result = await repository.getBatches(departmentId: departmentId);
  return result.fold((failure) => throw failure, (batches) => batches);
}

@riverpod
Future<Batch?> batchById(
  Ref ref, {
  required String departmentId,
  required String id,
}) async {
  final batches = await ref.watch(
    batchesByDepartmentProvider(departmentId).future,
  );
  try {
    return batches.firstWhere((b) => b.id == id);
  } catch (_) {
    return null;
  }
}

@riverpod
String batchName(Ref ref, {required String departmentId, required String id}) {
  final batchAsync = ref.watch(
    batchByIdProvider(departmentId: departmentId, id: id),
  );
  return batchAsync.when(
    data: (b) => b?.name ?? id,
    loading: () => '...',
    error: (_, _) => id,
  );
}
