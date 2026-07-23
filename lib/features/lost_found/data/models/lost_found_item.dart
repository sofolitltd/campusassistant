import 'lost_found_category.dart';
import 'lost_found_user.dart';

enum LostFoundType { lost, found }

enum LostFoundStatus { open, claimed, resolved, removed }

LostFoundType lostFoundTypeFromString(String? value) =>
    value == 'found' ? LostFoundType.found : LostFoundType.lost;

String lostFoundTypeToString(LostFoundType type) =>
    type == LostFoundType.found ? 'found' : 'lost';

LostFoundStatus lostFoundStatusFromString(String? value) {
  switch (value) {
    case 'claimed':
      return LostFoundStatus.claimed;
    case 'resolved':
      return LostFoundStatus.resolved;
    case 'removed':
      return LostFoundStatus.removed;
    default:
      return LostFoundStatus.open;
  }
}

class LostFoundItem {
  final String id;
  final LostFoundType type;
  final String title;
  final String description;
  final String? categoryId;
  final LostFoundCategory? category;
  final List<String> imageUrls;
  final String location;
  final DateTime? eventDate;
  final LostFoundStatus status;
  final String? removalReason;
  final DateTime? resolvedAt;
  final String posterId;
  final LostFoundUser? poster;
  final DateTime createdAt;

  LostFoundItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.categoryId,
    this.category,
    this.imageUrls = const [],
    required this.location,
    this.eventDate,
    required this.status,
    this.removalReason,
    this.resolvedAt,
    required this.posterId,
    this.poster,
    required this.createdAt,
  });

  factory LostFoundItem.fromJson(Map<String, dynamic> json) {
    final categoryJson = json['category'] as Map<String, dynamic>?;
    final posterJson = json['poster'] as Map<String, dynamic>?;
    final imageUrlsJson = json['image_urls'] as List? ?? [];

    return LostFoundItem(
      id: json['id'] as String? ?? '',
      type: lostFoundTypeFromString(json['type'] as String?),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      categoryId: json['category_id'] as String?,
      category: categoryJson != null && (categoryJson['id'] as String?)?.isNotEmpty == true
          ? LostFoundCategory.fromJson(categoryJson)
          : null,
      imageUrls: imageUrlsJson.map((e) => e.toString()).toList(),
      location: json['location'] as String? ?? '',
      eventDate: json['event_date'] != null
          ? DateTime.tryParse(json['event_date'].toString())
          : null,
      status: lostFoundStatusFromString(json['status'] as String?),
      removalReason: json['removal_reason'] as String?,
      resolvedAt: json['resolved_at'] != null
          ? DateTime.tryParse(json['resolved_at'].toString())
          : null,
      posterId: json['poster_id'] as String? ?? '',
      poster: posterJson != null && (posterJson['id'] as String?)?.isNotEmpty == true
          ? LostFoundUser.fromJson(posterJson)
          : null,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toCreateJson({
    required List<Map<String, String>> targets,
  }) {
    return {
      'type': lostFoundTypeToString(type),
      'title': title,
      'description': description,
      if (categoryId != null && categoryId!.isNotEmpty) 'category_id': categoryId,
      'image_urls': imageUrls,
      'location': location,
      // Go's time.Time JSON unmarshal requires an RFC3339 offset/Z suffix,
      // which a bare local DateTime.toIso8601String() lacks — send UTC.
      if (eventDate != null) 'event_date': eventDate!.toUtc().toIso8601String(),
      'targets': targets,
    };
  }
}
