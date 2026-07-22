import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di.dart';
import '../../../auth/presentation/providers/user_profile_provider.dart';
import '../../domain/entities/alumni.dart';
import '../../domain/entities/alumni_organization.dart';
import '../../domain/repositories/alumni_repository.dart';
import '../../data/repositories/alumni_repository_impl.dart';

part 'alumni_provider.g.dart';

// --- Dependency Injection ---

@riverpod
AlumniRepository alumniRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AlumniRepositoryImpl(apiClient: apiClient);
}

// --- Filter State Notifiers ---

@riverpod
class AlumniSearchQuery extends _$AlumniSearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

@riverpod
class AlumniScope extends _$AlumniScope {
  @override
  int build() => 0;

  void update(int scope) => state = scope;
}

@riverpod
class AlumniSelectedOrganization extends _$AlumniSelectedOrganization {
  @override
  AlumniOrganization? build() => null;

  void update(AlumniOrganization? org) => state = org;
}

// --- Alumni Paginated State Model ---

class AlumniState {
  final List<Alumni> alumni;
  final int total;
  final bool isLoadingMore;
  final bool hasMore;

  AlumniState({
    required this.alumni,
    required this.total,
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  AlumniState copyWith({
    List<Alumni>? alumni,
    int? total,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return AlumniState(
      alumni: alumni ?? this.alumni,
      total: total ?? this.total,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

// --- Alumni Pagination Notifier ---

@riverpod
class AlumniPagination extends _$AlumniPagination {
  static const int _limit = 20;

  @override
  Future<AlumniState> build() async {
    final search = ref.watch(alumniSearchQueryProvider);
    final scope = ref.watch(alumniScopeProvider);
    final organization = ref.watch(alumniSelectedOrganizationProvider);
    final profile = await ref.watch(userProvider.future);

    // Mapped search scopes:
    // Batch scope -> scope == 0
    // Department scope -> scope <= 1
    // University scope -> scope <= 2 (broadest — always true, 3 tabs total)
    final universityId = scope <= 2 ? profile.information.universityId : null;
    final departmentId = scope <= 1 ? profile.information.departmentId : null;
    // Alumni.Batch is a free-text field (not a Batch-table FK, unlike
    // Student.BatchID), so this must stay the display name, not the UUID.
    final batch = scope == 0 ? profile.information.batch : null;

    final repo = ref.watch(alumniRepositoryProvider);
    final paginated = await repo.getAlumni(
      universityId: universityId,
      departmentId: departmentId,
      batch: batch,
      search: search.isEmpty ? null : search,
      organizationId: organization?.id,
      limit: _limit,
      offset: 0,
    );

    return AlumniState(
      alumni: paginated.alumniList,
      total: paginated.total,
      hasMore: paginated.alumniList.length < paginated.total,
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

    final search = ref.read(alumniSearchQueryProvider);
    final scope = ref.read(alumniScopeProvider);
    final organization = ref.read(alumniSelectedOrganizationProvider);
    final profile = ref.read(userProvider).asData?.value;

    if (profile == null) return;

    final universityId = scope <= 2 ? profile.information.universityId : null;
    final departmentId = scope <= 1 ? profile.information.departmentId : null;
    // Alumni.Batch is a free-text field (not a Batch-table FK, unlike
    // Student.BatchID), so this must stay the display name, not the UUID.
    final batch = scope == 0 ? profile.information.batch : null;

    final repo = ref.read(alumniRepositoryProvider);
    try {
      final paginated = await repo.getAlumni(
        universityId: universityId,
        departmentId: departmentId,
        batch: batch,
        search: search.isEmpty ? null : search,
        organizationId: organization?.id,
        limit: _limit,
        offset: currentState.alumni.length,
      );
      final newAlumni = [...currentState.alumni, ...paginated.alumniList];
      state = AsyncValue.data(
        currentState.copyWith(
          alumni: newAlumni,
          isLoadingMore: false,
          hasMore: newAlumni.length < paginated.total,
        ),
      );
    } catch (_) {
      state = AsyncValue.data(currentState.copyWith(isLoadingMore: false));
    }
  }
}

// --- Fetch Organizations Provider ---

@riverpod
Future<List<AlumniOrganization>> alumniOrganizations(
  Ref ref, {
  String? search,
}) async {
  final repo = ref.watch(alumniRepositoryProvider);
  return repo.getOrganizations(search: search);
}

// --- Alumni Single Detail Provider ---

@riverpod
Future<Alumni> alumniDetail(Ref ref, String id) async {
  final repo = ref.watch(alumniRepositoryProvider);
  return repo.getAlumniById(id);
}
