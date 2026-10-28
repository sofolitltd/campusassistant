import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di.dart';
import '../../data/models/exam_notice.dart';
import '../../../../core/providers/cache_for.dart';

typedef ExamNoticeScope = ({
  String universityId,
  String departmentId,
  String? batchId,
});

/// Exam notices for the student's department: department-wide ones plus
/// their own batch's. The backend has no OR-filter for this (unlike
/// class-notices), so batch scoping happens here on the department's full
/// list, which is small.
final examNoticesProvider = FutureProvider.autoDispose
    .family<List<ExamNotice>, ExamNoticeScope>((ref, scope) async {
      ref.cacheFor(kParamProviderCacheTime);
      if (scope.departmentId.isEmpty) return [];
      final apiClient = ref.watch(apiClientProvider);
      final response = await apiClient.get(
        '/exam-notices',
        queryParameters: {
          'university_id': scope.universityId,
          'department_id': scope.departmentId,
          'limit': 200,
        },
      );
      final data = (response.data['data'] as List?) ?? [];
      final notices = data
          .map((e) => ExamNotice.fromJson(e as Map<String, dynamic>))
          .where((n) => n.batchId == null || n.batchId == scope.batchId)
          .toList();
      notices.sort((a, b) => a.examDate.compareTo(b.examDate));
      return notices;
    });

/// Exams still coming up (today or later), for the home-screen countdown.
final upcomingExamNoticesProvider = FutureProvider.autoDispose
    .family<List<ExamNotice>, ExamNoticeScope>((ref, scope) async {
      final all = await ref.watch(examNoticesProvider(scope).future);
      return all.where((e) => !e.isPast).toList();
    });
