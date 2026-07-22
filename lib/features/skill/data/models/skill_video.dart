class SkillVideo {
  final String id;
  final String skillId;
  final String youtubeUrl;
  final String title;
  final String thumbnailUrl;
  final String duration;
  final int index;

  SkillVideo({
    required this.id,
    required this.skillId,
    required this.youtubeUrl,
    required this.title,
    required this.thumbnailUrl,
    required this.duration,
    required this.index,
  });

  factory SkillVideo.fromJson(Map<String, dynamic> json) {
    return SkillVideo(
      id: json['id'] as String,
      skillId: json['skill_id'] as String? ?? '',
      youtubeUrl: json['youtube_url'] as String? ?? '',
      title: json['title'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      index: json['index'] as int? ?? 0,
    );
  }
}
