import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/student/domain/entities/student.dart';
import '/features/student/domain/usecases/get_students.dart';
import '/features/student/presentation/providers/student_provider.dart';

// Search Query
final bloodBankSearchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(() => SearchQueryNotifier());

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void update(String query) => state = query;
}

// Blood Group Selection
final bloodBankSelectedGroupProvider =
    NotifierProvider<BloodGroupNotifier, String?>(() => BloodGroupNotifier());

class BloodGroupNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void update(String? group) => state = group;
}

// Scope (0 = Department, 1 = University, 2 = National)
final bloodBankScopeProvider = NotifierProvider<ScopeNotifier, int>(
  () => ScopeNotifier(),
);

class ScopeNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void update(int scope) => state = scope;
}

class BloodBankState {
  final List<Student> students;
  final int total;
  final bool isLoadingMore;
  final bool hasMore;

  BloodBankState({
    required this.students,
    required this.total,
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  BloodBankState copyWith({
    List<Student>? students,
    int? total,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return BloodBankState(
      students: students ?? this.students,
      total: total ?? this.total,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

final bloodBankPaginationProvider =
    AsyncNotifierProvider<BloodBankPaginationNotifier, BloodBankState>(
      () => BloodBankPaginationNotifier(),
    );

class BloodBankPaginationNotifier extends AsyncNotifier<BloodBankState> {
  static const int _limit = 20;

  @override
  Future<BloodBankState> build() async {
    final search = ref.watch(bloodBankSearchQueryProvider);
    final scope = ref.watch(bloodBankScopeProvider);
    final bloodGroup = ref.watch(bloodBankSelectedGroupProvider);
    final profile = await ref.watch(userProvider.future);

    final params = GetStudentsParams(
      universityId: scope <= 2 ? profile.information.universityId : null,
      departmentId: scope <= 1 ? profile.information.departmentId : null,
      batch: scope == 0 ? profile.information.batch : null,
      search: search.isEmpty ? null : search,
      bloodGroup: bloodGroup,
      limit: _limit,
      offset: 0,
    );

    final useCase = GetStudents(ref.read(studentRepositoryProvider));
    final paginated = await useCase(params);

    return BloodBankState(
      students: paginated.students,
      total: paginated.total,
      hasMore: paginated.students.length < paginated.total,
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

    final search = ref.read(bloodBankSearchQueryProvider);
    final scope = ref.read(bloodBankScopeProvider);
    final bloodGroup = ref.read(bloodBankSelectedGroupProvider);
    final profile = ref.read(userProvider).asData?.value;

    if (profile == null) return;

    final params = GetStudentsParams(
      universityId: scope <= 2 ? profile.information.universityId : null,
      departmentId: scope <= 1 ? profile.information.departmentId : null,
      batch: scope == 0 ? profile.information.batch : null,
      search: search.isEmpty ? null : search,
      bloodGroup: bloodGroup,
      limit: _limit,
      offset: currentState.students.length,
    );

    final useCase = GetStudents(ref.read(studentRepositoryProvider));
    try {
      final paginated = await useCase(params);
      final newStudents = [...currentState.students, ...paginated.students];
      state = AsyncValue.data(
        currentState.copyWith(
          students: newStudents,
          isLoadingMore: false,
          hasMore: newStudents.length < paginated.total,
        ),
      );
    } catch (_) {
      state = AsyncValue.data(currentState.copyWith(isLoadingMore: false));
    }
  }
}
