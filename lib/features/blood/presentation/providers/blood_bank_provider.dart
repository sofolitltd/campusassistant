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

// Scope (0 = Batch, 1 = Department, 2 = University)
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

  BloodBankState({required this.students, required this.total});
}

const int bloodBankPageSize = 20;

/// One page (numbered, not infinite-scroll) of blood bank results, keyed by
/// page number — matches the tab/page-number pagination used on the All
/// Students page instead of a cumulative loadMore() list.
final bloodBankPageProvider =
    FutureProvider.family<BloodBankState, int>((ref, page) async {
      final search = ref.watch(bloodBankSearchQueryProvider);
      final scope = ref.watch(bloodBankScopeProvider);
      final bloodGroup = ref.watch(bloodBankSelectedGroupProvider);
      final profile = await ref.watch(userProvider.future);

      final params = GetStudentsParams(
        universityId: scope <= 2 ? profile.information.universityId : null,
        departmentId: scope <= 1 ? profile.information.departmentId : null,
        batch: scope == 0 ? profile.information.batchId : null,
        search: search.isEmpty ? null : search,
        bloodGroup: bloodGroup,
        limit: bloodBankPageSize,
        offset: (page - 1) * bloodBankPageSize,
      );

      final useCase = GetStudents(ref.read(studentRepositoryProvider));
      final paginated = await useCase(params);

      return BloodBankState(
        students: paginated.students,
        total: paginated.total,
      );
    });
