class ResearchModel {
  final String id;
  final String author;
  final String department;
  final String fileUrl;
  final String title;
  final String type;
  final String university;
  final String uploadDate;
  final String webUrl;

  ResearchModel({
    required this.id,
    required this.author,
    required this.department,
    required this.fileUrl,
    required this.title,
    required this.type,
    required this.university,
    required this.uploadDate,
    required this.webUrl,
  });

  // -------------------------------
  // Factory: From Firestore Document
  // -------------------------------
  factory ResearchModel.fromJson(Map<String, dynamic> data) {
    return ResearchModel(
      id: data['id'] ?? '',
      author: data['author'] ?? '',
      department: data['department'] ?? '',
      fileUrl: data['fileUrl'] ?? '',
      title: data['title'] ?? '',
      type: data['type'] ?? '',
      university: data['university'] ?? '',
      uploadDate: data['uploadDate'] ?? '',
      webUrl: data['webUrl'] ?? "",
    );
  }

  // -------------------------------
  // Convert Model → Map
  // -------------------------------
  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'department': department,
      'fileUrl': fileUrl,
      'title': title,
      'type': type,
      'university': university,
      'uploadDate': uploadDate,
      'webUrl': webUrl,
    };
  }
}
