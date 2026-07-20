import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/transport.dart';
import '../../domain/repositories/transport_repository.dart';
import '../datasources/transport_remote_data_source.dart';
import '../models/transport_model.dart';

class TransportRepositoryImpl implements TransportRepository {
  final TransportRemoteDataSource remoteDataSource;
  final CacheManager cacheManager;
  final ConnectivityService connectivity;

  TransportRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheManager,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, List<Transport>>> getTransports({
    required String universityId,
  }) async {
    final cacheKey = 'uni_$universityId';

    // 1. Try remote if online
    if (connectivity.isConnected) {
      try {
        final remoteTransports = await remoteDataSource.getTransports(
          universityId: universityId,
        );
        final entities = remoteTransports.map((e) => e.toEntity()).toList();

        // Cache the result
        final cacheItems = remoteTransports.map((m) => m.toJson()).toList();
        await cacheManager.cacheList(
          entityType: 'transport_$cacheKey',
          items: cacheItems,
          ttl: CacheTTL.transport,
        );

        return Right(entities);
      } catch (e) {
        debugPrint('[TransportRepo] Remote fetch failed: $e');
      }
    }

    // 2. Try cached data
    try {
      final cachedData = await cacheManager.getCachedList(
        entityType: 'transport_$cacheKey',
      );

      if (cachedData.isNotEmpty) {
        final transports = cachedData
            .map((json) => TransportModel.fromJson(json).toEntity())
            .toList();
        debugPrint(
          '[TransportRepo] Returning ${transports.length} cached transports',
        );
        return Right(transports);
      }
    } catch (e) {
      debugPrint('[TransportRepo] Cache read failed: $e');
    }

    // 3. No data
    if (!connectivity.isConnected) {
      return const Left(
        NetworkFailure(
          'No internet connection and no cached transport data available',
        ),
      );
    }

    return Left(ServerFailure('Failed to fetch transport data'));
  }
}
