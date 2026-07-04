import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../models/bookmark_model.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final ApiClient apiClient;

  BookmarkRepositoryImpl({required this.apiClient});

  @override
  Future<Either<Failure, List<Bookmark>>> getBookmarks(String userId) async {
    try {
      final response = await apiClient.get(
        '/bookmarks',
        queryParameters: {'user_id': userId},
      );
      final List<dynamic> data = response.data;
      final bookmarks = data
          .map((json) => BookmarkModel.fromJson(json))
          .toList();
      return Right(List<Bookmark>.from(bookmarks));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addBookmark(Bookmark bookmark) async {
    try {
      final model = BookmarkModel(
        id: bookmark.id,
        userId: bookmark.userId,
        entityType: bookmark.entityType,
        entityId: bookmark.entityId,
      );
      await apiClient.post('/bookmarks', data: model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeBookmark(String id) async {
    try {
      await apiClient.delete('/bookmarks/$id');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, dynamic>> getEntityDetail(
    String entityType,
    String entityId,
  ) async {
    try {
      final String path = _getPluralPath(entityType);
      final response = await apiClient.get('/$path/$entityId');
      return Right(response.data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  String _getPluralPath(String type) {
    switch (type.toLowerCase()) {
      case 'resource':
        return 'resources';
      case 'teacher':
        return 'teachers';
      case 'alumni':
        return 'alumni';
      case 'staff':
        return 'staffs';
      case 'university':
        return 'universities';
      case 'department':
        return 'departments';
      default:
        return '${type}s';
    }
  }
}
