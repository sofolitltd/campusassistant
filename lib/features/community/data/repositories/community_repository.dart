import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '/core/cache/cache_manager.dart';
import '/core/cache/connectivity_service.dart';
import '/core/network/api_client.dart';
import '/core/network/api_endpoints.dart';
import '/core/websocket/websocket_service.dart';
import '/features/community/data/models/community_post.dart';
import '/features/community/data/models/community_comment.dart';

class CommunityRepository {
  final ApiClient apiClient;
  final CacheManager cacheManager;
  final ConnectivityService connectivity;
  final WebSocketService? webSocketService;

  CommunityRepository(
    this.apiClient, {
    required this.cacheManager,
    required this.connectivity,
    this.webSocketService,
  });

  /// Stream controller for real-time post updates.
  final _postUpdateController = StreamController<CommunityPost>.broadcast();
  Stream<CommunityPost> get onPostUpdate => _postUpdateController.stream;

  /// Subscribe to real-time community updates via WebSocket.
  void subscribeToRealtime() {
    webSocketService?.messages.listen((msg) {
      if (msg.type == 'new_post' && msg.data != null) {
        try {
          final post = CommunityPost.fromJson(msg.data!);
          _postUpdateController.add(post);
        } catch (e) {
          debugPrint('[CommunityRepo] Failed to parse WS post: $e');
        }
      }
    });
    webSocketService?.subscribe('community');
  }

  Future<List<CommunityPost>> getPosts(String scope, {int page = 1}) async {
    final cacheKey = 'community_${scope}_page_$page';
    // Saved/Liked change frequently on save/unsave/like — never cache them.
    final cacheable = scope != 'saved' && scope != 'liked';

    // 1. Try remote if online
    if (connectivity.isConnected) {
      try {
        final response = await apiClient.get(
          ApiEndpoints.communityPosts,
          queryParameters: {'scope': scope, 'page': page, 'page_size': 20},
        );
        final List<dynamic> data = response.data ?? [];
        final posts = data.map((json) => CommunityPost.fromJson(json)).toList();

        // Cache first page only
        if (cacheable && page == 1) {
          await cacheManager.cacheList(
            entityType: cacheKey,
            items: data.cast<Map<String, dynamic>>(),
            ttl: CacheTTL.community,
          );
        }

        return posts;
      } catch (e) {
        debugPrint('[CommunityRepo] Remote fetch failed: $e');
      }
    }

    // 2. Try cache (first page only)
    if (cacheable && page == 1) {
      try {
        final cachedData = await cacheManager.getCachedList(
          entityType: cacheKey,
        );
        if (cachedData.isNotEmpty) {
          debugPrint(
            '[CommunityRepo] Returning ${cachedData.length} cached posts',
          );
          return cachedData
              .map((json) => CommunityPost.fromJson(json))
              .toList();
        }
      } catch (e) {
        debugPrint('[CommunityRepo] Cache read failed: $e');
      }
    }

    // 3. No data
    if (!connectivity.isConnected) {
      return [];
    }

    throw Exception('Failed to fetch community posts');
  }

  Future<List<CommunityPost>> getLikedPosts({int page = 1}) async {
    if (!connectivity.isConnected) {
      return [];
    }
    final response = await apiClient.get(
      ApiEndpoints.communityPostsLiked,
      queryParameters: {'page': page, 'page_size': 20},
    );
    final List<dynamic> data = response.data ?? [];
    return data.map((json) => CommunityPost.fromJson(json)).toList();
  }

  Future<List<CommunityPost>> getSavedPosts({int page = 1}) async {
    if (!connectivity.isConnected) {
      return [];
    }
    final response = await apiClient.get(
      ApiEndpoints.communityPostsSaved,
      queryParameters: {'page': page, 'page_size': 20},
    );
    final List<dynamic> data = response.data ?? [];
    return data.map((json) => CommunityPost.fromJson(json)).toList();
  }

