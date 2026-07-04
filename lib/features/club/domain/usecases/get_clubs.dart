import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/club.dart';
import '../repositories/club_repository.dart';

part 'get_clubs.freezed.dart';

@freezed
abstract class GetClubsParams with _$GetClubsParams {
  const factory GetClubsParams({
    required String universityId,
    String? departmentId,
    required String type,
  }) = _GetClubsParams;
}

class GetClubs implements UseCase<List<Club>, GetClubsParams> {
  final ClubRepository repository;

  GetClubs(this.repository);

  @override
  Future<Either<Failure, List<Club>>> call(GetClubsParams params) async {
    return await repository.getClubs(
      universityId: params.universityId,
      departmentId: params.departmentId,
      type: params.type,
    );
  }
}
