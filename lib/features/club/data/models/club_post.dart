class ClubPost {
  final String id;
  final String clubId;
  final String authorId;
  final String title;
  final String body;
  final String imageUrl;
  final DateTime createdAt;

  ClubPost({
    required this.id,
    required this.clubId,
    required this.authorId,
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.createdAt,
  });

  factory ClubPost.fromJson(Map<String, dynamic> json) {
    return ClubPost(
      id: json['id'] as String,
      clubId: json['club_id'] as String? ?? '',
      authorId: json['author_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
