import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/content_model.dart';
import '/features/resource/presentation/providers/resource_provider.dart';
import '/features/resource/domain/entities/resource.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';

class QuestionsState {
  final List<ContentModel> docs;
  final int totalCount;
  final bool isLoadingMore;
  final bool hasMore;

  QuestionsState({
    required this.docs,
    required this.totalCount,
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  QuestionsState copyWith({
    List<ContentModel>? docs,
    int? totalCount,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return QuestionsState(
      docs: docs ?? this.docs,
      totalCount: totalCount ?? this.totalCount,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

// Reactive status for Search, Scope and Year
final questionsSearchQueryProvider =
    NotifierProvider<QuestionsSearchNotifier, String>(
      QuestionsSearchNotifier.new,
    );

class QuestionsSearchNotifier extends Notifier<String> {
  @override
  String build() => "";
  @override
  set state(String value) => super.state = value;
}

final questionsScopeUniversityProvider =
    NotifierProvider<QuestionsScopeNotifier, bool>(QuestionsScopeNotifier.new);

class QuestionsScopeNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  @override
  set state(bool value) => super.state = value;
}

final questionsSelectedYearProvider =
    NotifierProvider<QuestionsYearNotifier, String?>(QuestionsYearNotifier.new);

class QuestionsYearNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  @override
  set state(String? value) => super.state = value;
}

final questionsSelectedCourseProvider =
    NotifierProvider<QuestionsCourseNotifier, String?>(
      QuestionsCourseNotifier.new,
    );

class QuestionsCourseNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  @override
  set state(String? value) => super.state = value;
}

// Fixed list of years for now (Enterprise should ideally fetch this)
final questionYearsProvider = Provider<List<String>>((ref) {
  return List.generate(12, (index) => (2026 - index).toString());
});

final questionsPaginationProvider =
    AsyncNotifierProvider<QuestionsPaginationNotifier, QuestionsState>(
      QuestionsPaginationNotifier.new,
    );

class QuestionsPaginationNotifier extends AsyncNotifier<QuestionsState> {
  static const int _limit = 20;

  @override
  Future<QuestionsState> build() async {
    final search = ref.watch(questionsSearchQueryProvider);
    final isUni = ref.watch(questionsScopeUniversityProvider);
    final year = ref.watch(questionsSelectedYearProvider);
    final courseCode = ref.watch(questionsSelectedCourseProvider);

    return _fetchPage(
      offset: 0,
      search: search,
      isUni: isUni,
      year: year,
      courseCode: courseCode,
    );
  }

  Future<QuestionsState> _fetchPage({
    required int offset,
    required String search,
    required bool isUni,
    String? year,
    String? courseCode,
  }) async {
    final user = ref.read(userProvider).value;
    if (user == null) return QuestionsState(docs: [], totalCount: 0);

    final repo = ref.read(resourceRepositoryProvider);
    final universityId = user.information.universityId ?? '';
    final departmentId = isUni ? "" : (user.information.departmentId ?? '');

    final result = await repo.getResources(
      universityId: universityId,
      departmentId: departmentId,
      type: 'question',
      limit: _limit,
      offset: offset,
      search: search.isEmpty ? null : search,
      year: year,
      courseCode: courseCode,
      status: 'published',
    );

    return result.fold(
      (failure) {
        debugPrint('[QuestionsRepo] fetch failed: $failure');
        return QuestionsState(docs: [], totalCount: 0, hasMore: false);
      },
      (paginated) {
        final newDocs = paginated.resources
            .map((r) => _mapToContentModel(r))
            .toList();
        return QuestionsState(
          docs: newDocs,
          totalCount: paginated.total,
          hasMore: paginated.total > (offset + _limit),
        );
      },
    );
  }

  Future<void> loadNextPage() async {
    final currentState = state.value;
    if (currentState == null ||
        currentState.isLoadingMore ||
        !currentState.hasMore) {
      return;
    }

    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    final nextOffset = currentState.docs.length;
    final search = ref.read(questionsSearchQueryProvider);
    final isUni = ref.read(questionsScopeUniversityProvider);
    final year = ref.read(questionsSelectedYearProvider);
    final courseCode = ref.read(questionsSelectedCourseProvider);

    final user = ref.read(userProvider).value;
    if (user == null) return;

    final repo = ref.read(resourceRepositoryProvider);
    final universityId = user.information.universityId ?? '';
    final departmentId = isUni ? "" : (user.information.departmentId ?? '');

    final result = await repo.getResources(
      universityId: universityId,
      departmentId: departmentId,
      type: 'question',
      limit: _limit,
      offset: nextOffset,
      search: search.isEmpty ? null : search,
      year: year,
      courseCode: courseCode,
      status: 'published',
    );

    result.fold(
      (failure) => state = AsyncValue.data(
        currentState.copyWith(isLoadingMore: false, hasMore: false),
      ),
      (paginated) {
        final newDocs = paginated.resources
            .map((r) => _mapToContentModel(r))
            .toList();
        if (newDocs.isEmpty) {
          state = AsyncValue.data(
            currentState.copyWith(isLoadingMore: false, hasMore: false),
          );
          return;
        }
        state = AsyncValue.data(
          currentState.copyWith(
            docs: [...currentState.docs, ...newDocs],
            totalCount: paginated.total,
            isLoadingMore: false,
            hasMore: paginated.total > (nextOffset + _limit),
          ),
        );
      },
    );
  }

  ContentModel _mapToContentModel(Resource r) {
    return ContentModel(
      contentId: r.id,
      courseCode: r.courseCode,
      contentType: r.type,
      lessonNo: r.lessonNo,
      status: r.status,
      batches: [],
      contentTitle: r.title,
      contentSubtitle: r.description,
      contentSubtitleType: 'text',
      uploadDate: (r.createdAt ?? DateTime.now()).toString().split(' ')[0],
      fileUrl: r.fileUrl,
      imageUrl: r.thumbnailUrl,
      uploader: r.uploaderName,
      departmentId: r.departmentId,
      metadata: {
        ...r.metadata,
        'fileSizeBytes': r.fileSizeBytes,
        'pageCount': r.pageCount,
      },
    );
  }

  void refresh() {
    ref.invalidateSelf();
  }
}
