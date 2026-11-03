import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/chapter.dart';
import '../../data/datasources/chapter_remote_data_source.dart';
import '../../data/repositories/chapter_repository_impl.dart';
import '../../domain/repositories/chapter_repository.dart';
import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/di.dart';
import '../../../../core/providers/cache_for.dart';

part 'chapter_provider.g.dart';

@riverpod
ChapterRemoteDataSource chapterRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ChapterRemoteDataSourceImpl(apiClient: apiClient);
}

@riverpod
ChapterRepository chapterRepository(Ref ref) {
  final remoteDataSource = ref.watch(chapterRemoteDataSourceProvider);
  final cacheManager = ref.watch(cacheManagerProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  return ChapterRepositoryImpl(
    remoteDataSource: remoteDataSource,
    cacheManager: cacheManager,
    connectivity: connectivity,
  );
}

@riverpod
Future<List<Chapter>> chaptersForCourse(
  Ref ref, {
  required String universityId,
  required String departmentId,
  required String courseCode,
  String? batchId,
}) async {
  ref.cacheFor(kParamProviderCacheTime);
  final repository = ref.watch(chapterRepositoryProvider);
  // Fetch the whole course and pick the batch's chapters here, so a batch
  // with none of its own still gets a chapter list (see chaptersForBatch).
  final result = await repository.getChapters(
    courseCode,
    departmentId: departmentId,
  );
  return result.fold(
    (failure) => throw failure,
    (chapters) => chaptersForBatch(chapters, batchId),
  );
}

/// The batch's own chapters (tagged to it, or untagged = everyone's). A
/// batch with none yet — a new batch, or "All Batches" — gets every chapter
/// once per number instead of an empty list, so its notes stay reachable.
List<Chapter> chaptersForBatch(List<Chapter> chapters, String? batchId) {
  if (batchId != null && batchId != 'all_batches') {
    final own = chapters
        .where((c) => c.batches.isEmpty || c.batches.contains(batchId))
        .toList();
    if (own.isNotEmpty) return own;
  }
  final seen = <int>{};
  return chapters.where((c) => seen.add(c.chapterNo)).toList()
    ..sort((a, b) => a.chapterNo.compareTo(b.chapterNo));
}

@riverpod
ChapterActions chapterActions(Ref ref) {
  final repository = ref.watch(chapterRepositoryProvider);
  return ChapterActions(repository);
}

class ChapterActions {
  final ChapterRepository repository;
  ChapterActions(this.repository);

  Future<void> createChapter(Chapter chapter) =>
      repository.createChapter(chapter);
  Future<void> updateChapter(Chapter chapter) =>
      repository.updateChapter(chapter);
  Future<void> deleteChapter(String id) => repository.deleteChapter(id);
}
