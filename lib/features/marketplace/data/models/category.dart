class Category {
  final String id;
  final String name;
  final String imageUrl;
  final String description;

  Category({
    required this.id,
    required this.name,
    this.imageUrl = '',
    this.description = '',
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}
