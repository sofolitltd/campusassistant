import 'package:freezed_annotation/freezed_annotation.dart';
import '../repositories/student_repository.dart';

part 'get_students.freezed.dart';

@freezed
abstract class GetStudentsParams with _$GetStudentsParams {
  const factory GetStudentsParams({
    String? universityId,
    String? departmentId,
    String? batch,
    String? search,
    String? bloodGroup,
    int? limit,
    int? offset,
  }) = _GetStudentsParams;
}

class GetStudents {
  final StudentRepository repository;

  GetStudents(this.repository);

  Future<PaginatedStudents> call(GetStudentsParams params) {
    return repository.getStudents(
      universityId: params.universityId,
      departmentId: params.departmentId,
      batchId: params.batch,
      search: params.search,
      bloodGroup: params.bloodGroup,
      limit: params.limit,
      offset: params.offset,
    );
  }
}
