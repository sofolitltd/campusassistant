class CommunityPost {
  final String id;
  final String content;
  final String scope;
  final int likesCount;
  final int commentsCount;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final DateTime createdAt;
  final bool isLiked;
  final bool isSaved;

  CommunityPost({
    required this.id,
    required this.content,
    required this.scope,
    required this.likesCount,
    required this.commentsCount,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.createdAt,
    this.isLiked = false,
    this.isSaved = false,
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    return CommunityPost(
      id: json['id'],
      content: json['content'],
      scope: json['scope'],
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      authorId: json['author_id'],
      authorName: author != null ? '${author['first_name']} ${author['last_name']}' : 'Anonymous',
      authorAvatar: author?['avatar_url'],
      createdAt: DateTime.parse(json['created_at']),
      isLiked: json['is_liked'] ?? false,
      isSaved: json['is_saved'] ?? false,
    );
  }
}
