import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/di.dart';
import '/features/university/presentation/providers/university_provider.dart';
import '/features/department/presentation/providers/department_provider.dart';
import '../../data/models/cr_model.dart';

final crProvider = FutureProvider<List<CrModel>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final university = await ref.watch(myUniversityProvider.future);
  final department = await ref.watch(myDepartmentProvider.future);

  final response = await apiClient.get(
    '/crs',
    queryParameters: {
      'university_id': university.id,
      'department_id': department.id,
    },
  );

  final data = response.data;
  if (data is Map<String, dynamic> && data['data'] != null) {
    return (data['data'] as List)
        .map((e) => CrModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  return [];
});

// Admin providers
final crsByDepartmentAdminProvider =
    FutureProvider.family<
      List<CrModel>,
      ({String universityId, String departmentId})
    >((ref, arg) async {
      final apiClient = ref.watch(apiClientProvider);

      final response = await apiClient.get(
        '/crs',
        queryParameters: {
          'university_id': arg.universityId,
          'department_id': arg.departmentId,
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data['data'] != null) {
        return (data['data'] as List)
            .map((e) => CrModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    });

final createCrProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return (CrModel cr) async {
    await apiClient.post('/crs', data: cr.toJson());
  };
});

final updateCrProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return (CrModel cr) async {
    await apiClient.put('/crs/${cr.id}', data: cr.toJson());
  };
});

final deleteCrProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return (String id) async {
    await apiClient.delete('/crs/$id');
  };
});
