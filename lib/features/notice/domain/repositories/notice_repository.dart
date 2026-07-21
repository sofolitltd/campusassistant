import '../../data/models/notice_comment_model.dart';
import '../../data/models/notice_model.dart';

abstract class NoticeRepository {
  Future<List<NoticeModel>> getNotices({
    required String universityId,
    required String departmentId,
  });

  Future<List<String>> getLikedNoticeIds({required String departmentId});
  Future<void> likeNotice(String id);
  Future<void> unlikeNotice(String id);
  Future<void> viewNotice(String id);
  Future<List<NoticeCommentModel>> getComments(String noticeId);
  Future<NoticeCommentModel> addComment(String noticeId, String content);
  Future<void> deleteComment(String id);
}
