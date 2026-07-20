import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/bookmark.dart';

part 'bookmark_model.freezed.dart';
part 'bookmark_model.g.dart';

@freezed
abstract class BookmarkModel with _$BookmarkModel {
  const BookmarkModel._();

  const factory BookmarkModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'entity_type') required String entityType,
    @JsonKey(name: 'entity_id') required String entityId,
  }) = _BookmarkModel;

  factory BookmarkModel.fromJson(Map<String, dynamic> json) =>
      _$BookmarkModelFromJson(json);

  Bookmark toEntity() => Bookmark(
    id: id,
    userId: userId,
    entityType: entityType,
    entityId: entityId,
  );

  factory BookmarkModel.fromEntity(Bookmark bookmark) => BookmarkModel(
    id: bookmark.id,
    userId: bookmark.userId,
    entityType: bookmark.entityType,
    entityId: bookmark.entityId,
  );
}
