import 'circular_category.dart';

class CareerCircular {
  final String id;
  final String title;
  final String organization;
  final String? categoryId;
  final CircularCategory? category;
  final String description;
  final List<String> attachmentUrls;
  final String postLink;
  final String resourceLink;
  final DateTime? publishDate;
  final DateTime? deadlineDate;
  final int viewsCount;
  final DateTime createdAt;

  CareerCircular({
    required this.id,
    required this.title,
    required this.organization,
    this.categoryId,
    this.category,
    required this.description,
    this.attachmentUrls = const [],
    required this.postLink,
    required this.resourceLink,
    this.publishDate,
    this.deadlineDate,
    required this.viewsCount,
    required this.createdAt,
  });

  bool get isPastDeadline =>
      deadlineDate != null && deadlineDate!.isBefore(DateTime.now());

  factory CareerCircular.fromJson(Map<String, dynamic> json) {
    final categoryJson = json['category'] as Map<String, dynamic>?;
    final attachmentsJson = json['attachment_urls'] as List? ?? [];

    return CareerCircular(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      organization: json['organization'] as String? ?? '',
      categoryId: json['category_id'] as String?,
      category: categoryJson != null && (categoryJson['id'] as String?)?.isNotEmpty == true
          ? CircularCategory.fromJson(categoryJson)
          : null,
      description: json['description'] as String? ?? '',
      attachmentUrls: attachmentsJson.map((e) => e.toString()).toList(),
      postLink: json['post_link'] as String? ?? '',
      resourceLink: json['resource_link'] as String? ?? '',
      publishDate: json['publish_date'] != null
          ? DateTime.tryParse(json['publish_date'].toString())
          : null,
      deadlineDate: json['deadline_date'] != null
          ? DateTime.tryParse(json['deadline_date'].toString())
          : null,
      viewsCount: json['views_count'] as int? ?? 0,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
