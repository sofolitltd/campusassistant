import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di.dart';
import '../../../batch/presentation/providers/batch_provider.dart';
import '../../../session/presentation/providers/session_provider.dart';
import '../../../university/presentation/providers/university_provider.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/student/data/repositories/student_repository_impl.dart';
import '/features/student/domain/entities/student.dart';
import '/features/student/domain/repositories/student_repository.dart';

import 'package:collection/collection.dart';

part 'student_provider.g.dart';

@Riverpod(keepAlive: true)
StudentRepository studentRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return StudentRepositoryImpl(apiClient: apiClient);
}

@riverpod
Future<List<Student>> studentsByBatch(Ref ref, String batchId) async {
  final repository = ref.watch(studentRepositoryProvider);
  final paginated = await repository.getStudents(batchId: batchId);
  final students = paginated.students;

  if (students.isEmpty) return students;

  final universityId = students.first.universityId;
  final departmentId = students.first.departmentId;

  final halls = await ref.watch(hallsByUniversityProvider(universityId).future);
  final batches = await ref.watch(batchesByDepartmentProvider(departmentId).future);
  final sessions = await ref.watch(sessionsByUniversityProvider(universityId).future);

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

@riverpod
Future<Student?> studentByUserId(Ref ref, String userId) async {
  final repository = ref.watch(studentRepositoryProvider);
  final paginated = await repository.getStudents(userId: userId);
  final student =
      paginated.students.isNotEmpty ? paginated.students.first : null;

  if (student == null) return null;

  final halls =
      await ref.watch(hallsByUniversityProvider(student.universityId).future);
  final batches =
      await ref.watch(batchesByDepartmentProvider(student.departmentId).future);
  final sessions =
      await ref.watch(sessionsByUniversityProvider(student.universityId).future);

  final hall = halls.firstWhereOrNull((h) => h.id == student.hallId);
  final batch = batches.firstWhereOrNull((b) => b.id == student.batchId);
  final session = sessions.firstWhereOrNull((ses) => ses.id == student.sessionId);

  return student.copyWith(
    hallName: hall?.name,
    batchName: batch?.name,
    sessionName: session?.name,
  );
}

@riverpod
Future<Student?> studentByAcademicId(Ref ref, String studentId) async {
  final repository = ref.watch(studentRepositoryProvider);
  final student = await repository.getStudentByAcademicId(studentId);

  if (student == null) return null;

  final halls =
      await ref.watch(hallsByUniversityProvider(student.universityId).future);
  final batches =
      await ref.watch(batchesByDepartmentProvider(student.departmentId).future);
  final sessions =
      await ref.watch(sessionsByUniversityProvider(student.universityId).future);

  final hall = halls.firstWhereOrNull((h) => h.id == student.hallId);
  final batch = batches.firstWhereOrNull((b) => b.id == student.batchId);
  final session = sessions.firstWhereOrNull((ses) => ses.id == student.sessionId);

  return student.copyWith(
    hallName: hall?.name,
    batchName: batch?.name,
    sessionName: session?.name,
  );
}

@riverpod
Future<Student?> studentProfile(Ref ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null || user.role != 'student') return null;
  return ref.watch(studentByUserIdProvider(user.id).future);
}

@riverpod
Future<Student> studentByCode(Ref ref, String code) async {
  final repository = ref.watch(studentRepositoryProvider);
  final student = await repository.verifyCode(code);

  final halls =
      await ref.watch(hallsByUniversityProvider(student.universityId).future);
  final batches =
      await ref.watch(batchesByDepartmentProvider(student.departmentId).future);
  final sessions =
      await ref.watch(sessionsByUniversityProvider(student.universityId).future);

  final hall = halls.firstWhereOrNull((h) => h.id == student.hallId);
  final batch = batches.firstWhereOrNull((b) => b.id == student.batchId);
  final session = sessions.firstWhereOrNull((ses) => ses.id == student.sessionId);

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
    limit: 2000,
  );
  final students = paginated.students;

  if (students.isEmpty) return students;

  final effectiveUniversityId = universityId ?? students.first.universityId;
  final effectiveDepartmentId = departmentId ?? students.first.departmentId;

  final halls =
      await ref.watch(hallsByUniversityProvider(effectiveUniversityId).future);
  final batches =
      await ref.watch(batchesByDepartmentProvider(effectiveDepartmentId).future);
  final sessions =
      await ref.watch(sessionsByUniversityProvider(effectiveUniversityId).future);

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
