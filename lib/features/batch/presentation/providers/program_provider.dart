import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '/core/providers/app_refresh_provider.dart';
import '../../domain/entities/batch.dart';
import 'batch_list_provider.dart';
import 'selected_batch_provider.dart';

// ---------------------------------------------------------------------------
// Programs (Honors / Masters)
//
// Honors and Masters intakes are separate batches (Batch.program). Study
// shows a program switch only when the department has more than one
// program; the batch dropdown then lists just that program's batches.
// ---------------------------------------------------------------------------

const kPrograms = ['honours', 'masters'];

String programLabel(String program) =>
    program == 'masters' ? 'Masters' : 'Honors';

/// Batch name without the program word ("Masters Batch 14" → "Batch 14"),
/// for places where the Honors/Masters switch already says which program.
String batchShortName(Batch batch) =>
    batch.name.replaceFirst(RegExp(r'^Masters\s+', caseSensitive: false), '');

/// One of the student's own batches: the current one, or an earlier program
/// (e.g. the Honors batch of someone now in Masters).
class ProgramBatch {
  final String batchId;
  final String program;

  const ProgramBatch({required this.batchId, required this.program});
}

class MyPrograms {
  final ProgramBatch? current;
  final List<ProgramBatch> earlier; // newest first

  const MyPrograms({this.current, this.earlier = const []});

  List<ProgramBatch> get all => [?current, ...earlier];
}

/// GET /my/student/enrollments — empty for non-students or an API without
/// the endpoint, which leaves Study exactly as before.
final myProgramsProvider = FutureProvider<MyPrograms>((ref) async {
  ref.watch(appRefreshProvider);
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get('/my/student/enrollments');
    final body = response.data as Map<String, dynamic>;
    final rows = (body['data'] as List? ?? []).cast<Map<String, dynamic>>();
    final currentId = body['current_batch_id'] as String?;
    return MyPrograms(
      current: currentId == null
          ? null
          : ProgramBatch(
              batchId: currentId,
              program: body['current_program'] as String? ?? 'honours',
            ),
      earlier: rows
          .map(
            (e) => ProgramBatch(
              batchId: e['batch_id'] as String,
              program: e['program'] as String? ?? 'honours',
            ),
          )
          .toList(),
    );
  } catch (_) {
    return const MyPrograms();
  }
});

/// Programs the department has study content for, in kPrograms order.
final departmentProgramsProvider = Provider<List<String>>((ref) {
  final all = ref.watch(batchProviderStudy).value ?? const <Batch>[];
  final present = all.map((b) => b.program).toSet();
  return kPrograms.where(present.contains).toList();
});

class SelectedProgramNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String program) => state = program;
}

final selectedProgramNotifierProvider =
    NotifierProvider<SelectedProgramNotifier, String?>(
      SelectedProgramNotifier.new,
    );

/// The selected batch's program; with "All Batches", the last program
/// switched to → the student's current program → Honors. The batch wins so
/// a batch picked elsewhere (e.g. from a /study/courses link) can't disagree
/// with the switch.
final effectiveProgramProvider = Provider<String>((ref) {
  final batch = ref.watch(resolvedBatchProvider);
  if (batch != null && !isAllBatches(batch)) return batch.program;
  return ref.watch(selectedProgramNotifierProvider) ??
      ref.watch(myProgramsProvider).value?.current?.program ??
      'honours';
});

/// Batches for the dropdown: those with study content, and with several
/// programs only the current program's.
final programBatchesProvider = FutureProvider.autoDispose<List<Batch>>((
  ref,
) async {
  final withContent = await ref.watch(batchProviderStudy.future);
  if (ref.watch(departmentProgramsProvider).length < 2) return withContent;
  final program = ref.watch(effectiveProgramProvider);
  return withContent.where((b) => b.program == program).toList();
});

/// Switches Study to [program] and selects the student's own batch in it
/// (from their history), else that program's newest batch with content.
void switchProgram(WidgetRef ref, String program) {
  ref.read(selectedProgramNotifierProvider.notifier).set(program);

  final all = ref.read(batchProviderStudy).value ?? const <Batch>[];
  final own = ref.read(myProgramsProvider).value?.all ?? const [];
  final ownId = own.where((p) => p.program == program).firstOrNull?.batchId;
  final inProgram = all.where((b) => b.program == program);
  final target =
      inProgram.where((b) => b.id == ownId).firstOrNull ??
      inProgram.firstOrNull;

  final batchNotifier = ref.read(selectedBatchNotifierProvider.notifier);
  if (target != null) {
    batchNotifier.setSelectedBatch(target);
  } else {
    batchNotifier.setAll();
  }
}
