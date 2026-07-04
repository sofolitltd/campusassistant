import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/banner.dart';
import '../repositories/banner_repository.dart';

class GetBanners implements UseCase<List<Banner>, GetBannersParams> {
  final BannerRepository repository;

  GetBanners(this.repository);

  @override
  Future<Either<Failure, List<Banner>>> call(GetBannersParams params) async {
    return await repository.getBanners(
      universityId: params.universityId,
      departmentId: params.departmentId,
      mode: params.mode,
    );
  }
}

class GetBannersParams {
  final String? universityId;
  final String? departmentId;
  final String? mode;

  GetBannersParams({this.universityId, this.departmentId, this.mode});
}
