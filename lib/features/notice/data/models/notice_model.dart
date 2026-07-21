class NoticeModel {
  final String id;
  final String uploader;
  final String message;
  final List<String> imageUrl;
  final String time;
  final int likesCount;
  final int commentsCount;
  final int viewsCount;
  final bool isLiked;

  NoticeModel({
    required this.id,
    required this.uploader,
    required this.message,
    required this.imageUrl,
    required this.time,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.viewsCount = 0,
    this.isLiked = false,
  });

  // fetch
  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'] as String? ?? '',
      uploader: json['uploader'] as String? ?? '',
      message: json['message'] as String? ?? '',
      imageUrl: List<String>.from(json['image_urls'] ?? []),
      time: json['created_at'] as String? ?? '',
      likesCount: json['likes_count'] as int? ?? 0,
      commentsCount: json['comments_count'] as int? ?? 0,
      viewsCount: json['views_count'] as int? ?? 0,
    );
  }

  // cache
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uploader': uploader,
      'message': message,
      'image_urls': imageUrl,
      'created_at': time,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'views_count': viewsCount,
    };
  }

  NoticeModel copyWith({bool? isLiked}) {
    return NoticeModel(
      id: id,
      uploader: uploader,
      message: message,
      imageUrl: imageUrl,
      time: time,
      likesCount: likesCount,
      commentsCount: commentsCount,
      viewsCount: viewsCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
