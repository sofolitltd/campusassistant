/// Mirrors backend domain.AssociationPost / ClubPost's shape.
class AssociationPost {
  final String id;
  final String associationId;
  final String authorId;
  final String title;
  final String body;
  final String imageUrl;
  final DateTime createdAt;

  AssociationPost({
    required this.id,
    required this.associationId,
    required this.authorId,
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.createdAt,
  });

  factory AssociationPost.fromJson(Map<String, dynamic> json) {
    return AssociationPost(
      id: json['id'] as String,
      associationId: json['association_id'] as String? ?? '',
      authorId: json['author_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
