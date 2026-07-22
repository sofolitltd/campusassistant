class Faculty {
  final String id;
  final String name;
  final String slug;
  final String universityId;

  Faculty({
    required this.id,
    required this.name,
    required this.slug,
    required this.universityId,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String? ?? '',
      universityId: json['university_id'] as String? ?? '',
    );
  }
}
