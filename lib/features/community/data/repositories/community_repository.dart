import 'package:campusassistant/core/network/api_client.dart';
import 'package:campusassistant/core/network/api_endpoints.dart';
import 'package:campusassistant/features/community/data/models/community_post.dart';
import 'package:campusassistant/features/community/data/models/community_comment.dart';

class CommunityRepository {
  final ApiClient apiClient;

  CommunityRepository(this.apiClient);

  Future<List<CommunityPost>> getPosts(String scope, {int page = 1}) async {
    final response = await apiClient.get(
      ApiEndpoints.communityPosts,
      queryParameters: {
        'scope': scope,
        'page': page,
        'page_size': 20,
      },
    );
    final List<dynamic> data = response.data ?? [];
    return data.map((json) => CommunityPost.fromJson(json)).toList();
  }

  Future<CommunityPost> createPost(String content, String scope) async {
    final response = await apiClient.post(
      ApiEndpoints.communityPosts,
      data: {
        'content': content,
        'scope': scope,
      },
    );
    return CommunityPost.fromJson(response.data);
  }

  Future<void> likePost(String id) async {
    await apiClient.post(ApiEndpoints.communityLike(id));
  }

  Future<void> unlikePost(String id) async {
    await apiClient.post(ApiEndpoints.communityUnlike(id));
  }

  Future<void> savePost(String id) async {
    await apiClient.post(
      ApiEndpoints.communitySave(id),
      data: {
        'entity_type': 'community_post',
        'entity_id': id,
      },
    );
  }

  Future<void> unsavePost(String id) async {
    await apiClient.post(ApiEndpoints.communityUnsave(id));
  }

  Future<List<CommunityComment>> getComments(String postId) async {
    final response = await apiClient.get(ApiEndpoints.communityComments(postId));
    final List<dynamic> data = response.data ?? [];
    return data.map((json) => CommunityComment.fromJson(json)).toList();
  }

  Future<CommunityComment> addComment(String postId, String content, {String? parentId}) async {
    final response = await apiClient.post(
      ApiEndpoints.communityComments(postId),
      data: {
        'content': content,
        'parent_id': parentId,
      },
    );
    return CommunityComment.fromJson(response.data);
  }

  Future<void> likeComment(String id) async {
    await apiClient.post(ApiEndpoints.communityCommentLike(id));
  }

  Future<void> unlikeComment(String id) async {
    await apiClient.post(ApiEndpoints.communityCommentUnlike(id));
  }

  Future<void> updateComment(String id, String content) async {
    await apiClient.put(
      ApiEndpoints.communityCommentDetail(id),
      data: {'content': content},
    );
  }

  Future<void> deleteComment(String id) async {
    await apiClient.delete(ApiEndpoints.communityCommentDetail(id));
  }
}
