import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/di.dart';
import '../../../university/presentation/providers/university_provider.dart';
import '../../../department/presentation/providers/department_provider.dart';
import '../../data/datasources/staff_remote_data_source.dart';
import '../../data/repositories/staff_repository_impl.dart';
import '../../domain/entities/staff.dart';
import '../../domain/repositories/staff_repository.dart';

part 'staff_provider.g.dart';

@Riverpod(keepAlive: true)
StaffRemoteDataSource staffRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return StaffRemoteDataSourceImpl(apiClient: apiClient);
}

@Riverpod(keepAlive: true)
StaffRepository staffRepository(Ref ref) {
  final remoteDataSource = ref.watch(staffRemoteDataSourceProvider);
  final cacheManager = ref.watch(cacheManagerProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  return StaffRepositoryImpl(
    remoteDataSource: remoteDataSource,
    cacheManager: cacheManager,
    connectivity: connectivity,
  );
}

@riverpod
Future<List<Staff>> staffList(Ref ref) async {
  final university = await ref.watch(myUniversityProvider.future);
  final department = await ref.watch(myDepartmentProvider.future);

  final repository = ref.watch(staffRepositoryProvider);
  final result = await repository.getStaff(
    universityId: university.id,
    departmentId: department.id,
  );
  return result.fold((failure) => throw failure, (staff) => staff);
}

/// Lightweight staff total for count displays — avoids downloading the full
/// staff list just to render a number. Kept alive so it survives navigation.
@Riverpod(keepAlive: true)
Future<int> staffCount(Ref ref) async {
  final university = await ref.watch(myUniversityProvider.future);
  final department = await ref.watch(myDepartmentProvider.future);

  if (university.id.isEmpty || department.id.isEmpty) return 0;

  final repository = ref.watch(staffRepositoryProvider);
  final result = await repository.getStaffCount(
    universityId: university.id,
    departmentId: department.id,
  );
  return result.fold((failure) => throw failure, (count) => count);
}

@riverpod
Future<Staff> singleStaff(Ref ref, String staffId) async {
  final university = await ref.watch(myUniversityProvider.future);
  final department = await ref.watch(myDepartmentProvider.future);

  final repository = ref.watch(staffRepositoryProvider);
  final result = await repository.getStaffById(
    universityId: university.id,
    departmentId: department.id,
    staffId: staffId,
  );

  return result.fold((failure) => throw failure, (staff) => staff);
}

@riverpod
Future<List<Staff>> staffsByDepartment(
  Ref ref, {
  required String universityId,
  required String departmentId,
}) async {
  final repository = ref.watch(staffRepositoryProvider);
  final result = await repository.getStaff(
    universityId: universityId,
    departmentId: departmentId,
  );
  return result.fold((failure) => throw failure, (staff) => staff);
}

@riverpod
Future<Staff> Function(Staff) createStaff(Ref ref) {
  final repository = ref.watch(staffRepositoryProvider);
  return (Staff staff) => repository
      .createStaff(staff)
      .then((res) => res.fold((l) => throw l, (r) => r));
}

@riverpod
Future<Staff> Function(Staff) updateStaff(Ref ref) {
  final repository = ref.watch(staffRepositoryProvider);
  return (Staff staff) => repository
      .updateStaff(staff)
      .then((res) => res.fold((l) => throw l, (r) => r));
}

@riverpod
Future<void> Function(String) deleteStaff(Ref ref) {
  final repository = ref.watch(staffRepositoryProvider);
  return (String id) => repository
      .deleteStaff(id)
      .then((res) => res.fold((l) => throw l, (r) => r));
}
