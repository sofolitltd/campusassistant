import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/club.dart';
import '../../domain/repositories/club_repository.dart';
import '../datasources/club_remote_data_source.dart';

class ClubRepositoryImpl implements ClubRepository {
  final ClubRemoteDataSource remoteDataSource;

  ClubRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Club>>> getClubs({
    required String universityId,
    String? departmentId,
    required String type,
  }) async {
    try {
      final remoteClubs = await remoteDataSource.getClubs(
        universityId: universityId,
        departmentId: departmentId,
        type: type,
      );
      return Right(remoteClubs.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
