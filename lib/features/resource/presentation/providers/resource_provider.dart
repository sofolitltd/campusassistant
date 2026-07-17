import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/cache/sync_manager.dart';
import '../../../../core/di.dart';
import '../../domain/entities/resource.dart';
import '../../domain/repositories/resource_repository.dart';
import '../../data/repositories/resource_repository_impl.dart';

part 'resource_provider.g.dart';

@Riverpod(keepAlive: true)
ResourceRepository resourceRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  final cacheManager = ref.watch(cacheManagerProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  final syncManager = ref.watch(syncManagerProvider);

  return ResourceRepositoryImpl(
    apiClient: apiClient,
    cacheManager: cacheManager,
    connectivity: connectivity,
    syncManager: syncManager,
  );
}

typedef ResourceParams = ({
  String universityId,
  String departmentId,
  String? type,
  String? courseCode,
  String? batch,
  String? batchId,
  int? lessonNo,
  String? uploaderUid,
  String? status,
  int? limit,
  int? offset,
});

@Riverpod(keepAlive: true)
Future<List<Resource>> resourcesList(
  Ref ref, {
  required String universityId,
  required String departmentId,
  String? type,
  String? courseCode,
  String? batch,
  String? batchId,
  int? lessonNo,
  String? uploaderUid,
  String? status,
  int? limit,
  int? offset,
}) async {
  final repo = ref.watch(resourceRepositoryProvider);
  final result = await repo.getResources(
    universityId: universityId,
    departmentId: departmentId,
    type: type,
    courseCode: courseCode,
    batch: batch,
    batchId: batchId,
    lessonNo: lessonNo,
    uploaderUid: uploaderUid,
    status: status,
    limit: limit,
    offset: offset,
  );
  return result.fold((failure) => throw failure, (p) => p.resources);
}

@riverpod
Future<Resource> Function(Resource) createResource(Ref ref) {
  final repo = ref.watch(resourceRepositoryProvider);
  return (Resource resource) => repo.createResource(resource).then((res) => res.fold((l) => throw l, (r) => r));
}

@riverpod
Future<Resource> Function(Resource) updateResource(Ref ref) {
  final repo = ref.watch(resourceRepositoryProvider);
  return (Resource resource) => repo.updateResource(resource).then((res) => res.fold((l) => throw l, (r) => r));
}
