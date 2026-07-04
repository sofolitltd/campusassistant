import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/bookmark.dart';

abstract class BookmarkRepository {
  Future<Either<Failure, List<Bookmark>>> getBookmarks(String userId);
  Future<Either<Failure, void>> addBookmark(Bookmark bookmark);
  Future<Either<Failure, void>> removeBookmark(String id);
  Future<Either<Failure, dynamic>> getEntityDetail(
    String entityType,
    String entityId,
  );
}
