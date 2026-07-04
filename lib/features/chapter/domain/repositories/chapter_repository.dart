import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chapter.dart';

abstract class ChapterRepository {
  Future<Either<Failure, List<Chapter>>> getChapters(
    String courseCode, {
    String? batchId,
  });
  Future<Either<Failure, Chapter>> createChapter(Chapter chapter);
  Future<Either<Failure, Chapter>> updateChapter(Chapter chapter);
  Future<Either<Failure, void>> deleteChapter(String id);
}
