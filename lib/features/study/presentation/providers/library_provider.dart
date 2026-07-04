import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/content_model.dart';
import '/features/resource/presentation/providers/resource_provider.dart';
import '/features/resource/domain/entities/resource.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';

class LibraryState {
  final List<ContentModel> docs;
  final int totalCount;
  final bool isLoadingMore;
  final bool hasMore;

  LibraryState({
    required this.docs,
    required this.totalCount,
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  LibraryState copyWith({
    List<ContentModel>? docs,
    int? totalCount,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return LibraryState(
      docs: docs ?? this.docs,
      totalCount: totalCount ?? this.totalCount,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

// Search and Scope state using Notifier (modern Riverpod approach)
final librarySearchQueryProvider =
    NotifierProvider<LibrarySearchNotifier, String>(LibrarySearchNotifier.new);

class LibrarySearchNotifier extends Notifier<String> {
  @override
  String build() => "";
  @override
  set state(String value) => super.state = value;
}

final libraryScopeUniversityProvider =
    NotifierProvider<LibraryScopeNotifier, bool>(LibraryScopeNotifier.new);

class LibraryScopeNotifier extends Notifier<bool> {
  @override
  bool build() => false; // false = Dept, true = Uni
  @override
  set state(bool value) => super.state = value;
}

final libraryPaginationProvider =
    AsyncNotifierProvider<LibraryPaginationNotifier, LibraryState>(
      LibraryPaginationNotifier.new,
    );

class LibraryPaginationNotifier extends AsyncNotifier<LibraryState> {
  static const int _limit = 20;

  @override
  Future<LibraryState> build() async {
    final search = ref.watch(librarySearchQueryProvider);
    final isUni = ref.watch(libraryScopeUniversityProvider);

    // Reset to first page whenever search or scope changes
    return _fetchPage(offset: 0, search: search, isUni: isUni);
  }

  Future<LibraryState> _fetchPage({
    required int offset,
    required String search,
    required bool isUni,
  }) async {
    final user = ref.read(userProvider).value;
    if (user == null) return LibraryState(docs: [], totalCount: 0);

    final repo = ref.read(resourceRepositoryProvider);

    final universityId = user.information.universityId ?? '';
    final departmentId = isUni ? "" : (user.information.departmentId ?? '');

    final result = await repo.getResources(
      universityId: universityId,
      departmentId: departmentId,
      type: 'book',
      limit: _limit,
      offset: offset,
      search: search.isEmpty ? null : search,
      status: 'published',
    );

    return result.fold(
      (failure) => LibraryState(docs: [], totalCount: 0, hasMore: false),
      (paginated) {
        final newDocs = paginated.resources
            .map((r) => _mapToContentModel(r))
            .toList();
        return LibraryState(
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
        !currentState.hasMore)
      // ignore: curly_braces_in_flow_control_structures
      return;

    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    final nextOffset = currentState.docs.length;
    final search = ref.read(librarySearchQueryProvider);
    final isUni = ref.read(libraryScopeUniversityProvider);

    final user = ref.read(userProvider).value;
    if (user == null) return;

    final repo = ref.read(resourceRepositoryProvider);
    final universityId = user.information.universityId ?? '';
    final departmentId = isUni ? "" : (user.information.departmentId ?? '');

    final result = await repo.getResources(
      universityId: universityId,
      departmentId: departmentId,
      type: 'book',
      limit: _limit,
      offset: nextOffset,
      search: search.isEmpty ? null : search,
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
