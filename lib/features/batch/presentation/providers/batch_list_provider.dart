import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/app_refresh_provider.dart';
import '../../../auth/presentation/providers/user_profile_provider.dart';
import '../../domain/entities/batch.dart';
import 'batch_provider.dart';

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
    return List<Batch>.from(batches)..sort((a, b) => b.name.compareTo(a.name));
  } catch (_) {
    return [];
  }
});

// Derived: only studying batches, filtered from cached all-batches.
// Auto-disposed — only needed while study page is active.
final batchProviderStudy = FutureProvider.autoDispose<List<Batch>>((ref) async {
  final all = await ref.watch(batchProviderAll.future);
  return all.where((b) => b.isStudying).toList();
});
