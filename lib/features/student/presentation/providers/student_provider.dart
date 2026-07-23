import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/di.dart';
import '../../../batch/presentation/providers/batch_provider.dart';
import '../../../session/presentation/providers/session_provider.dart';
import '../../../university/presentation/providers/university_provider.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/student/data/repositories/student_repository_impl.dart';
import '/utils/constants.dart';
import '/features/student/domain/entities/student.dart';
import '/features/student/domain/entities/student_address.dart';
import '/features/student/domain/repositories/student_repository.dart';

import 'package:collection/collection.dart';

part 'student_provider.g.dart';

@Riverpod(keepAlive: true)
StudentRepository studentRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  final cacheManager = ref.watch(cacheManagerProvider);
  final connectivity = ref.watch(connectivityServiceProvider);

  return StudentRepositoryImpl(
    apiClient: apiClient,
    cacheManager: cacheManager,
    connectivity: connectivity,
  );
}

// ---------------------------------------------------------------------------
// studentCountByBatchProvider — lightweight: returns only total count
// ---------------------------------------------------------------------------
@riverpod
Future<int> studentCountByBatch(Ref ref, String batchId) async {
  final repository = ref.watch(studentRepositoryProvider);
  final paginated = await repository.getStudents(batchId: batchId, limit: 1);
  return paginated.total;
}

// ---------------------------------------------------------------------------
// studentCountAllProvider — lightweight: returns total count for all students
// ---------------------------------------------------------------------------
@riverpod
Future<int> studentCountAll(
  Ref ref, {
  String? universityId,
  String? departmentId,
}) async {
  final repository = ref.watch(studentRepositoryProvider);
  final paginated = await repository.getStudents(
    universityId: universityId,
    departmentId: departmentId,
    limit: 1,
  );
  return paginated.total;
}

// ---------------------------------------------------------------------------
// _enrichStudents — helper to resolve hall/batch/session names
// ---------------------------------------------------------------------------
Future<List<Student>> _enrichStudents(
  Ref ref,
  List<Student> students, {
  String? universityId,
  String? departmentId,
}) async {
  if (students.isEmpty) return students;

  final effectiveUniversityId = universityId ?? students.first.universityId;
  final effectiveDepartmentId = departmentId ?? students.first.departmentId;

  final halls = await ref.watch(
    hallsByUniversityProvider(effectiveUniversityId).future,
  );
  final batches = await ref.watch(
    batchesByDepartmentProvider(effectiveDepartmentId).future,
  );
  final sessions = await ref.watch(
    sessionsByUniversityProvider(effectiveUniversityId).future,
  );

  return students.map((s) {
    final hall = halls.firstWhereOrNull((h) => h.id == s.hallId);
    final batch = batches.firstWhereOrNull((b) => b.id == s.batchId);
    final session = sessions.firstWhereOrNull((ses) => ses.id == s.sessionId);

    return s.copyWith(
      hallName: hall?.name,
      batchName: batch?.name,
      sessionName: session?.name,
    );
  }).toList();
}

// ---------------------------------------------------------------------------
// studentsByBatchPaginatedProvider — server-side pagination
// ---------------------------------------------------------------------------
@riverpod
Future<List<Student>> studentsByBatchPaginated(
  Ref ref, {
  required String batchId,
  required int limit,
  required int offset,
}) async {
  final repository = ref.watch(studentRepositoryProvider);
  final paginated = await repository.getStudents(
    batchId: batchId,
    limit: limit,
    offset: offset,
  );
  return _enrichStudents(ref, paginated.students);
}

// ---------------------------------------------------------------------------
// studentsWithTotalByBatchPaginatedProvider — like above but also returns total
// ---------------------------------------------------------------------------
@riverpod
Future<PaginatedStudents> studentsWithTotalByBatchPaginated(
  Ref ref, {
  required String batchId,
  required int limit,
  required int offset,
}) async {
  final repository = ref.watch(studentRepositoryProvider);
  final paginated = await repository.getStudents(
    batchId: batchId,
    limit: limit,
    offset: offset,
  );

  final enriched = await _enrichStudents(ref, paginated.students);
  return PaginatedStudents(students: enriched, total: paginated.total);
}

// ---------------------------------------------------------------------------
// studentsByBatchProvider — fetches ALL students for a batch (used by others)
// ---------------------------------------------------------------------------
@riverpod
Future<List<Student>> studentsByBatch(Ref ref, String batchId) async {
  final repository = ref.watch(studentRepositoryProvider);
  final paginated = await repository.getStudents(
    batchId: batchId,
    limit: kDefaultPageSize,
  );
  return _enrichStudents(ref, paginated.students);
}

@Riverpod(keepAlive: true)
Future<Student?> studentByUserId(Ref ref, String userId) async {
  final repository = ref.watch(studentRepositoryProvider);
  final paginated = await repository.getStudents(userId: userId);
  final student = paginated.students.isNotEmpty
      ? paginated.students.first
      : null;

  if (student == null) return null;

  // Enrich with hall/batch/session names — non-fatal when offline.
  // The entity getters (hall, batch, session) fall back to raw IDs.
  String? hallName;
  String? batchName;
  String? sessionName;

  try {
    final halls = await ref.watch(
      hallsByUniversityProvider(student.universityId).future,
    );
    hallName = halls.firstWhereOrNull((h) => h.id == student.hallId)?.name;
  } catch (_) {}

  try {
    final batches = await ref.watch(
      batchesByDepartmentProvider(student.departmentId).future,
    );
    batchName = batches.firstWhereOrNull((b) => b.id == student.batchId)?.name;
  } catch (_) {}

  try {
    final sessions = await ref.watch(
      sessionsByUniversityProvider(student.universityId).future,
    );
    sessionName = sessions
        .firstWhereOrNull((ses) => ses.id == student.sessionId)
        ?.name;
  } catch (_) {}

  return student.copyWith(
    hallName: hallName,
    batchName: batchName,
    sessionName: sessionName,
  );
}

