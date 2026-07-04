import 'package:riverpod_annotation/riverpod_annotation.dart';

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
  return StaffRepositoryImpl(remoteDataSource: remoteDataSource);
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
  return (Staff staff) => repository.createStaff(staff).then((res) => res.fold((l) => throw l, (r) => r));
}

@riverpod
Future<Staff> Function(Staff) updateStaff(Ref ref) {
  final repository = ref.watch(staffRepositoryProvider);
  return (Staff staff) => repository.updateStaff(staff).then((res) => res.fold((l) => throw l, (r) => r));
}

@riverpod
Future<void> Function(String) deleteStaff(Ref ref) {
  final repository = ref.watch(staffRepositoryProvider);
  return (String id) => repository.deleteStaff(id).then((res) => res.fold((l) => throw l, (r) => r));
}
