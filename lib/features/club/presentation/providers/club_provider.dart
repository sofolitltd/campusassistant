import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di.dart';
import '../../data/datasources/club_remote_data_source.dart';
import '../../data/repositories/club_repository_impl.dart';
import '../../domain/entities/club.dart';
import '../../domain/repositories/club_repository.dart';
import '../../domain/usecases/get_clubs.dart';
import '../../../university/presentation/providers/university_provider.dart';
import '../../../department/presentation/providers/department_provider.dart';

part 'club_provider.g.dart';

@Riverpod(keepAlive: true)
ClubRemoteDataSource clubRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ClubRemoteDataSourceImpl(apiClient: apiClient);
}

@Riverpod(keepAlive: true)
ClubRepository clubRepository(Ref ref) {
  final remoteDataSource = ref.watch(clubRemoteDataSourceProvider);
  return ClubRepositoryImpl(remoteDataSource: remoteDataSource);
}

@Riverpod(keepAlive: true)
GetClubs getClubs(Ref ref) {
  final repository = ref.watch(clubRepositoryProvider);
  return GetClubs(repository);
}

@riverpod
Future<List<Club>> clubsList(Ref ref, String type) async {
  final university = await ref.watch(myUniversityProvider.future);

  String? departmentId;
  if (type == 'department') {
    final department = await ref.watch(myDepartmentProvider.future);
    departmentId = department.id;
  }

  final getClubs = ref.watch(getClubsProvider);
  final result = await getClubs(
    GetClubsParams(
      universityId: university.id,
      departmentId: departmentId,
      type: type,
    ),
  );

  return result.fold((failure) => throw failure, (clubs) => clubs);
}
