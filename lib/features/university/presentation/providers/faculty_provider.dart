import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '/core/network/api_endpoints.dart';
import '/features/department/data/models/department_model.dart';
import '/features/department/domain/entities/department.dart';
import '../../data/models/faculty.dart';

final facultiesByUniversityProvider = FutureProvider.family<List<Faculty>, String>((
  ref,
  universityId,
) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get(
    '/faculties',
    queryParameters: {'university_id': universityId},
  );
  final body = response.data as Map<String, dynamic>;
  final data = body['data'] as List? ?? [];
  return data.map((e) => Faculty.fromJson(e as Map<String, dynamic>)).toList();
});

final departmentsByFacultyProvider = FutureProvider.family<List<Department>, String>((
  ref,
  facultyId,
) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get(
    ApiEndpoints.departments,
    queryParameters: {'faculty_id': facultyId},
  );
  final body = response.data as Map<String, dynamic>;
  final data = body['data'] as List? ?? [];
  return data
      .map((e) => DepartmentModel.fromJson(e as Map<String, dynamic>).toEntity())
      .toList();
});
