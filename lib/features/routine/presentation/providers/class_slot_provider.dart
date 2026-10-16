import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di.dart';
import '../../data/models/class_slot.dart';
import '../../../../core/providers/cache_for.dart';

typedef ClassScheduleScope = ({String departmentId, String batchId});
typedef ClassScheduleDateScope = ({
  String departmentId,
  String batchId,
  String date,
});

String _fmtDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// The weekly recurring slots for one batch. CRs enter these once at the
/// start of a semester from the printed routine; admins can manage them too.
final classSlotsProvider = FutureProvider.autoDispose
    .family<List<ClassSlot>, ClassScheduleScope>((ref, scope) async {
      ref.cacheFor(kParamProviderCacheTime);
      if (scope.departmentId.isEmpty || scope.batchId.isEmpty) return [];
      final apiClient = ref.watch(apiClientProvider);
      final response = await apiClient.get(
        '/class-slots',
        queryParameters: {
          'department_id': scope.departmentId,
          'batch_id': scope.batchId,
        },
      );
      final data = (response.data['data'] as List?) ?? [];
      return data
          .map((e) => ClassSlot.fromJson(e as Map<String, dynamic>))
          .toList();
    });

/// Status overrides (cancelled/rescheduled) for one batch on one date. No
/// row for a slot means it's held as scheduled.
final classSlotStatusesProvider = FutureProvider.autoDispose
    .family<List<ClassSlotStatus>, ClassScheduleDateScope>((ref, scope) async {
      ref.cacheFor(kParamProviderCacheTime);
      if (scope.departmentId.isEmpty || scope.batchId.isEmpty) return [];
      final apiClient = ref.watch(apiClientProvider);
      final response = await apiClient.get(
        '/class-slots/status',
        queryParameters: {
          'department_id': scope.departmentId,
          'batch_id': scope.batchId,
          'date': scope.date,
        },
      );
      final data = (response.data['data'] as List?) ?? [];
      return data
          .map((e) => ClassSlotStatus.fromJson(e as Map<String, dynamic>))
          .toList();
    });

void _invalidateSlots(WidgetRef ref, String departmentId, String batchId) {
  ref.invalidate(
    classSlotsProvider((departmentId: departmentId, batchId: batchId)),
  );
}

Future<void> createClassSlot(
  WidgetRef ref, {
  required String universityId,
  required String departmentId,
  required String batchId,
  required int dayOfWeek,
  required String courseName,
  required String teacher,
  required String room,
  required String startTime,
  required String endTime,
}) async {
  await ref
      .read(apiClientProvider)
      .post(
        '/class-slots',
        data: {
          'university_id': universityId,
          'department_id': departmentId,
          'batch_id': batchId,
          'day_of_week': dayOfWeek,
          'course_name': courseName,
          'teacher': teacher,
          'room': room,
          'start_time': startTime,
          'end_time': endTime,
        },
      );
  _invalidateSlots(ref, departmentId, batchId);
}

Future<void> updateClassSlot(
  WidgetRef ref, {
  required String id,
  required String departmentId,
  required String batchId,
  required int dayOfWeek,
  required String courseName,
  required String teacher,
  required String room,
  required String startTime,
  required String endTime,
}) async {
  await ref
      .read(apiClientProvider)
      .put(
        '/class-slots/$id',
        data: {
          'day_of_week': dayOfWeek,
          'course_name': courseName,
          'teacher': teacher,
          'room': room,
          'start_time': startTime,
          'end_time': endTime,
        },
      );
  _invalidateSlots(ref, departmentId, batchId);
}

Future<void> deleteClassSlot(
  WidgetRef ref, {
  required String id,
  required String departmentId,
  required String batchId,
}) async {
  await ref.read(apiClientProvider).delete('/class-slots/$id');
  _invalidateSlots(ref, departmentId, batchId);
}

/// Creates or replaces the override for a slot's occurrence on [date].
Future<void> setClassSlotStatus(
  WidgetRef ref, {
  required String classSlotId,
  required String departmentId,
  required String batchId,
  required DateTime date,
  required String status,
  String newStartTime = '',
  String newEndTime = '',
  String newRoom = '',
  String note = '',
}) async {
  await ref
      .read(apiClientProvider)
      .post(
        '/class-slots/status',
        data: {
          'class_slot_id': classSlotId,
          'date': _fmtDate(date),
          'status': status,
          'new_start_time': newStartTime,
          'new_end_time': newEndTime,
          'new_room': newRoom,
          'note': note,
        },
      );
  ref.invalidate(
    classSlotStatusesProvider((
      departmentId: departmentId,
      batchId: batchId,
      date: _fmtDate(date),
    )),
  );
}

/// Reverts an occurrence back to "held as scheduled".
Future<void> deleteClassSlotStatus(
  WidgetRef ref, {
  required String id,
  required String departmentId,
  required String batchId,
  required DateTime date,
}) async {
  await ref.read(apiClientProvider).delete('/class-slots/status/$id');
  ref.invalidate(
    classSlotStatusesProvider((
      departmentId: departmentId,
      batchId: batchId,
      date: _fmtDate(date),
    )),
  );
}
