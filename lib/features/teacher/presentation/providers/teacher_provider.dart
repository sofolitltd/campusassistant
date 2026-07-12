import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/di.dart';
import '../../data/datasources/teacher_remote_data_source.dart';
import '../../data/repositories/teacher_repository_impl.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/repositories/teacher_repository.dart';
import '../../domain/usecases/get_teachers.dart';
import '../../../university/presentation/providers/university_provider.dart';
import '../../../department/presentation/providers/department_provider.dart';

part 'teacher_provider.g.dart';

@Riverpod(keepAlive: true)
TeacherRemoteDataSource teacherRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TeacherRemoteDataSourceImpl(apiClient: apiClient);
}

@Riverpod(keepAlive: true)
TeacherRepository teacherRepository(Ref ref) {
  final remoteDataSource = ref.watch(teacherRemoteDataSourceProvider);
  final cacheManager = ref.watch(cacheManagerProvider);
  final connectivity = ref.watch(connectivityServiceProvider);

  return TeacherRepositoryImpl(
    remoteDataSource: remoteDataSource,
    cacheManager: cacheManager,
    connectivity: connectivity,
  );
}

@Riverpod(keepAlive: true)
GetTeachers getTeachers(Ref ref) {
  final repository = ref.watch(teacherRepositoryProvider);
  return GetTeachers(repository);
}

@riverpod
Future<List<Teacher>> teachersList(Ref ref, bool? isPresent) async {
  final university = await ref.watch(myUniversityProvider.future);
  final department = await ref.watch(myDepartmentProvider.future);

  if (university.id.isEmpty || department.id.isEmpty) {
    return [];
  }

  final getTeachers = ref.watch(getTeachersProvider);
  final result = await getTeachers(
    GetTeachersParams(
      universityId: university.id,
      departmentId: department.id,
      isPresent: isPresent,
    ),
  );

  return result.fold((failure) => throw failure, (teachers) {
    if (isPresent == null) return teachers;
    return teachers.where((t) => t.present == isPresent).toList();
  });
}

@riverpod
Future<Teacher> singleTeacher(Ref ref, String teacherId) async {
  final university = await ref.watch(myUniversityProvider.future);
  final department = await ref.watch(myDepartmentProvider.future);

  final repository = ref.watch(teacherRepositoryProvider);
  final result = await repository.getTeacherById(
    universityId: university.id,
    departmentId: department.id,
    teacherId: teacherId,
  );

  return result.fold((failure) => throw failure, (teacher) => teacher);
}

@riverpod
Future<Teacher> Function(Teacher) createTeacher(Ref ref) {
  final repository = ref.watch(teacherRepositoryProvider);
  return (Teacher teacher) => repository.createTeacher(teacher).then((res) => res.fold((l) => throw l, (r) => r));
}

@riverpod
Future<Teacher> Function(Teacher) updateTeacher(Ref ref) {
  final repository = ref.watch(teacherRepositoryProvider);
  return (Teacher teacher) => repository.updateTeacher(teacher).then((res) => res.fold((l) => throw l, (r) => r));
}

@riverpod
Future<void> Function(String) deleteTeacher(Ref ref) {
  final repository = ref.watch(teacherRepositoryProvider);
  return (String id) => repository.deleteTeacher(id).then((res) => res.fold((l) => throw l, (r) => r));
}

@riverpod
Future<List<Teacher>> teachersByDepartment(
  Ref ref, {
  required String universityId,
  required String departmentId,
}) async {
  final repository = ref.watch(teacherRepositoryProvider);
  final result = await repository.getTeachers(
    universityId: universityId,
    departmentId: departmentId,
  );
  return result.fold((failure) => throw failure, (teachers) => teachers);
}
