/// Mirrors backend domain.AssociationEvent / ClubEvent's shape.
class AssociationEvent {
  final String id;
  final String associationId;
  final String title;
  final String description;
  final String imageUrl;
  final String location;
  final DateTime startAt;
  final DateTime? endAt;

  AssociationEvent({
    required this.id,
    required this.associationId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.startAt,
    this.endAt,
  });

  factory AssociationEvent.fromJson(Map<String, dynamic> json) {
    return AssociationEvent(
      id: json['id'] as String,
      associationId: json['association_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      location: json['location'] as String? ?? '',
      startAt: DateTime.parse(json['start_at'] as String),
      endAt: json['end_at'] != null
          ? DateTime.parse(json['end_at'] as String)
          : null,
    );
  }
}
