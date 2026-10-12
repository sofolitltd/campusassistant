import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di.dart';
import '../../data/models/class_notice.dart';

typedef ClassNoticeScope = ({String departmentId, String? batchId});

/// Notices for the user's batch plus department-wide ones. The server drops
/// expired rows, so what comes back is what should be shown.
final classNoticesProvider =
    FutureProvider.family<List<ClassNotice>, ClassNoticeScope>((
      ref,
      scope,
    ) async {
      if (scope.departmentId.isEmpty) return [];
      final apiClient = ref.watch(apiClientProvider);
      final response = await apiClient.get(
        '/class-notices',
        queryParameters: {
          'department_id': scope.departmentId,
          if (scope.batchId != null && scope.batchId!.isNotEmpty)
            'batch_id': scope.batchId,
        },
      );
      final data = (response.data['data'] as List?) ?? [];
      return data
          .map((e) => ClassNotice.fromJson(e as Map<String, dynamic>))
          .toList();
    });

/// Posts a notice as the current CR. No batch is sent: the server pins the
/// notice to the CR's own batch and rejects anyone who isn't the department's
/// current CR.
Future<void> postClassNotice(
  WidgetRef ref, {
  required String universityId,
  required String departmentId,
  required String title,
  required String message,
  DateTime? expiresAt,
  File? file,
  String? fileType,
}) async {
  final apiClient = ref.read(apiClientProvider);

  String fileUrl = '';
  if (file != null) {
    final uploaded = await apiClient.uploadFile(
      '/upload',
      filePath: file.path,
      fieldName: 'image',
      data: {'folder': 'class-notices'},
    );
    fileUrl = uploaded.data['file_url'] as String? ?? '';
  }

  await apiClient.post(
    '/class-notices',
    data: {
      'university_id': universityId,
      'department_id': departmentId,
      'title': title,
      'message': message,
      'file_url': fileUrl,
      'file_type': fileUrl.isEmpty ? '' : fileType,
      // Lapses at the end of the chosen day, not its start.
      if (expiresAt != null)
        'expires_at': DateTime(
          expiresAt.year,
          expiresAt.month,
          expiresAt.day,
          23,
          59,
          59,
        ).toUtc().toIso8601String(),
    },
  );
  ref.invalidate(classNoticesProvider);
}

Future<void> deleteClassNotice(WidgetRef ref, String id) async {
  await ref.read(apiClientProvider).delete('/class-notices/$id');
  ref.invalidate(classNoticesProvider);
}
