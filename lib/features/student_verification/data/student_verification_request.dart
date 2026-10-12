/// A user's request to be verified as a student by document review — the
/// alternative to joining with a CR-issued verification code.
class StudentVerificationRequest {
  final String id;
  final String status; // pending | approved | rejected
  final String universityId;
  final String departmentId;
  final String batchId;
  final String sessionId;
  final String studentId;
  final String name;
  final String phone;
  final String secondDocType; // registration_card | certificate
  final String? rejectionReason;
  final String? universityName;
  final String? departmentName;
  final String? batchName;
  final String? sessionName;
  final DateTime createdAt;

  const StudentVerificationRequest({
    required this.id,
    required this.status,
    required this.universityId,
    required this.departmentId,
    required this.batchId,
    required this.sessionId,
    required this.studentId,
    required this.name,
    required this.phone,
    required this.secondDocType,
    required this.createdAt,
    this.rejectionReason,
    this.universityName,
    this.departmentName,
    this.batchName,
    this.sessionName,
  });

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';

  factory StudentVerificationRequest.fromJson(Map<String, dynamic> json) {
    String? nameOf(String key) =>
        (json[key] as Map<String, dynamic>?)?['name'] as String?;

    return StudentVerificationRequest(
      id: json['id'] as String,
      status: json['status'] as String? ?? 'pending',
      universityId: json['university_id'] as String? ?? '',
      departmentId: json['department_id'] as String? ?? '',
      batchId: json['batch_id'] as String? ?? '',
      sessionId: json['session_id'] as String? ?? '',
      studentId: json['student_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      secondDocType: json['second_doc_type'] as String? ?? 'registration_card',
      rejectionReason: json['rejection_reason'] as String?,
      universityName: nameOf('university'),
      departmentName: nameOf('department'),
      batchName: nameOf('batch'),
      sessionName: nameOf('session'),
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
