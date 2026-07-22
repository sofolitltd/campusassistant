import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '../../data/models/skill.dart';

final skillsListProvider = FutureProvider.family<
    List<Skill>, ({String universityId, String departmentId})>((
  ref,
  params,
) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get(
    '/skills-by-location',
    queryParameters: {
      'university_id': params.universityId,
      'department_id': params.departmentId,
    },
  );
  final data = response.data as List; // raw array response, not {data: [...]}
  final skills = data
      .map((e) => Skill.fromJson(e as Map<String, dynamic>))
      .toList();
  skills.sort((a, b) => a.index.compareTo(b.index));
  return skills;
});