@riverpod
Future<Student?> studentByAcademicId(Ref ref, String studentId) async {
  final repository = ref.watch(studentRepositoryProvider);
  final student = await repository.getStudentByAcademicId(studentId);

  if (student == null) return null;

  final halls = await ref.watch(
    hallsByUniversityProvider(student.universityId).future,
  );
  final batches = await ref.watch(
    batchesByDepartmentProvider(student.departmentId).future,
  );
  final sessions = await ref.watch(
    sessionsByUniversityProvider(student.universityId).future,
  );

  final hall = halls.firstWhereOrNull((h) => h.id == student.hallId);
  final batch = batches.firstWhereOrNull((b) => b.id == student.batchId);
  final session = sessions.firstWhereOrNull(
    (ses) => ses.id == student.sessionId,
  );

  return student.copyWith(
    hallName: hall?.name,
    batchName: batch?.name,
    sessionName: session?.name,
  );
}

@Riverpod(keepAlive: true)
Future<Student?> studentProfile(Ref ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null || user.role != 'student') return null;
  return ref.watch(studentByUserIdProvider(user.id).future);
}

@riverpod
Future<Student> studentByCode(Ref ref, String code) async {
  final repository = ref.watch(studentRepositoryProvider);
  final student = await repository.verifyCode(code);

  final halls = await ref.watch(
    hallsByUniversityProvider(student.universityId).future,
  );
  final batches = await ref.watch(
    batchesByDepartmentProvider(student.departmentId).future,
  );
  final sessions = await ref.watch(
    sessionsByUniversityProvider(student.universityId).future,
  );

  final hall = halls.firstWhereOrNull((h) => h.id == student.hallId);
  final batch = batches.firstWhereOrNull((b) => b.id == student.batchId);
  final session = sessions.firstWhereOrNull(
    (ses) => ses.id == student.sessionId,
  );

  return student.copyWith(
    hallName: hall?.name,
    batchName: batch?.name,
    sessionName: session?.name,
  );
}

@Riverpod(keepAlive: true)
Future<List<Student>> allStudents(
  Ref ref, {
  String? universityId,
  String? departmentId,
}) async {
  final repository = ref.watch(studentRepositoryProvider);
  final paginated = await repository.getStudents(
    universityId: universityId,
    departmentId: departmentId,
    limit: kDefaultPageSize,
  );
  final effectiveUniversityId =
      universityId ?? paginated.students.firstOrNull?.universityId;
  final effectiveDepartmentId =
      departmentId ?? paginated.students.firstOrNull?.departmentId;
  return _enrichStudents(
    ref,
    paginated.students,
    universityId: effectiveUniversityId,
    departmentId: effectiveDepartmentId,
  );
}

// ---------------------------------------------------------------------------
// Self-service profile writes — JWT-gated /my/user and /my/student routes.
// Reads go through the existing studentProfileProvider/studentByUserIdProvider
// (which already surface presentAddress/permanentAddress via StudentModel).
// ---------------------------------------------------------------------------

/// Updates the current user's own name/photo.
/// [avatarUrl] is expected to already be an uploaded file URL (see the
/// generic `/upload` endpoint via `ApiClient.uploadFile`/`uploadBytes`).
Future<void> updateMyUser(
  WidgetRef ref, {
  String? firstName,
  String? lastName,
  String? avatarUrl,
}) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.put(
    '/my/user',
    data: {
      'first_name': ?firstName,
      'last_name': ?lastName,
      'avatar_url': ?avatarUrl,
    },
  );
}

/// Updates the current user's own phone/blood group/hall.
Future<void> updateMyStudent(
  WidgetRef ref, {
  String? phone,
  String? bloodGroup,
  String? hallId,
}) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.put(
    '/my/student',
    data: {
      'phone': ?phone,
      'blood_group': ?bloodGroup,
      'hall_id': ?hallId,
    },
  );
}

/// Updates the current user's present/permanent address. Either may be
/// omitted to leave it unchanged.
Future<void> updateMyStudentAddress(
  WidgetRef ref, {
  StudentAddress? present,
  StudentAddress? permanent,
}) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.put(
    '/my/student/address',
    data: {
      if (present != null) 'present_address': present.toJson(),
      if (permanent != null) 'permanent_address': permanent.toJson(),
    },
  );
}

// ---------------------------------------------------------------------------
// studentsWithTotalAllPaginated — server-side pagination for "All" tab
// ---------------------------------------------------------------------------
@riverpod
Future<PaginatedStudents> studentsWithTotalAllPaginated(
  Ref ref, {
  required String? universityId,
  required String? departmentId,
  required int limit,
  required int offset,
}) async {
  final repository = ref.watch(studentRepositoryProvider);
  final paginated = await repository.getStudents(
    universityId: universityId,
    departmentId: departmentId,
    limit: limit,
    offset: offset,
  );

  final enriched = await _enrichStudents(
    ref,
    paginated.students,
    universityId: universityId ?? paginated.students.firstOrNull?.universityId,
    departmentId: departmentId ?? paginated.students.firstOrNull?.departmentId,
  );
  return PaginatedStudents(students: enriched, total: paginated.total);
}
