class ClubEvent {
  final String id;
  final String clubId;
  final String title;
  final String description;
  final String imageUrl;
  final String location;
  final DateTime startAt;
  final DateTime? endAt;

  ClubEvent({
    required this.id,
    required this.clubId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.startAt,
    this.endAt,
  });

  factory ClubEvent.fromJson(Map<String, dynamic> json) {
    return ClubEvent(
      id: json['id'] as String,
      clubId: json['club_id'] as String? ?? '',
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
