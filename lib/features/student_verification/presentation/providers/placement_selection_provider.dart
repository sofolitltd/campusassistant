import 'package:flutter_riverpod/flutter_riverpod.dart';

/// University/department/batch picked on [PlacementSelectionScreen], carried
/// across the sign-up step so [VerificationRequestScreen] can prefill its
/// own cascade instead of asking the student to pick again.
class PlacementSelection {
  const PlacementSelection({
    required this.universityId,
    required this.departmentId,
    required this.batchId,
  });

  final String universityId;
  final String departmentId;
  final String batchId;
}

class PlacementSelectionNotifier extends Notifier<PlacementSelection?> {
  @override
  PlacementSelection? build() => null;

  void set(PlacementSelection selection) => state = selection;

  void clear() => state = null;
}

final placementSelectionProvider =
    NotifierProvider<PlacementSelectionNotifier, PlacementSelection?>(
      PlacementSelectionNotifier.new,
    );
