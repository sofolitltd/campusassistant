import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/di.dart';
import '../../data/datasources/club_remote_data_source.dart';
import '../../data/models/club_model.dart';
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
  final cacheManager = ref.watch(cacheManagerProvider);
  final connectivity = ref.watch(connectivityServiceProvider);

  return ClubRepositoryImpl(
    remoteDataSource: remoteDataSource,
    cacheManager: cacheManager,
    connectivity: connectivity,
  );
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

/// Fetches a single club by ID — used when ClubDetailsPage is reached via a
/// deep link (e.g. a club-event push notification) with no Club object
/// already in hand, unlike the normal list-card tap which passes one via
/// route `extra` and never needs this.
@riverpod
Future<Club> clubById(Ref ref, String clubId) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get('/clubs/$clubId');
  return ClubModel.fromJson(response.data).toEntity();
}

/// Follows/unfollows/suggests a club directly against the repository — these
/// are one-shot mutations, not list queries, so they skip the usecase layer
/// (matching this session's lighter-weight pattern for new engagement
/// actions rather than adding a UseCase class per action).
Future<void> followClub(WidgetRef ref, String clubId) async {
  final repository = ref.read(clubRepositoryProvider);
  final result = await repository.followClub(clubId);
  result.fold((failure) => throw failure, (_) {});
}

Future<void> unfollowClub(WidgetRef ref, String clubId) async {
  final repository = ref.read(clubRepositoryProvider);
  final result = await repository.unfollowClub(clubId);
  result.fold((failure) => throw failure, (_) {});
}

Future<void> joinClub(WidgetRef ref, String clubId) async {
  final repository = ref.read(clubRepositoryProvider);
  final result = await repository.joinClub(clubId);
  result.fold((failure) => throw failure, (_) {});
}

Future<void> leaveClub(WidgetRef ref, String clubId) async {
  final repository = ref.read(clubRepositoryProvider);
  final result = await repository.leaveClub(clubId);
  result.fold((failure) => throw failure, (_) {});
}

Future<Club> suggestClub(WidgetRef ref, Club club) async {
  final repository = ref.read(clubRepositoryProvider);
  final result = await repository.suggestClub(club);
  return result.fold((failure) => throw failure, (saved) => saved);
}
