import 'package:dartz/dartz.dart';
import '/core/error/failures.dart' show Failure, ServerFailure;
import '../datasources/reward_remote_data_source.dart';
import '../models/reward_balance.dart';
import '../models/reward_transaction.dart';

abstract class RewardRepository {
  Future<Either<Failure, RewardBalance>> getBalance();
  Future<Either<Failure, RewardBalance>> earn();
  Future<Either<Failure, Map<String, dynamic>>> spend(String resourceId);
  Future<Either<Failure, ({List<RewardTransaction> data, int count})>>
      getTransactions({int limit, int offset});
  Future<Either<Failure, int>> getCost(String resourceId);
}

class RewardRepositoryImpl implements RewardRepository {
  final RewardRemoteDataSource remoteDataSource;

  RewardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, RewardBalance>> getBalance() async {
    try {
      final result = await remoteDataSource.getBalance();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RewardBalance>> earn() async {
    try {
      final result = await remoteDataSource.earn();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> spend(
    String resourceId,
  ) async {
    try {
      final result = await remoteDataSource.spend(resourceId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ({List<RewardTransaction> data, int count})>>
      getTransactions({int limit = 20, int offset = 0}) async {
    try {
      final result =
          await remoteDataSource.getTransactions(limit: limit, offset: offset);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getCost(String resourceId) async {
    try {
      final result = await remoteDataSource.getCost(resourceId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
