import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/university.dart';
import '../../domain/repositories/university_repository.dart';
import '../datasources/university_remote_data_source.dart';
import '../models/university_model.dart';
import '../models/hall_model.dart';
import '../../domain/entities/hall.dart';

class UniversityRepositoryImpl implements UniversityRepository {
  final UniversityRemoteDataSource remoteDataSource;

  UniversityRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<University>>> getUniversities() async {
    try {
      final remoteUniversities = await remoteDataSource.getUniversities();
      return Right(remoteUniversities.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, University>> createUniversity(
    University university,
  ) async {
    try {
      final model = UniversityModel.fromEntity(university);
      final result = await remoteDataSource.createUniversity(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, University>> updateUniversity(
    University university,
  ) async {
    try {
      final model = UniversityModel.fromEntity(university);
      final result = await remoteDataSource.updateUniversity(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUniversity(String id) async {
    try {
      await remoteDataSource.deleteUniversity(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadLogo(
    String filePath, {
    String? folder,
  }) async {
    try {
      final url = await remoteDataSource.uploadLogo(filePath, folder: folder);
      return Right(url);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadLogoBytes(
    List<int> bytes,
    String fileName, {
    String? folder,
  }) async {
    try {
      final url = await remoteDataSource.uploadLogoBytes(
        bytes,
        fileName,
        folder: folder,
      );
      return Right(url);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Hall>>> getHalls(String universityId) async {
    try {
      final halls = await remoteDataSource.getHalls(universityId);
      return Right(halls.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Hall>> createHall(Hall hall) async {
    try {
      final model = HallModel.fromEntity(hall);
      final result = await remoteDataSource.createHall(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Hall>> updateHall(Hall hall) async {
    try {
      final model = HallModel.fromEntity(hall);
      final result = await remoteDataSource.updateHall(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteHall(String id) async {
    try {
      await remoteDataSource.deleteHall(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
