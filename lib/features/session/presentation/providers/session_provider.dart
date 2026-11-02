import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/di.dart';
import '../../../../core/providers/app_refresh_provider.dart';
import '../../data/datasources/session_remote_data_source.dart';
import '../../data/repositories/session_repository_impl.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/session_repository.dart';
import '../../domain/usecases/create_session.dart';
import '../../domain/usecases/update_session.dart';
import '../../domain/usecases/delete_session.dart';
import '../../../../core/providers/cache_for.dart';

final sessionRemoteDataSourceProvider = Provider<SessionRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return SessionRemoteDataSourceImpl(apiClient: apiClient);
});

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  final remoteDataSource = ref.watch(sessionRemoteDataSourceProvider);
  final cacheManager = ref.watch(cacheManagerProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  return SessionRepositoryImpl(
    remoteDataSource: remoteDataSource,
    cacheManager: cacheManager,
    connectivity: connectivity,
  );
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

/// Every session (global, newest first). Sessions aren't scoped to a
/// university — use `Batch.sessions` for the ones that apply to a batch.
final allSessionsProvider = FutureProvider.autoDispose<List<Session>>((
  ref,
) async {
  ref.cacheFor(kParamProviderCacheTime);
  ref.watch(appRefreshProvider);
  final repository = ref.watch(sessionRepositoryProvider);
  final result = await repository.getSessions();
  return result.fold((failure) => throw failure, (sessions) => sessions);
});

final sessionByIdProvider = FutureProvider.autoDispose.family<Session?, String>(
  (ref, id) async {
    ref.cacheFor(kParamProviderCacheTime);
    final sessions = await ref.watch(allSessionsProvider.future);
    return sessions.where((s) => s.id == id).firstOrNull;
  },
);

final sessionNameProvider = Provider.family<String, String>((ref, id) {
  final sessionAsync = ref.watch(sessionByIdProvider(id));
  return sessionAsync.when(
    data: (s) => s?.name ?? id,
    loading: () => '...',
    error: (_, _) => id,
  );
});
