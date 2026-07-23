class LostFoundCategory {
  final String id;
  final String name;
  final String iconKey;
  final int index;

  LostFoundCategory({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.index,
  });

  factory LostFoundCategory.fromJson(Map<String, dynamic> json) {
    return LostFoundCategory(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      iconKey: json['icon_key'] as String? ?? 'Package',
      index: json['index'] as int? ?? 0,
    );
  }
}
