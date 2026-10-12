/// A short-lived, batch-scoped announcement (e.g. "tomorrow's class is
/// cancelled"). Plain class rather than freezed: read-only, no copyWith needs.
class ClassNotice {
  final String id;
  final String title;
  final String message;
  final String fileUrl;

  /// `image`, `pdf`, or empty for a text-only notice.
  final String fileType;
  final String? batchId;
  final DateTime? expiresAt;
  final String postedByName;
  final DateTime createdAt;

  const ClassNotice({
    required this.id,
    required this.title,
    required this.message,
    required this.fileUrl,
    required this.fileType,
    required this.batchId,
    required this.expiresAt,
    required this.postedByName,
    required this.createdAt,
  });

  bool get isImage => fileUrl.isNotEmpty && fileType == 'image';
  bool get isPdf => fileUrl.isNotEmpty && fileType == 'pdf';

  factory ClassNotice.fromJson(Map<String, dynamic> json) => ClassNotice(
    id: json['id'] as String,
    title: json['title'] as String? ?? '',
    message: json['message'] as String? ?? '',
    fileUrl: json['file_url'] as String? ?? '',
    fileType: json['file_type'] as String? ?? '',
    batchId: json['batch_id'] as String?,
    expiresAt: json['expires_at'] == null
        ? null
        : DateTime.parse(json['expires_at'] as String).toLocal(),
    postedByName: json['posted_by_name'] as String? ?? '',
    createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
  );
}
