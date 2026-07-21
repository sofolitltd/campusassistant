class NoticeCommentModel {
  final String id;
  final String content;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final DateTime createdAt;

  NoticeCommentModel({
    required this.id,
    required this.content,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.createdAt,
  });

  factory NoticeCommentModel.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    return NoticeCommentModel(
      id: json['id'] as String? ?? '',
      content: json['content'] as String? ?? '',
      authorId: json['author_id'] as String? ?? '',
      authorName: author != null
          ? '${author['first_name'] ?? ''} ${author['last_name'] ?? ''}'.trim()
          : 'Anonymous',
      authorAvatar: author?['avatar_url'] as String?,
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
