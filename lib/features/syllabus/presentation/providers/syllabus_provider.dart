import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/di.dart';
import '../../../auth/presentation/providers/user_profile_provider.dart';
import '../../../resource/domain/entities/resource.dart';
import '../../../resource/presentation/providers/resource_provider.dart';
import '../../domain/repositories/syllabus_repository.dart';
import '../../data/repositories/syllabus_repository_impl.dart';

part 'syllabus_provider.g.dart';

@riverpod
SyllabusRepository syllabusRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  final cacheManager = ref.watch(cacheManagerProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  return SyllabusRepositoryImpl(
    apiClient: apiClient,
    cacheManager: cacheManager,
    connectivity: connectivity,
  );
}

@riverpod
class SyllabusSearchQuery extends _$SyllabusSearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

class SyllabusState {
  final List<Resource> syllabi;
  final int total;
  final bool isLoadingMore;
  final bool hasMore;

  SyllabusState({
    required this.syllabi,
    required this.total,
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  SyllabusState copyWith({
    List<Resource>? syllabi,
    int? total,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return SyllabusState(
      syllabi: syllabi ?? this.syllabi,
      total: total ?? this.total,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

@riverpod
class SyllabusPagination extends _$SyllabusPagination {
  static const int _limit = 20;

  @override
  Future<SyllabusState> build() async {
    final search = ref.watch(syllabusSearchQueryProvider);
    final profile = await ref.watch(userProvider.future);

    // Loaded as plain resources so the page can use the shared ResourceCard.
    final repo = ref.watch(resourceRepositoryProvider);
    final result = await repo.getResources(
      universityId: profile.information.universityId ?? '',
      departmentId: profile.information.departmentId ?? '',
      type: 'syllabus',
      status: 'published',
      search: search.isEmpty ? null : search,
      limit: _limit,
      offset: 0,
    );

    return result.fold(
      (failure) => throw failure,
      (paginated) => SyllabusState(
        syllabi: paginated.resources,
        total: paginated.total,
        hasMore: paginated.resources.length < paginated.total,
      ),
    );
  }

  Future<void> loadMore() async {
    final currentState = state.asData?.value;
    if (currentState == null ||
        currentState.isLoadingMore ||
        !currentState.hasMore) {
      return;
    }

    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    final search = ref.read(syllabusSearchQueryProvider);
    final profile = ref.read(userProvider).asData?.value;
    if (profile == null) return;

    final repo = ref.read(resourceRepositoryProvider);
    final result = await repo.getResources(
      universityId: profile.information.universityId ?? '',
      departmentId: profile.information.departmentId ?? '',
      type: 'syllabus',
      status: 'published',
      search: search.isEmpty ? null : search,
      limit: _limit,
      offset: currentState.syllabi.length,
    );
    result.fold(
      (_) =>
          state = AsyncValue.data(currentState.copyWith(isLoadingMore: false)),
      (paginated) {
        final newSyllabi = [...currentState.syllabi, ...paginated.resources];
        state = AsyncValue.data(
          currentState.copyWith(
            syllabi: newSyllabi,
            isLoadingMore: false,
            hasMore: newSyllabi.length < paginated.total,
          ),
        );
      },
    );
  }
}
