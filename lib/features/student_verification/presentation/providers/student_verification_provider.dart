import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '/core/network/api_endpoints.dart';
import '/features/student_verification/data/student_verification_request.dart';

/// Private upload folder for verification documents. The server stores these
/// privately and only admins can view them through a short-lived link.
const studentVerificationUploadFolder = 'student-verification';

/// The signed-in user's latest verification request, or null if they never
/// submitted one.
final myStudentVerificationProvider =
    FutureProvider.autoDispose<StudentVerificationRequest?>((ref) async {
      final apiClient = ref.watch(apiClientProvider);
      try {
        final response = await apiClient.get(
          ApiEndpoints.myStudentVerification,
        );
        return StudentVerificationRequest.fromJson(
          response.data as Map<String, dynamic>,
        );
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) return null;
        rethrow;
      }
    });

/// Uploads a verification document privately and returns its attachment id.
Future<String> uploadVerificationDocument(WidgetRef ref, File file) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.uploadFile(
    ApiEndpoints.myUpload,
    filePath: file.path,
    fieldName: 'image',
    data: {'folder': studentVerificationUploadFolder},
  );
  return response.data['id'] as String;
}

Future<StudentVerificationRequest> submitStudentVerification(
  WidgetRef ref, {
  required String universityId,
  required String departmentId,
  required String batchId,
  required String sessionId,
  required String studentId,
  required String name,
  required String phone,
  required String idCardAttachmentId,
  required String secondDocType,
  required String secondDocAttachmentId,
}) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.post(
    ApiEndpoints.myStudentVerification,
    data: {
      'university_id': universityId,
      'department_id': departmentId,
      'batch_id': batchId,
      'session_id': sessionId,
      'student_id': studentId,
      'name': name,
      'phone': phone,
      'id_card_attachment_id': idCardAttachmentId,
      'second_doc_type': secondDocType,
      'second_doc_attachment_id': secondDocAttachmentId,
    },
  );
  return StudentVerificationRequest.fromJson(
    response.data as Map<String, dynamic>,
  );
}

/// Server error message from a failed request, if it sent one.
String? serverErrorMessage(Object error) {
  if (error is DioException && error.response?.data is Map) {
    return error.response?.data['error'] as String?;
  }
  return null;
}
