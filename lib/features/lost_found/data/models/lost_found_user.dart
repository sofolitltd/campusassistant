/// Lightweight poster/claimer summary embedded in items and claims.
class LostFoundUser {
  final String id;
  final String name;
  final String? avatarUrl;

  LostFoundUser({required this.id, required this.name, this.avatarUrl});

  factory LostFoundUser.fromJson(Map<String, dynamic> json) {
    final first = json['first_name']?.toString() ?? '';
    final last = json['last_name']?.toString() ?? '';
    final name = '$first $last'.trim();
    return LostFoundUser(
      id: json['id'] as String? ?? '',
      name: name.isEmpty ? 'Student' : name,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}
