class NoticeModel {
  final String uploader;
  final String message;
  final List<String> imageUrl;
  final List<String> batch;
  final List<String> seen;
  final String time;

  NoticeModel({
    required this.uploader,
    required this.batch,
    required this.message,
    required this.imageUrl,
    required this.seen,
    required this.time,
  });

  // fetch
  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      uploader: json['uploader'] as String? ?? '',
      message: json['message'] as String? ?? '',
      imageUrl: List<String>.from(json['imageUrl'] ?? []),
      batch: List<String>.from(json['batch'] ?? []),
      seen: List<String>.from(json['seen'] ?? []),
      time: json['time'] as String? ?? '',
    );
  }

  // upload
  Map<String, dynamic> toJson() {
    return {
      'uploader': uploader,
      'message': message,
      'imageUrl': imageUrl,
      'batch': batch,
      'seen': seen,
      'time': time,
    };
  }
}
