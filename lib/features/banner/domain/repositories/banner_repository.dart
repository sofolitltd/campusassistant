import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/banner.dart';

abstract class BannerRepository {
  Future<Either<Failure, List<Banner>>> getBanners({
    String? universityId,
    String? departmentId,
    String? mode,
  });

  Future<Either<Failure, Banner>> createBanner(Banner banner);
  Future<Either<Failure, Banner>> updateBanner(Banner banner);
  Future<Either<Failure, void>> deleteBanner(String id);
}
