import '/features/batch/domain/entities/batch.dart';
import '/features/batch/presentation/providers/batch_list_provider.dart';
import '/features/batch/presentation/providers/program_provider.dart';
import '/features/resource/domain/entities/resource.dart';

/// The batches another batch's resource is on, newest first ("Batch 20",
/// "Batch 19"), for the strip under its card. Null when it belongs to the
/// selected batch or its batches are unknown.
List<String>? otherBatchNames(
  Resource resource,
  String? selectedBatchId,
  List<Batch> batches,
) {
  if (selectedBatchId != null && resource.batches.contains(selectedBatchId)) {
    return null;
  }
  final own = batches.where((b) => resource.batches.contains(b.id)).toList()
    ..sort((a, b) => batchNumber(b).compareTo(batchNumber(a)));
  if (own.isEmpty) return null;
  return own.map(batchShortName).toList();
}

/// The selected batch's resources first, as the API returned them, then the
/// rest by their newest batch (Batch 20's before Batch 19's): the nearest
/// seniors' syllabus usually matches best. Ties keep the API order.
List<Resource> sortByBatch(
  List<Resource> resources,
  String? selectedBatchId,
  List<Batch> batches,
) {
  if (batches.isEmpty) return resources;
  final numbers = {for (final b in batches) b.id: batchNumber(b)};
  int newest(Resource r) =>
      r.batches.map((id) => numbers[id] ?? 0).fold(0, (a, b) => a > b ? a : b);
  bool isOwn(Resource r) =>
      selectedBatchId != null && r.batches.contains(selectedBatchId);

  final indexed = resources.indexed.toList();
  indexed.sort((a, b) {
    final ownA = isOwn(a.$2), ownB = isOwn(b.$2);
    if (ownA != ownB) return ownA ? -1 : 1;
    if (!ownA) {
      final byBatch = newest(b.$2).compareTo(newest(a.$2));
      if (byBatch != 0) return byBatch;
    }
    return a.$1.compareTo(b.$1);
  });
  return [for (final e in indexed) e.$2];
}
