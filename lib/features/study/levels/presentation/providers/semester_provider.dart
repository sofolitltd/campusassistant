import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/cache/cache_manager.dart';
import '../../../../../core/cache/connectivity_service.dart';
import '../../../../../core/di.dart';
import '../../../../../core/providers/app_refresh_provider.dart';
import '../../domain/entities/semester.dart';
import '../../domain/repositories/semester_repository.dart';
import '../../data/repositories/semester_repository_impl.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/batch/presentation/providers/selected_batch_provider.dart';

final semesterRepositoryProvider = Provider<SemesterRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final cacheManager = ref.watch(cacheManagerProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  return SemesterRepositoryImpl(
    apiClient: apiClient,
    cacheManager: cacheManager,
    connectivity: connectivity,
  );
});

// ---------------------------------------------------------------------------
// semestersProvider
// Fetches ALL semesters for the user's department (no batch filter).
// This is the raw data pool — filtering happens client-side.
// ---------------------------------------------------------------------------
final semestersProvider = FutureProvider<List<Semester>>((ref) async {
  ref.watch(appRefreshProvider);
  final userAsync = ref.watch(userProvider);
  if (userAsync.value == null) return [];

  final user = userAsync.value!;
  final universityId = user.information.universityId ?? '';
  final departmentId = user.information.departmentId ?? '';

  final repository = ref.watch(semesterRepositoryProvider);
  final result = await repository.getSemesters(
    universityId: universityId,
    departmentId: departmentId,
    batch: null,
  );

  return result.fold((failure) => [], (semesters) => semesters);
});

// ---------------------------------------------------------------------------
// filteredSemestersProvider
//
// Returns semesters filtered by the currently resolved batch.
// - If "All Batches" or null → returns all semesters.
// - Otherwise → returns only semesters that contain the selected batch ID.
//
// This is PURE computation — it never mutates any state.
// Auto-resetting the semester selection is NOT done here; that is the
// responsibility of whoever changes the batch (the UI layer).
// ---------------------------------------------------------------------------
final filteredSemestersProvider = Provider<List<Semester>>((ref) {
  final allSemesters = ref.watch(semestersProvider).value ?? [];
  final selectedBatch = ref.watch(resolvedBatchProvider);

  // If no batch selected, or "All Batches" sentinel → show everything
  if (isAllBatches(selectedBatch)) return allSemesters;

  // Filter semesters that include the selected batch
  return allSemesters
      .where((s) => s.batches.contains(selectedBatch!.id))
      .toList();
});

// ---------------------------------------------------------------------------
// SelectedSemester — lightweight value object (id + name only)
// ---------------------------------------------------------------------------
class SelectedSemester {
  final String id;
  final String name;

  SelectedSemester({required this.id, required this.name});
}

// ---------------------------------------------------------------------------
// SelectedSemesterNotifier
//
// Holds the user's current semester selection.
//   null  → "All Semesters" (no semester filter)
//   value → specific semester selected by the user
//
// IMPORTANT: This notifier never auto-resets itself. The UI layer is
// responsible for explicitly clearing/setting this when appropriate.
// ---------------------------------------------------------------------------
class SelectedSemesterNotifier extends Notifier<SelectedSemester?> {
  @override
  SelectedSemester? build() => null;

  void setSemester(String id, String name) {
    state = SelectedSemester(id: id, name: name);
  }

  void setFromSemester(Semester semester) {
    state = SelectedSemester(id: semester.id, name: semester.name);
  }

  void clear() => state = null;
}

final selectedSemesterNotifierProvider =
    NotifierProvider<SelectedSemesterNotifier, SelectedSemester?>(
      SelectedSemesterNotifier.new,
    );

// ---------------------------------------------------------------------------
// Admin / CRUD providers
// ---------------------------------------------------------------------------
final createSemesterProvider = Provider((ref) {
  final repository = ref.watch(semesterRepositoryProvider);
  return (Semester semester) => repository.createSemester(semester);
});

final updateSemesterProvider = Provider((ref) {
  final repository = ref.watch(semesterRepositoryProvider);
  return (Semester semester) => repository.updateSemester(semester);
});

final deleteSemesterProvider = Provider((ref) {
  final repository = ref.watch(semesterRepositoryProvider);
  return (String id) => repository.deleteSemester(id);
});

final adminSemestersProvider = FutureProvider.autoDispose
    .family<List<Semester>, ({String universityId, String departmentId})>((
      ref,
      params,
    ) async {
      final repository = ref.watch(semesterRepositoryProvider);
      final result = await repository.getSemesters(
        universityId: params.universityId,
        departmentId: params.departmentId,
        batch: null,
      );
      return result.fold((failure) => [], (semesters) => semesters);
    });
