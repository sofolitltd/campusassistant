import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di.dart';
import '../../data/datasources/transport_remote_data_source.dart';
import '../../data/repositories/transport_repository_impl.dart';
import '../../domain/entities/transport.dart';
import '../../domain/repositories/transport_repository.dart';
import '../../domain/usecases/get_transports.dart';
import '../../../university/presentation/providers/university_provider.dart';

// Datasource
final transportRemoteDataSourceProvider = Provider<TransportRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return TransportRemoteDataSourceImpl(apiClient: apiClient);
});

// Repository
final transportRepositoryProvider = Provider<TransportRepository>((ref) {
  final remoteDataSource = ref.watch(transportRemoteDataSourceProvider);
  return TransportRepositoryImpl(remoteDataSource: remoteDataSource);
});

// UseCase
final getTransportsProvider = Provider<GetTransports>((ref) {
  final repository = ref.watch(transportRepositoryProvider);
  return GetTransports(repository);
});

// Presentation Providers
final myTransportsProvider = FutureProvider<List<Transport>>((ref) async {
  final university = await ref.watch(myUniversityProvider.future);

  final getTransports = ref.watch(getTransportsProvider);
  final result = await getTransports(
    GetTransportsParams(universityId: university.id),
  );

  return result.fold((failure) => throw failure, (transports) => transports);
});
