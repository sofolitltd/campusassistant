import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/student/presentation/providers/student_provider.dart';
import '/features/batch/presentation/providers/batch_list_provider.dart';
import '/features/batch/domain/entities/batch.dart';

// Virtual batch representing "All Batches" (No Filter).
final allBatchesPlaceholder = Batch(
  id: "all_batches",
  name: "All Batches",
  slug: "all",
  isStudying: true,
  departmentId: "",
  universityId: "",
  sessions: [],
);

// ---------------------------------------------------------------------------
// SelectedBatchNotifier
//
// Tracks the user's explicit batch choice:
//   null                  → not yet chosen (fallback in resolvedBatchProvider)
//   allBatchesPlaceholder → "All Batches" pinned
//   any real Batch        → specific batch
// ---------------------------------------------------------------------------
class SelectedBatchNotifier extends Notifier<Batch?> {
  @override
  Batch? build() => null;

  void setSelectedBatch(Batch? batch) => state = batch;
  void setAll() => state = allBatchesPlaceholder;
  void clear() => state = null;
}

final selectedBatchNotifierProvider =
    NotifierProvider<SelectedBatchNotifier, Batch?>(SelectedBatchNotifier.new);

// ---------------------------------------------------------------------------
// resolvedBatchProvider
//
// Resolves the effective batch through this chain:
//   1. Explicit user choice (selectedBatchNotifierProvider)
//   2. User auth profile batch (userProvider)
//   3. First studying batch as fallback
//
// Returns null only while user data is still loading.
// ---------------------------------------------------------------------------
final resolvedBatchProvider = Provider<Batch?>((ref) {
  final explicit = ref.watch(selectedBatchNotifierProvider);
  if (explicit != null) return explicit;

  final batches = ref.watch(batchProviderStudy).asData?.value;
  if (batches == null || batches.isEmpty) return null;

  // 1. User auth profile batch — fast path (usually stores batch name)
  final user = ref.watch(userProvider).asData?.value;
  if (user != null) {
    final match = matchBatch(user.information.batch, batches);
    if (match != null) return match;
  }

  // 2. Student profile batch — more authoritative (stores batch UUID)
  //    Don't fallback while still loading to avoid flash of wrong batch.
  final studentAsync = ref.watch(studentProfileProvider);
  final student = studentAsync.asData?.value;
  if (student != null) {
    final match = matchBatch(student.batchId, batches);
    if (match != null) return match;
  }

  if (studentAsync.isLoading || ref.watch(userProvider).isLoading) return null;

  return batches.first;
});

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------
bool isAllBatches(Batch? batch) => batch == null || batch.id == 'all_batches';

Batch? matchBatch(String? hint, List<Batch> batches) {
  if (hint == null || hint.isEmpty) return null;
  final h = hint.toLowerCase().trim();
  if (h == 'all' || h == 'all_batches') return allBatchesPlaceholder;
  return batches
      .where(
        (b) =>
            b.id.toLowerCase() == h ||
            b.name.toLowerCase() == h ||
            b.slug.toLowerCase() == h,
      )
      .firstOrNull;
}
