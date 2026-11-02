import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '/core/network/api_endpoints.dart';
import '/features/auth/domain/entities/moderator_role.dart';

class ModerationStudent {
  const ModerationStudent({
    required this.id,
    required this.name,
    required this.roll,
    required this.verificationCode,
    this.batchName,
  });

  final String id;
  final String name;
  final String roll;
  final String verificationCode;
  final String? batchName;

  factory ModerationStudent.fromJson(Map<String, dynamic> json) =>
      ModerationStudent(
        id: json['id']?.toString() ?? '',
        name: json['name'] as String? ?? '',
        roll:
            json['student_id']?.toString() ??
            json['roll']?.toString() ??
            json['student_number']?.toString() ??
            '',
        verificationCode:
            json['verification_code'] as String? ??
            json['code'] as String? ??
            '',
        batchName:
            (json['batch'] as Map?)?['name'] as String? ??
            json['batch_name'] as String?,
      );
}

class ModerationVerification {
  const ModerationVerification({
    required this.id,
    required this.name,
    required this.studentNumber,
    required this.phone,
    required this.secondDocumentType,
    required this.createdAt,
    required this.universityId,
    required this.departmentId,
    required this.batchId,
    this.idDocumentUrl,
    this.secondDocumentUrl,
    this.batchName,
    this.departmentName,
  });

  final String id;
  final String name;
  final String studentNumber;
  final String phone;
  final String secondDocumentType;
  final DateTime? createdAt;
  final String universityId;
  final String departmentId;
  final String batchId;
  final String? idDocumentUrl;
  final String? secondDocumentUrl;
  final String? batchName;
  final String? departmentName;

  bool isInScope(ModeratorRole role) => switch (role.scopeType) {
    'batch' => batchId == role.scopeId,
    'department' => departmentId == role.scopeId,
    'university' => universityId == role.scopeId,
    _ => false,
  };

  factory ModerationVerification.fromJson(Map<String, dynamic> json) {
    final documents = json['documents'] as Map?;
    String idFrom(String key) {
      final value = json[key];
      if (value != null) return value.toString();
      return (json[key.replaceAll('_id', '')] as Map?)?['id']?.toString() ?? '';
    }

    String? nestedUrl(String key) {
      final value = json[key] ?? documents?[key];
      if (value is String) return value;
      if (value is Map) {
        return value['url'] as String? ??
            value['document_url'] as String? ??
            value['presigned_url'] as String?;
      }
      return null;
    }

    return ModerationVerification(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      studentNumber:
          json['student_id']?.toString() ??
          json['student_number']?.toString() ??
          '',
      phone: json['phone'] as String? ?? '',
      secondDocumentType: json['second_doc_type'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
      universityId: idFrom('university_id'),
      departmentId: idFrom('department_id'),
      batchId: idFrom('batch_id'),
      idDocumentUrl:
          nestedUrl('id_card_url') ??
          nestedUrl('id_card_attachment_url') ??
          nestedUrl('id_card_document') ??
          nestedUrl('id_card'),
      secondDocumentUrl:
          nestedUrl('second_doc_url') ??
          nestedUrl('second_doc_attachment_url') ??
          nestedUrl('second_document') ??
          nestedUrl('second_doc'),
      batchName: (json['batch'] as Map?)?['name'] as String?,
      departmentName: (json['department'] as Map?)?['name'] as String?,
    );
  }
}

class ModerationResource {
  const ModerationResource({
    required this.id,
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.type,
    required this.universityId,
    required this.departmentId,
    this.thumbnailUrl,
    this.creatorName,
    this.departmentName,
  });

  final String id;
  final String title;
  final String description;
  final String fileUrl;
  final String type;
  final String universityId;
  final String departmentId;
  final String? thumbnailUrl;
  final String? creatorName;
  final String? departmentName;

  bool isInScope(ModeratorRole role) => switch (role.scopeType) {
    'department' => departmentId == role.scopeId,
    'university' => universityId == role.scopeId,
    _ => false,
  };

  factory ModerationResource.fromJson(Map<String, dynamic> json) {
    final creator = json['creator'] as Map?;
    String idFrom(String key) {
      final value = json[key];
      if (value != null) return value.toString();
      return (json[key.replaceAll('_id', '')] as Map?)?['id']?.toString() ?? '';
    }

    final creatorFullName = [
      creator?['first_name'],
      creator?['last_name'],
    ].whereType<String>().where((part) => part.isNotEmpty).join(' ');
    return ModerationResource(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? 'Untitled resource',
      description: json['description'] as String? ?? '',
      fileUrl: json['file_url'] as String? ?? '',
      type: json['type'] as String? ?? 'resource',
      universityId: idFrom('university_id'),
      departmentId: idFrom('department_id'),
      thumbnailUrl: json['thumbnail_url'] as String?,
      creatorName:
          (creator?['name'] as String?) ??
          (creatorFullName.isEmpty ? null : creatorFullName) ??
          json['creator_name'] as String?,
      departmentName: (json['department'] as Map?)?['name'] as String?,
    );
  }
}

class ModerationDashboard {
  const ModerationDashboard({
    this.pendingCodes = 0,
    this.pendingVerifications = 0,
    this.pendingResources = 0,
  });

  final int pendingCodes;
  final int pendingVerifications;
  final int pendingResources;

