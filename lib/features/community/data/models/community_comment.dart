class CommunityComment {
  final String id;
  final String content;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final DateTime createdAt;
  final int likesCount;
  final bool isLiked;
  final List<CommunityComment> replies;

  CommunityComment({
    required this.id,
    required this.content,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.createdAt,
    this.likesCount = 0,
    this.isLiked = false,
    this.replies = const [],
  });

  factory CommunityComment.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    final repliesJson = json['replies'] as List<dynamic>?;
    return CommunityComment(
      id: json['id'],
      content: json['content'],
      authorId: json['author_id'],
      authorName: author != null ? '${author['first_name']} ${author['last_name']}' : 'Anonymous',
      authorAvatar: author?['profile_image'] ?? author?['avatar_url'],
      createdAt: DateTime.parse(json['created_at']),
      likesCount: json['likes_count'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      replies: repliesJson?.map((e) => CommunityComment.fromJson(e)).toList() ?? [],
    );
  }
}
