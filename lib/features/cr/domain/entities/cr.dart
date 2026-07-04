class Cr {
  final String id;
  final String universityId;
  final String departmentId;
  final String? userId;
  final String? targetStudentId;
  final String? studentId;
  final String name;
  final String email;
  final String phone;
  final String batchId;
  final String batch;
  final String? termStart;
  final String? termEnd;
  final String fb;
  final String imageUrl;
  final bool isCurrent;

  Cr({
    required this.id,
    required this.universityId,
    required this.departmentId,
    this.userId,
    this.targetStudentId,
    this.studentId,
    required this.name,
    required this.email,
    required this.phone,
    required this.batchId,
    required this.batch,
    this.termStart,
    this.termEnd,
    required this.fb,
    required this.imageUrl,
    required this.isCurrent,
  });
}
