import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di.dart';
import '../../data/datasources/department_remote_data_source.dart';
import '../../data/repositories/department_repository_impl.dart';
import '../../domain/entities/department.dart';
import '../../domain/repositories/department_repository.dart';
import '../../domain/usecases/get_departments.dart';
import '../../domain/usecases/create_department.dart';
import '../../domain/usecases/upload_department_logo.dart';
import '../../../university/presentation/providers/university_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'department_provider.g.dart';

@Riverpod(keepAlive: true)
DepartmentRemoteDataSource departmentRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DepartmentRemoteDataSourceImpl(apiClient: apiClient);
}

@Riverpod(keepAlive: true)
DepartmentRepository departmentRepository(Ref ref) {
  final remoteDataSource = ref.watch(departmentRemoteDataSourceProvider);
  return DepartmentRepositoryImpl(remoteDataSource: remoteDataSource);
}

@Riverpod(keepAlive: true)
GetDepartments getDepartments(Ref ref) {
  final repository = ref.watch(departmentRepositoryProvider);
  return GetDepartments(repository);
}

@Riverpod(keepAlive: true)
CreateDepartment createDepartment(Ref ref) {
  final repository = ref.watch(departmentRepositoryProvider);
  return CreateDepartment(repository);
}

@Riverpod(keepAlive: true)
UploadDepartmentLogo uploadDepartmentLogo(Ref ref) {
  final repository = ref.watch(departmentRepositoryProvider);
  return UploadDepartmentLogo(repository);
}

@riverpod
Future<List<Department>> departmentsByUniversity(Ref ref, String universityId) async {
  final getDepartments = ref.watch(getDepartmentsProvider);
  final result = await getDepartments(
    GetDepartmentsParams(universityId: universityId),
  );

  return result.fold(
    (failure) => throw failure,
    (departments) => departments,
  );
}

@Riverpod(keepAlive: true)
Future<List<Department>> myDepartments(Ref ref) async {
  final university = await ref.watch(myUniversityProvider.future);
  return ref.watch(departmentsByUniversityProvider(university.id).future);
}

@Riverpod(keepAlive: true)
Future<Department> myDepartment(Ref ref) async {
  final user = await ref.watch(currentUserProvider.future);

  if (user == null) throw Exception('User not logged in');

  final departmentsAsync = await ref.watch(myDepartmentsProvider.future);

  try {
    if (user.departmentId != null && user.departmentId!.isNotEmpty) {
      return departmentsAsync.firstWhere((d) => d.id == user.departmentId);
    }
    // Fallback to searching by ID if departmentId is not set but user ID matches a department (unlikely but preserved from legacy)
    return departmentsAsync.firstWhere((d) => d.id == user.id);
  } catch (e) {
    throw Exception('Department not found for user: ${user.id}');
  }
}

@riverpod
Future<Department?> departmentById(Ref ref, String arg) async {
  final parts = arg.split('|');
  if (parts.length < 2) return null;
  final universityId = parts[0];
  final id = parts[1];

  final departments = await ref.watch(
    departmentsByUniversityProvider(universityId).future,
  );
  try {
    return departments.firstWhere((d) => d.id == id);
  } catch (_) {
    return null;
  }
}

@riverpod
String departmentName(Ref ref, String arg) {
  final departmentAsync = ref.watch(departmentByIdProvider(arg));
  return departmentAsync.when(
    data: (d) => d?.name ?? arg.split('|').last,
    loading: () => 'Loading...',
    error: (_, _) => arg.split('|').last,
  );
}
