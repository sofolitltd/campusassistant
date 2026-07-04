class ContentModel {
  final String contentId;
  final String courseCode;
  final String contentType;
  final int lessonNo;
  final String status;
  final List<String> batches;
  final String contentTitle;
  final String contentSubtitle;
  final String contentSubtitleType;
  final String uploadDate;
  final String fileUrl;
  final String imageUrl;
  final String uploader;
  final String departmentId;
  final Map<String, dynamic>? metadata;

  ContentModel({
    required this.contentId,
    required this.courseCode,
    required this.contentType,
    required this.lessonNo,
    required this.status,
    required this.batches,
    required this.contentTitle,
    required this.contentSubtitle,
    required this.contentSubtitleType,
    required this.uploadDate,
    required this.fileUrl,
    required this.imageUrl,
    required this.uploader,
    required this.departmentId,
    this.metadata,
  });

  // fetch
  ContentModel.fromJson(Map<String, dynamic> json)
    : this(
        contentId: json['contentId']! as String,
        courseCode: json['courseCode']! as String,
        contentType: json['contentType']! as String,
        lessonNo: json['lessonNo']! as int,
        status: json['status']! as String,
        batches: (json['batches']! as List).cast<String>(),
        contentTitle: json['contentTitle']! as String,
        contentSubtitle: json['contentSubtitle']! as String,
        contentSubtitleType: json['contentSubtitleType']! as String,
        uploadDate: json['uploadDate']! as String,
        fileUrl: json['fileUrl']! as String,
        imageUrl: json['imageUrl']! as String,
        uploader: json['uploader']! as String,
        departmentId: json['departmentId'] ?? '',
        metadata: json['metadata'] as Map<String, dynamic>?,
      );

  // upload
  Map<String, dynamic> toJson() {
    return {
      'contentId': contentId,
      'courseCode': courseCode,
      'contentType': contentType,
      'lessonNo': lessonNo,
      'status': status,
      'batches': batches,
      'contentTitle': contentTitle,
      'contentSubtitle': contentSubtitle,
      'contentSubtitleType': contentSubtitleType,
      'uploadDate': uploadDate,
      'fileUrl': fileUrl,
      'imageUrl': imageUrl,
      'uploader': uploader,
      'departmentId': departmentId,
      if (metadata != null) 'metadata': metadata,
    };
  }
}
