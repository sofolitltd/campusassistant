import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/chapter.dart';
import '../../data/datasources/chapter_remote_data_source.dart';
import '../../data/repositories/chapter_repository_impl.dart';
import '../../domain/repositories/chapter_repository.dart';
import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/di.dart';

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
  final repository = ref.watch(chapterRepositoryProvider);
  final result = await repository.getChapters(
    courseCode,
    batchId: batchId,
  );
  return result.fold((failure) => throw failure, (chapters) => chapters);
}

@riverpod
ChapterActions chapterActions(Ref ref) {
  final repository = ref.watch(chapterRepositoryProvider);
  return ChapterActions(repository);
}

class ChapterActions {
  final ChapterRepository repository;
  ChapterActions(this.repository);

  Future<void> createChapter(Chapter chapter) => repository.createChapter(chapter);
  Future<void> updateChapter(Chapter chapter) => repository.updateChapter(chapter);
  Future<void> deleteChapter(String id) => repository.deleteChapter(id);
}
