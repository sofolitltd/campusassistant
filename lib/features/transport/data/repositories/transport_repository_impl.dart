import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/transport.dart';
import '../../domain/repositories/transport_repository.dart';
import '../datasources/transport_remote_data_source.dart';

class TransportRepositoryImpl implements TransportRepository {
  final TransportRemoteDataSource remoteDataSource;

  TransportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Transport>>> getTransports({
    required String universityId,
  }) async {
    try {
      final remoteTransports = await remoteDataSource.getTransports(
        universityId: universityId,
      );
      return Right(remoteTransports.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
