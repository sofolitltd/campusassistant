import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String get baseUrl {
    String url = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080/api/v1';

    // If we're on Android emulator and the URL uses localhost,
    // we need to use 10.0.2.2 to access the host machine.
    if (!kIsWeb && Platform.isAndroid && url.contains('localhost')) {
      return url.replaceFirst('localhost', '10.0.2.2');
    }
    return url;
  }

  static String resolveImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';

    String resolvedUrl = url;
    if (!resolvedUrl.startsWith('http')) {
      // Relative path, prepend base URL (without /api/v1)
      final base = baseUrl.replaceAll('/api/v1', '');
      resolvedUrl =
          '$base${resolvedUrl.startsWith('/') ? '' : '/'}$resolvedUrl';
    }

    // Android emulator localhost replacement
    if (!kIsWeb && Platform.isAndroid) {
      if (resolvedUrl.contains('localhost')) {
        resolvedUrl = resolvedUrl.replaceFirst('localhost', '10.0.2.2');
      } else if (resolvedUrl.contains('127.0.0.1')) {
        resolvedUrl = resolvedUrl.replaceFirst('127.0.0.1', '10.0.2.2');
      }
    }

    // Proxy R2 images through the backend in two cases: local/emulator dev
    // (to bypass emulator internet/DNS resolution limitations), and web
    // (browsers enforce CORS when canvaskit/skwasm decodes cross-origin
    // images; native apps never do, and the R2 bucket has no CORS policy
    // set — the backend's /proxy route sends Access-Control-Allow-Origin: *).
    final isLocal =
        baseUrl.contains('10.0.2.2') ||
        baseUrl.contains('localhost') ||
        baseUrl.contains('127.0.0.1');
    if ((isLocal || kIsWeb) && resolvedUrl.contains('r2.dev')) {
      resolvedUrl = '$baseUrl/proxy?url=${Uri.encodeComponent(resolvedUrl)}';
    }

    return resolvedUrl;
  }

  static const String universities = '/universities';
  static const String departments = '/departments';
  static const String semesters = '/levels';
  static const String levels = '/levels';
  static const String sessions = '/sessions';
  static const String batches = '/batches';
  static const String halls = '/halls';
  static const String users = '/users';
  static const String students = '/students';
  static const String resources = '/resources';
  static const String transports = '/transports';
  static const String communityPosts = '/community/posts';
  static String communityLike(String id) => '/community/posts/$id/like';
  static String communityUnlike(String id) => '/community/posts/$id/unlike';
  static String communitySave(String id) => '/community/posts/$id/save';
  static String communityUnsave(String id) => '/community/posts/$id/unsave';
  static String communityComments(String id) => '/community/posts/$id/comments';
  static String communityPostDetail(String id) => '/community/posts/$id';
  static const String communityPostsLiked = '/community/posts/liked';
  static const String communityPostsSaved = '/community/posts/saved';
  static String communityCommentLike(String id) =>
      '/community/comments/$id/like';
  static String communityCommentUnlike(String id) =>
      '/community/comments/$id/unlike';
  static String communityCommentDetail(String id) => '/community/comments/$id';
  static const String bookmarks = '/bookmarks';
  static const String clubs = '/clubs';

  // Notices
  static const String notices = '/notices';
  static String noticeLike(String id) => '/notices/$id/like';
  static String noticeUnlike(String id) => '/notices/$id/unlike';
  static String noticeView(String id) => '/notices/$id/view';
  static String noticeComments(String id) => '/notices/$id/comments';
  static String noticeCommentDetail(String id) => '/notices/comments/$id';
  static const String noticeLikedIds = '/notices/liked-ids';

  // Notifications
  static const String notifications = '/notifications';
  static String notificationRead(String id) => '/notifications/$id/read';
  static const String notificationsReadAll = '/notifications/read-all';
  static String notificationDetail(String id) => '/notifications/$id';

  // Devices (FCM push tokens)
  static const String devices = '/devices';
  static const String devicesUnregister = '/devices/unregister';
  static String deviceDetail(String id) => '/devices/$id';
  static const String devicesLogoutAll = '/devices/logout-all';
  static const String devicesLogoutOthers = '/devices/logout-others';

  // Chat
  static const String conversations = '/conversations';
  static const String conversationsContacts = '/conversations/contacts';
  static const String conversationsPending = '/conversations/pending';
  static String conversationMessages(String id) =>
      '/conversations/$id/messages';
  static String conversationRead(String id) => '/conversations/$id/read';
  static String conversationMessage(String id, String msgId) =>
      '/conversations/$id/messages/$msgId';
  static String conversationAccept(String id) => '/conversations/$id/accept';
  static String conversationBlock(String id) => '/conversations/$id/block';
  static String conversationDelete(String id) => '/conversations/$id';
  static String conversationArchive(String id) => '/conversations/$id/archive';
  static String conversationMessageDelete(String id, String msgId) =>
      '/conversations/$id/messages/$msgId';
}
