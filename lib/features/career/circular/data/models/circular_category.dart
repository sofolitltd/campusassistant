class CircularCategory {
  final String id;
  final String name;
  final String iconKey;
  final int index;

  CircularCategory({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.index,
  });

  factory CircularCategory.fromJson(Map<String, dynamic> json) {
    return CircularCategory(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      iconKey: json['icon_key'] as String? ?? 'Briefcase',
      index: json['index'] as int? ?? 0,
    );
  }
}
