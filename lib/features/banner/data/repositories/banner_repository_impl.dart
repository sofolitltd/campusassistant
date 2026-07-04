import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/banner.dart';
import '../../domain/repositories/banner_repository.dart';
import '../datasources/banner_remote_data_source.dart';
import '../models/banner_model.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerRemoteDataSource remoteDataSource;

  BannerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Banner>>> getBanners({
    String? universityId,
    String? departmentId,
    String? mode,
  }) async {
    try {
      final remoteBanners = await remoteDataSource.getBanners(
        universityId: universityId,
        departmentId: departmentId,
        mode: mode,
      );
      return Right(remoteBanners.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Banner>> createBanner(Banner banner) async {
    try {
      final model = BannerModel(
        id: banner.id,
        title: banner.title,
        imageUrl: banner.imageUrl,
        clickUrl: banner.clickUrl,
        priority: banner.priority,
        isActive: banner.isActive,
        startAt: banner.startAt,
        endAt: banner.endAt,
        targetScope: banner.targetScope,
        targets: banner.targets
            .map(
              (t) => BannerTargetModel(
                bannerId: t.bannerId,
                universityId: t.universityId,
                departmentId: t.departmentId,
              ),
            )
            .toList(),
      );
      final result = await remoteDataSource.createBanner(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Banner>> updateBanner(Banner banner) async {
    try {
      final model = BannerModel(
        id: banner.id,
        title: banner.title,
        imageUrl: banner.imageUrl,
        clickUrl: banner.clickUrl,
        priority: banner.priority,
        isActive: banner.isActive,
        startAt: banner.startAt,
        endAt: banner.endAt,
        targetScope: banner.targetScope,
        targets: banner.targets
            .map(
              (t) => BannerTargetModel(
                id: t.id,
                bannerId: t.bannerId,
                universityId: t.universityId,
                departmentId: t.departmentId,
              ),
            )
            .toList(),
      );
      final result = await remoteDataSource.updateBanner(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBanner(String id) async {
    try {
      await remoteDataSource.deleteBanner(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
