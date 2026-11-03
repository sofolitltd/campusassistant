import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_refresh_provider.dart';
import '../../../auth/presentation/providers/user_profile_provider.dart';
import '../../domain/entities/batch.dart';
import 'batch_provider.dart';
import '/features/study/levels/presentation/providers/semester_provider.dart';

// Base: ALL batches for the user's department.
// Not auto-disposed — batch list rarely changes, so we cache it.
final batchProviderAll = FutureProvider<List<Batch>>((ref) async {
  ref.watch(appRefreshProvider);
  try {
    final user = await ref.watch(userProvider.future);
    final departmentId = user.information.departmentId;
    if (departmentId == null || departmentId.isEmpty) return [];
    final batches = await ref.watch(
      batchesByDepartmentProvider(departmentId).future,
    );
    // Newest first by number: a text sort put "Batch 9" above "Batch 20".
    return List<Batch>.from(batches)..sort(
      (a, b) => batchNumber(b) != batchNumber(a)
          ? batchNumber(b).compareTo(batchNumber(a))
          : a.name.compareTo(b.name),
    );
  } catch (_) {
    return [];
  }
});

// Derived: batches that have study content (a level is linked to them),
// newest first. Whether a batch is still on campus (isStudying) doesn't
// matter here — a graduated batch's notes stay readable, and an old batch
// with nothing in it stays out of the picker.
// Auto-disposed — only needed while study page is active.
final batchProviderStudy = FutureProvider.autoDispose<List<Batch>>((ref) async {
  final all = await ref.watch(batchProviderAll.future);
  final semesters = await ref.watch(semestersProvider.future);
  // No levels loaded (offline with an empty cache, or a department with no
  // study content yet): fall back to on-campus batches so the picker isn't empty.
  if (semesters.isEmpty) return all.where((b) => b.isStudying).toList();
  final withContent = {for (final s in semesters) ...s.batches};
  return all.where((b) => withContent.contains(b.id)).toList()
    ..sort((a, b) => batchNumber(b).compareTo(batchNumber(a)));
});

/// "Batch 14" / "Masters Batch 14" → 14 (0 when there's no number).
int batchNumber(Batch b) =>
    int.tryParse(RegExp(r'\d+').firstMatch(b.name)?.group(0) ?? '') ?? 0;
