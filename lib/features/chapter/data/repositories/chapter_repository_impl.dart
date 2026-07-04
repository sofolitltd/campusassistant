import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/chapter.dart';
import '../../domain/repositories/chapter_repository.dart';
import '../datasources/chapter_remote_data_source.dart';
import '../models/chapter_model.dart';

class ChapterRepositoryImpl implements ChapterRepository {
  final ChapterRemoteDataSource remoteDataSource;

  ChapterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Chapter>>> getChapters(
    String courseCode, {
    String? batchId,
  }) async {
    try {
      final chapters = await remoteDataSource.getChapters(
        courseCode,
        batchId: batchId,
      );
      return Right(chapters.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Chapter>> createChapter(Chapter chapter) async {
    try {
      final model = ChapterModel.fromEntity(chapter);
      final result = await remoteDataSource.createChapter(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Chapter>> updateChapter(Chapter chapter) async {
    try {
      final model = ChapterModel.fromEntity(chapter);
      final result = await remoteDataSource.updateChapter(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteChapter(String id) async {
    try {
      await remoteDataSource.deleteChapter(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