  Future<CommunityPost> createPost(
    String content,
    String scope, {
    List<Uint8List> images = const [],
  }) async {
    if (!connectivity.isConnected) {
      throw Exception('Internet connection required to create a post');
    }

    if (images.isEmpty) {
      final response = await apiClient.post(
        ApiEndpoints.communityPosts,
        data: {'content': content, 'scope': scope},
      );
      return CommunityPost.fromJson(response.data);
    }

    final formData = FormData.fromMap({
      'content': content,
      'scope': scope,
      'images': images
          .asMap()
          .entries
          .map(
            (e) => MultipartFile.fromBytes(
              e.value,
              filename: 'community_image_${e.key}.jpg',
            ),
          )
          .toList(),
    });

    final response = await apiClient.post(
      ApiEndpoints.communityPosts,
      data: formData,
    );
    return CommunityPost.fromJson(response.data);
  }

  Future<void> likePost(String id) async {
    if (!connectivity.isConnected) {
      throw Exception('Internet connection required');
    }
    await apiClient.post(ApiEndpoints.communityLike(id));
  }

  Future<void> unlikePost(String id) async {
    if (!connectivity.isConnected) {
      throw Exception('Internet connection required');
    }
    await apiClient.post(ApiEndpoints.communityUnlike(id));
  }

  Future<void> savePost(String id) async {
    if (!connectivity.isConnected) {
      throw Exception('Internet connection required');
    }
    await apiClient.post(
      ApiEndpoints.communitySave(id),
      data: {'entity_type': 'community_post', 'entity_id': id},
    );
  }

  Future<void> unsavePost(String id) async {
    if (!connectivity.isConnected) {
      throw Exception('Internet connection required');
    }
    await apiClient.post(ApiEndpoints.communityUnsave(id));
  }

  Future<List<CommunityComment>> getComments(String postId) async {
    if (!connectivity.isConnected) {
      return [];
    }
    final response = await apiClient.get(
      ApiEndpoints.communityComments(postId),
    );
    final List<dynamic> data = response.data ?? [];
    return data.map((json) => CommunityComment.fromJson(json)).toList();
  }

  Future<CommunityComment> addComment(
    String postId,
    String content, {
    String? parentId,
  }) async {
    if (!connectivity.isConnected) {
      throw Exception('Internet connection required to add a comment');
    }
    final response = await apiClient.post(
      ApiEndpoints.communityComments(postId),
      data: {'content': content, 'parent_id': parentId},
    );
    return CommunityComment.fromJson(response.data);
  }

  Future<void> likeComment(String id) async {
    if (!connectivity.isConnected) {
      throw Exception('Internet connection required');
    }
    await apiClient.post(ApiEndpoints.communityCommentLike(id));
  }

  Future<void> unlikeComment(String id) async {
    if (!connectivity.isConnected) {
      throw Exception('Internet connection required');
    }
    await apiClient.post(ApiEndpoints.communityCommentUnlike(id));
  }

  Future<void> updateComment(String id, String content) async {
    if (!connectivity.isConnected) {
      throw Exception('Internet connection required');
    }
    await apiClient.put(
      ApiEndpoints.communityCommentDetail(id),
      data: {'content': content},
    );
  }

  Future<void> deleteComment(String id) async {
    if (!connectivity.isConnected) {
      throw Exception('Internet connection required');
    }
    await apiClient.delete(ApiEndpoints.communityCommentDetail(id));
  }

  Future<void> deletePost(String id) async {
    if (!connectivity.isConnected) {
      throw Exception('Internet connection required to delete post');
    }
    await apiClient.delete(ApiEndpoints.communityPostDetail(id));
    for (final scope in ['batch', 'department', 'university']) {
      await cacheManager.invalidate('community_${scope}_page_1');
    }
  }

  Future<CommunityPost> updatePost(String id, String content) async {
    if (!connectivity.isConnected) {
      throw Exception('Internet connection required to edit post');
    }
    final response = await apiClient.put(
      ApiEndpoints.communityPostDetail(id),
      data: {'content': content},
    );
    return CommunityPost.fromJson(response.data);
  }

  void dispose() {
    _postUpdateController.close();
  }
}
