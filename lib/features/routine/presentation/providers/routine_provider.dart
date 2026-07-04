import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di.dart';
import '../../domain/entities/routine.dart';
import '../../domain/repositories/routine_repository.dart';
import '../../data/repositories/routine_repository_impl.dart';

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RoutineRepositoryImpl(apiClient: apiClient);
});

final routinesProvider =
    FutureProvider.family<
      List<Routine>,
      ({String universityId, String departmentId})
    >((ref, params) async {
      final repo = ref.watch(routineRepositoryProvider);
      final result = await repo.getRoutines(
        universityId: params.universityId,
        departmentId: params.departmentId,
      );
      return result.fold((failure) => [], (routines) => routines);
    });
