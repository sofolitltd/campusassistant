/// Lightweight poster summary shown on a peer-shared Job card.
class CareerUser {
  final String id;
  final String name;
  final String? avatarUrl;

  CareerUser({required this.id, required this.name, this.avatarUrl});

  factory CareerUser.fromJson(Map<String, dynamic> json) {
    final first = json['first_name']?.toString() ?? '';
    final last = json['last_name']?.toString() ?? '';
    final name = '$first $last'.trim();
    return CareerUser(
      id: json['id'] as String? ?? '',
      name: name.isEmpty ? 'Student' : name,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}
