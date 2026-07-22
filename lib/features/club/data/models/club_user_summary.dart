/// Lightweight user projection used for club rosters (Members tab,
/// follower list for promotion, managers list) — mirrors the backend's
/// domain.ClubUserSummary.
class ClubUserSummary {
  final String userId;
  final String firstName;
  final String lastName;
  final String avatarUrl;
  final String role; // only set for the managers list; empty otherwise

  ClubUserSummary({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
    this.role = '',
  });

  String get fullName => '$firstName $lastName'.trim();

  factory ClubUserSummary.fromJson(Map<String, dynamic> json) {
    return ClubUserSummary(
      userId: json['user_id'] as String,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );
  }
}
