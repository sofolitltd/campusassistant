import 'skill_video.dart';

class Skill {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final int index;
  final List<SkillVideo> videos;

  Skill({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.index,
    required this.videos,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    final videosJson = json['videos'] as List? ?? [];
    final videos = videosJson
        .map((e) => SkillVideo.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.index.compareTo(b.index));

    return Skill(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String? ?? '',
      index: json['index'] as int? ?? 0,
      videos: videos,
    );
  }
}
