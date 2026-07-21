import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/notice_comment_model.dart';
import '../models/notice_model.dart';

abstract class NoticeRemoteDataSource {
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

class NoticeRemoteDataSourceImpl implements NoticeRemoteDataSource {
  final ApiClient apiClient;

  NoticeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<NoticeModel>> getNotices({
    required String universityId,
    required String departmentId,
  }) async {
    final response = await apiClient.get(
      ApiEndpoints.notices,
      queryParameters: {
        'university_id': universityId,
        'department_id': departmentId,
      },
    );

    final Map<String, dynamic> body = response.data;
    final List<dynamic> data = body['data'] ?? [];
    return data.map((json) => NoticeModel.fromJson(json)).toList();
  }

  @override
  Future<List<String>> getLikedNoticeIds({required String departmentId}) async {
    final response = await apiClient.get(
      ApiEndpoints.noticeLikedIds,
      queryParameters: {'department_id': departmentId},
    );
    final Map<String, dynamic> body = response.data;
    final List<dynamic> data = body['data'] ?? [];
    return data.map((id) => id.toString()).toList();
  }

  @override
  Future<void> likeNotice(String id) async {
    await apiClient.post(ApiEndpoints.noticeLike(id));
  }

  @override
  Future<void> unlikeNotice(String id) async {
    await apiClient.post(ApiEndpoints.noticeUnlike(id));
  }

  @override
  Future<void> viewNotice(String id) async {
    await apiClient.post(ApiEndpoints.noticeView(id));
  }

  @override
  Future<List<NoticeCommentModel>> getComments(String noticeId) async {
    final response = await apiClient.get(ApiEndpoints.noticeComments(noticeId));
    final Map<String, dynamic> body = response.data;
    final List<dynamic> data = body['data'] ?? [];
    return data.map((json) => NoticeCommentModel.fromJson(json)).toList();
  }

  @override
  Future<NoticeCommentModel> addComment(String noticeId, String content) async {
    final response = await apiClient.post(
      ApiEndpoints.noticeComments(noticeId),
      data: {'content': content},
    );
    return NoticeCommentModel.fromJson(response.data);
  }

  @override
  Future<void> deleteComment(String id) async {
    await apiClient.delete(ApiEndpoints.noticeCommentDetail(id));
  }
}
