import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/hall.dart';
import '../../../../core/di.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/university_remote_data_source.dart';
import '../../data/repositories/university_repository_impl.dart';
import '../../domain/entities/university.dart';
import '../../domain/repositories/university_repository.dart';

part 'university_provider.g.dart';

@Riverpod(keepAlive: true)
UniversityRemoteDataSource universityRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UniversityRemoteDataSourceImpl(apiClient: apiClient);
}

@Riverpod(keepAlive: true)
UniversityRepository universityRepository(Ref ref) {
  final remoteDataSource = ref.watch(universityRemoteDataSourceProvider);
  return UniversityRepositoryImpl(remoteDataSource: remoteDataSource);
}

@Riverpod(keepAlive: true)
Future<List<University>> allUniversities(Ref ref) async {
  final repository = ref.watch(universityRepositoryProvider);
  final result = await repository.getUniversities();
  return result.fold(
    (failure) => throw failure,
    (universities) => universities,
  );
}

@Riverpod(keepAlive: true)
Future<University> myUniversity(Ref ref) async {
  final user = await ref.watch(currentUserProvider.future);

  if (user == null) throw Exception('User not logged in');

  final universities = await ref.watch(allUniversitiesProvider.future);

  try {
    return universities.firstWhere((u) => u.id == user.universityId);
  } catch (e) {
    throw Exception('University not found for user: ${user.universityId}');
  }
}

@Riverpod(keepAlive: true)
Future<List<String>> halls(Ref ref) async {
  final university = await ref.watch(myUniversityProvider.future);
  final repository = ref.watch(universityRepositoryProvider);
  final result = await repository.getHalls(university.id);
  return result.fold(
    (failure) => throw failure,
    (halls) => halls.map((h) => h.name).toList(),
  );
}

@riverpod
Future<University?> universityById(Ref ref, String id) async {
  final universities = await ref.watch(allUniversitiesProvider.future);
  try {
    return universities.firstWhere((u) => u.id == id);
  } catch (_) {
    return null;
  }
}

@riverpod
String universityName(Ref ref, String id) {
  final universityAsync = ref.watch(universityByIdProvider(id));
  return universityAsync.when(
    data: (u) => u?.name ?? id,
    loading: () => 'Loading...',
    error: (_, _) => id,
  );
}

@riverpod
Future<List<Hall>> hallsByUniversity(Ref ref, String universityId) async {
  final repository = ref.watch(universityRepositoryProvider);
  final result = await repository.getHalls(universityId);
  return result.fold((failure) => throw failure, (halls) => halls);
}

@riverpod
String hallName(Ref ref, {required String universityId, required String hallId}) {
  final hallsAsync = ref.watch(hallsByUniversityProvider(universityId));
  return hallsAsync.when(
    data: (halls) {
      try {
        return halls.firstWhere((h) => h.id == hallId).name;
      } catch (_) {
        return 'N/A';
      }
    },
    loading: () => 'Loading...',
    error: (_, _) => 'N/A',
  );
}

// Compatibility Aliases
final universityProvider = myUniversityProvider;
final universitiesListProvider = allUniversitiesProvider;