  int get totalPending =>
      pendingCodes + pendingVerifications + pendingResources;

  factory ModerationDashboard.fromJson(Map<String, dynamic> json) {
    final counts =
        (json['pending_counts'] as Map?)?.cast<String, dynamic>() ??
        (json['counts'] as Map?)?.cast<String, dynamic>() ??
        json;
    int readCount(List<String> keys) {
      for (final key in keys) {
        final value = counts[key];
        if (value is num) return value.toInt();
        if (value is Map && value['pending'] is num) {
          return (value['pending'] as num).toInt();
        }
      }
      return 0;
    }

    return ModerationDashboard(
      pendingCodes: readCount(['codes', 'pending_codes', 'students']),
      pendingVerifications: readCount([
        'verifications',
        'pending_verifications',
        'requests',
      ]),
      pendingResources: readCount(['resources', 'pending_resources']),
    );
  }
}

dynamic _payload(dynamic responseData) {
  if (responseData is Map && responseData.containsKey('data')) {
    return responseData['data'];
  }
  return responseData;
}

List<Map<String, dynamic>> _listPayload(dynamic responseData) {
  final payload = _payload(responseData);
  final rows = payload is List
      ? payload
      : payload is Map && payload['items'] is List
      ? payload['items'] as List
      : payload is Map && payload['data'] is List
      ? payload['data'] as List
      : const [];
  return rows
      .whereType<Map>()
      .map((row) => row.cast<String, dynamic>())
      .toList();
}

final moderationDashboardProvider =
    FutureProvider.autoDispose<ModerationDashboard>((ref) async {
      final response = await ref
          .watch(apiClientProvider)
          .get(ApiEndpoints.moderationRoles);
      final payload = _payload(response.data);
      return ModerationDashboard.fromJson(
        payload is Map ? payload.cast<String, dynamic>() : const {},
      );
    });

typedef ModerationStudentsQuery = ({
  String scopeType,
  String scopeId,
  String query,
});

final moderationStudentsProvider = FutureProvider.autoDispose
    .family<List<ModerationStudent>, ModerationStudentsQuery>((
      ref,
      query,
    ) async {
      final response = await ref
          .watch(apiClientProvider)
          .get(
            ApiEndpoints.moderationStudents,
            queryParameters: {
              'scope_type': query.scopeType,
              'scope_id': query.scopeId,
              if (query.query.isNotEmpty) 'q': query.query,
              'page': 1,
            },
          );
      return _listPayload(response.data)
          .map(ModerationStudent.fromJson)
          .toList();
    });

final moderationVerificationsProvider =
    FutureProvider.autoDispose<List<ModerationVerification>>((ref) async {
      final response = await ref
          .watch(apiClientProvider)
          .get(
            ApiEndpoints.moderationVerifications,
            queryParameters: const {'status': 'pending'},
          );
      return _listPayload(response.data)
          .map(ModerationVerification.fromJson)
          .toList();
    });

final moderationResourcesProvider =
    FutureProvider.autoDispose<List<ModerationResource>>((ref) async {
      final response = await ref
          .watch(apiClientProvider)
          .get(
            ApiEndpoints.moderationResources,
            queryParameters: const {'status': 'pending'},
          );
      return _listPayload(response.data)
          .map(ModerationResource.fromJson)
          .toList();
    });

Future<ModerationVerification> getModerationVerification(
  WidgetRef ref,
  String id,
) async {
  final response = await ref
      .read(apiClientProvider)
      .get(ApiEndpoints.moderationVerification(id));
  final payload = _payload(response.data);
  return ModerationVerification.fromJson(
    payload is Map ? payload.cast<String, dynamic>() : const {},
  );
}

Future<String> regenerateStudentCode(WidgetRef ref, String studentId) async {
  final response = await ref
      .read(apiClientProvider)
      .post(ApiEndpoints.moderationGenerateCode(studentId));
  final payload = _payload(response.data);
  if (payload is Map) {
    final student = payload['student'];
    return (payload['verification_code'] ??
            payload['code'] ??
            (student is Map ? student['verification_code'] : null) ??
            '')
        .toString();
  }
  return '';
}

Future<void> reviewVerification(
  WidgetRef ref, {
  required String id,
  required bool approve,
  String? reason,
}) async {
  final client = ref.read(apiClientProvider);
  if (approve) {
    await client.put(ApiEndpoints.moderationVerificationApprove(id));
  } else {
    await client.put(
      ApiEndpoints.moderationVerificationReject(id),
      data: {'reason': reason},
    );
  }
}

Future<void> reviewResource(
  WidgetRef ref, {
  required String id,
  required bool approve,
  String? reason,
}) async {
  final client = ref.read(apiClientProvider);
  if (approve) {
    await client.patch(ApiEndpoints.moderationResourceApprove(id));
  } else {
    await client.patch(
      ApiEndpoints.moderationResourceReject(id),
      data: {'reason': reason},
    );
  }
}

String moderationErrorMessage(Object error) {
  if (error is DioException) {
    if (error.response?.statusCode == 409) return 'Sent to admin for review.';
    final data = error.response?.data;
    if (data is Map && data['error'] is String) {
      return data['error'] as String;
    }
  }
  return 'Something went wrong. Please try again.';
}
