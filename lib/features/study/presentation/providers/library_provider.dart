import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '/core/error/failures.dart';
import '/core/network/api_endpoints.dart';
import '/features/resource/domain/repositories/resource_repository.dart';
import '/features/resource/presentation/providers/resource_provider.dart';
import '/features/resource/domain/entities/resource.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';

class LibraryState {
  final List<Resource> docs;
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
    List<Resource>? docs,
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

/// A nullable filter value (department, level or course); null means "All".
class LibraryFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  @override
  set state(String? value) => super.state = value;
}

/// University tab only: the department picked there.
final librarySelectedDepartmentProvider =
    NotifierProvider<LibraryFilterNotifier, String?>(LibraryFilterNotifier.new);

final librarySelectedLevelProvider =
    NotifierProvider<LibraryFilterNotifier, String?>(LibraryFilterNotifier.new);

final librarySelectedCourseProvider =
    NotifierProvider<LibraryFilterNotifier, String?>(LibraryFilterNotifier.new);

/// The department whose books are listed: the user's own on the Department
/// tab; on the University tab the picked one, or '' for all departments.
final libraryDepartmentIdProvider = Provider<String>((ref) {
  if (ref.watch(libraryScopeUniversityProvider)) {
    return ref.watch(librarySelectedDepartmentProvider) ?? '';
  }
  return ref.watch(userProvider).value?.information.departmentId ?? '';
});

/// Departments of a university, for the University tab's picker.
final libraryDepartmentsProvider =
    FutureProvider.family<List<({String id, String name})>, String>((
      ref,
      universityId,
    ) async {
      final response = await ref
          .read(apiClientProvider)
          .get(
            ApiEndpoints.departments,
            queryParameters: {'university_id': universityId, 'limit': 100},
          );
      final data = (response.data as Map)['data'] as List? ?? [];
      return data
          .cast<Map>()
          .map((d) => (id: d['id'].toString(), name: d['name'].toString()))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    });

/// Levels of a department, in order.
final libraryLevelsProvider =
    FutureProvider.family<List<({String id, String name})>, String>((
      ref,
      departmentId,
    ) async {
      final response = await ref
          .read(apiClientProvider)
          .get(
            ApiEndpoints.levels,
            queryParameters: {'department_id': departmentId, 'limit': 100},
          );
      final data = ((response.data as Map)['data'] as List? ?? []).cast<Map>()
        ..sort(
          (a, b) =>
              ((a['order'] ?? 0) as num).compareTo((b['order'] ?? 0) as num),
        );
      return data
          .map((l) => (id: l['id'].toString(), name: l['name'].toString()))
          .toList();
    });

/// Courses of a department, with the level each belongs to.
final libraryCoursesProvider =
    FutureProvider.family<List<({String code, String levelId})>, String>((
      ref,
      departmentId,
    ) async {
      final response = await ref
          .read(apiClientProvider)
          .get(
            '/courses',
            queryParameters: {'department_id': departmentId, 'limit': 100},
          );
      final data = (response.data as Map)['data'] as List? ?? [];
      return data
          .cast<Map>()
          .map(
            (c) => (
              code: (c['course_code'] ?? '').toString().trim(),
              levelId: (c['level_id'] ?? '').toString(),
            ),
          )
          .where((c) => c.code.isNotEmpty)
          .toList();
    });

final libraryPaginationProvider =
    AsyncNotifierProvider<LibraryPaginationNotifier, LibraryState>(
      LibraryPaginationNotifier.new,
    );

class LibraryPaginationNotifier extends AsyncNotifier<LibraryState> {
  static const int _limit = 20;

  @override
  Future<LibraryState> build() async {
    // Reset to first page whenever search, scope or a filter changes
    ref.watch(librarySearchQueryProvider);
    ref.watch(libraryScopeUniversityProvider);
    ref.watch(librarySelectedDepartmentProvider);
    ref.watch(librarySelectedLevelProvider);
    ref.watch(librarySelectedCourseProvider);

    final user = ref.read(userProvider).value;
    if (user == null) return LibraryState(docs: [], totalCount: 0);
    return _fetchPage(offset: 0);
  }

  Future<Either<Failure, PaginatedResources>> _query(int offset) {
    final user = ref.read(userProvider).value!;
    final search = ref.read(librarySearchQueryProvider);
    final departmentId = ref.read(libraryDepartmentIdProvider);
    // Level and course only apply once a single department is in view.
    final hasDept = departmentId.isNotEmpty;

    return ref
        .read(resourceRepositoryProvider)
        .getResources(
          universityId: user.information.universityId ?? '',
          departmentId: departmentId,
          type: 'book',
          limit: _limit,
          offset: offset,
          search: search.isEmpty ? null : search,
          levelId: hasDept ? ref.read(librarySelectedLevelProvider) : null,
          courseCode: hasDept ? ref.read(librarySelectedCourseProvider) : null,
          status: 'published',
        );
  }

  Future<LibraryState> _fetchPage({required int offset}) async {
    final result = await _query(offset);

    return result.fold(
      (failure) => LibraryState(docs: [], totalCount: 0, hasMore: false),
      (paginated) {
        return LibraryState(
          docs: paginated.resources,
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

    final user = ref.read(userProvider).value;
    if (user == null) return;

    final result = await _query(nextOffset);

    result.fold(
      (failure) => state = AsyncValue.data(
        currentState.copyWith(isLoadingMore: false, hasMore: false),
      ),
      (paginated) {
        state = AsyncValue.data(
          currentState.copyWith(
            docs: [...currentState.docs, ...paginated.resources],
            totalCount: paginated.total,
            isLoadingMore: false,
            hasMore: paginated.total > (nextOffset + _limit),
          ),
        );
      },
    );
  }

  void refresh() {
    ref.invalidateSelf();
  }
}
