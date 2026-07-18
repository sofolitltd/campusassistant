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
  final List<String> imageUrls;
  final String? authorUniversity;
  final String? authorDepartment;
  final String? authorBatch;
  final String? authorSession;

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
    this.imageUrls = const [],
    this.authorUniversity,
    this.authorDepartment,
    this.authorBatch,
    this.authorSession,
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    final student = author?['student'] as Map<String, dynamic>?;
    String? orgName(Map<String, dynamic>? student, String key) {
      final rel = student?[key] as Map<String, dynamic>?;
      return rel?['name']?.toString();
    }
    final rawImages = json['image_urls'];
    final List<String> images = switch (rawImages) {
      List list => list
          .map(
            (e) => switch (e) {
              String s => s,
              Map m => (m['url'] ?? m['image_url'] ?? '').toString(),
              _ => '',
            },
          )
          .where((e) => e.isNotEmpty)
          .toList(),
      _ => const <String>[],
    };
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
      imageUrls: images,
      authorUniversity: orgName(student, 'university'),
      authorDepartment: orgName(student, 'department'),
      authorBatch: orgName(student, 'batch'),
      authorSession: orgName(student, 'session'),
    );
  }
}
