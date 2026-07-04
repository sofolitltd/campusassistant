import '../entities/student.dart';

class PaginatedStudents {
  final List<Student> students;
  final int total;
  PaginatedStudents({required this.students, required this.total});
}

abstract class StudentRepository {
  Future<PaginatedStudents> getStudents({
    String? universityId,
    String? departmentId,
    String? batchId,
    String? userId,
    String? search,
    String? bloodGroup,
    int? limit,
    int? offset,
  });
  Future<Student?> getStudentByAcademicId(String studentId);
  Future<Student> createStudent(Student student);
  Future<Student> verifyCode(String code);
  Future<Student> claimProfile({
    required String code,
    required String userId,
    String? studentId,
    String? phone,
    String? bloodGroup,
    String? hallId,
    String? batchId,
    String? sessionId,
    String? departmentId,
    String? universityId,
  });
  Future<Student> updateStudent(Student student);
  Future<void> deleteStudent(String id);
}
