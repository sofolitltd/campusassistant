import '../../domain/entities/cr.dart';

class CrModel extends Cr {
  CrModel({
    required super.id,
    required super.universityId,
    required super.departmentId,
    super.userId,
    super.targetStudentId,
    super.studentId,
    required super.name,
    required super.email,
    required super.phone,
    required super.batchId,
    required super.batch,
    super.termStart,
    super.termEnd,
    required super.fb,
    required super.imageUrl,
    required super.isCurrent,
  });

  factory CrModel.fromJson(Map<String, dynamic> json) {
    return CrModel(
      id: (json['id'] ?? '').toString(),
      universityId: (json['university_id'] ?? '').toString(),
      departmentId: (json['department_id'] ?? '').toString(),
      userId: json['user_id']?.toString(),
      targetStudentId: json['target_student_id']?.toString(),
      studentId: json['student_id']?.toString(),
      name: (json['name'] ?? '').toString(),
      batchId: (json['batch_id'] ?? '').toString(),
      batch: (json['batch'] ?? '').toString(),
      termStart: json['term_start']?.toString(),
      termEnd: json['term_end']?.toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      fb: (json['fb'] ?? '').toString(),
      imageUrl: (json['image_url'] ?? '').toString(),
      isCurrent: (json['is_current'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'university_id': universityId,
      'department_id': departmentId,
      if (userId != null) 'user_id': userId,
      if (targetStudentId != null) 'target_student_id': targetStudentId,
      if (studentId != null) 'student_id': studentId,
      'name': name,
      'batch_id': batchId,
      'batch': batch,
      if (termStart != null) 'term_start': termStart,
      if (termEnd != null) 'term_end': termEnd,
      'email': email,
      'phone': phone,
      'fb': fb,
      'image_url': imageUrl,
      'is_current': isCurrent,
    };
  }
}
