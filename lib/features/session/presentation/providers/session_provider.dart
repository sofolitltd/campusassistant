import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di.dart';
import '../../../../core/providers/app_refresh_provider.dart';
import '../../data/datasources/session_remote_data_source.dart';
import '../../data/repositories/session_repository_impl.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/session_repository.dart';
import '../../domain/usecases/create_session.dart';
import '../../domain/usecases/update_session.dart';
import '../../domain/usecases/delete_session.dart';

final sessionRemoteDataSourceProvider = Provider<SessionRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return SessionRemoteDataSourceImpl(apiClient: apiClient);
});

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  final remoteDataSource = ref.watch(sessionRemoteDataSourceProvider);
  return SessionRepositoryImpl(remoteDataSource: remoteDataSource);
});

final createSessionProvider = Provider<CreateSession>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return CreateSession(repository);
});

final updateSessionProvider = Provider<UpdateSession>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return UpdateSession(repository);
});

final deleteSessionProvider = Provider<DeleteSession>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return DeleteSession(repository);
});

final sessionsByUniversityProvider =
    FutureProvider.family<List<Session>, String>((ref, universityId) async {
      ref.watch(appRefreshProvider);
      final repository = ref.watch(sessionRepositoryProvider);
      final result = await repository.getSessions(universityId: universityId);
      return result.fold((failure) => throw failure, (sessions) => sessions);
    });

final sessionByIdProvider =
    FutureProvider.family<Session?, ({String universityId, String id})>((
      ref,
      arg,
    ) async {
      final sessions = await ref.watch(
        sessionsByUniversityProvider(arg.universityId).future,
      );
      try {
        return sessions.firstWhere((s) => s.id == arg.id);
      } catch (_) {
        return null;
      }
    });

final sessionNameProvider =
    Provider.family<String, ({String universityId, String id})>((ref, arg) {
      final sessionAsync = ref.watch(sessionByIdProvider(arg));
      return sessionAsync.when(
        data: (s) => s?.name ?? arg.id,
        loading: () => '...',
        error: (_, _) => arg.id,
      );
    });
