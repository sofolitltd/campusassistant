import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/cache/sync_manager.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/emergency_contact.dart';
import '../../domain/repositories/emergency_repository.dart';
import '../datasources/emergency_remote_data_source.dart';
import '../models/emergency_contact_model.dart';

class EmergencyRepositoryImpl implements EmergencyRepository {
  final EmergencyRemoteDataSource remoteDataSource;
  final CacheManager cacheManager;
  final ConnectivityService connectivity;
  final SyncManager syncManager;

  EmergencyRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheManager,
    required this.connectivity,
    required this.syncManager,
  });

  @override
  Future<Either<Failure, PaginatedEmergencyContacts>> getEmergencyContacts({
    String? universityId,
    String? departmentId,
    String? scope,
    String? search,
    int? limit,
    int? offset,
  }) async {
    final cacheKey = _buildCacheKey(
      universityId: universityId,
      departmentId: departmentId,
      scope: scope,
    );

    // 1. Try remote if online
    if (connectivity.isConnected) {
      try {
        final model = await remoteDataSource.getEmergencyContacts(
          universityId: universityId,
          departmentId: departmentId,
          scope: scope,
          search: search,
          limit: limit,
          offset: offset,
        );

        // Cache the result
        final cacheItems = model.contacts.map((m) => m.toJson()).toList();
        await cacheManager.cacheList(
          entityType: 'emergency_$cacheKey',
          items: cacheItems,
          ttl: CacheTTL.emergency,
        );

        return Right(PaginatedEmergencyContacts(
          contacts: model.contacts.map((m) => m.toEntity()).toList(),
          total: model.total,
        ));
      } catch (e) {
        debugPrint('[EmergencyRepo] Remote fetch failed: $e');
      }
    }

    // 2. Try cached data
    try {
      final cachedData = await cacheManager.getCachedList(
        entityType: 'emergency_$cacheKey',
      );

      if (cachedData.isNotEmpty) {
        final contacts = cachedData
            .map((json) => EmergencyContactModel.fromJson(json).toEntity())
            .toList();
        debugPrint('[EmergencyRepo] Returning ${contacts.length} cached contacts');
        return Right(PaginatedEmergencyContacts(
          contacts: contacts,
          total: cachedData.length,
        ));
      }
    } catch (e) {
      debugPrint('[EmergencyRepo] Cache read failed: $e');
    }

    // 3. No data
    if (!connectivity.isConnected) {
      return const Left(NetworkFailure(
        'No internet connection and no cached emergency contacts available',
      ));
    }

    return Left(ServerFailure('Failed to fetch emergency contacts'));
  }

  @override
  Future<Either<Failure, EmergencyContact>> createContact(
    EmergencyContact contact,
  ) async {
    if (connectivity.isConnected) {
      try {
        final model = EmergencyContactModel.fromEntity(contact);
        final remoteContact = await remoteDataSource.createContact(model);
        return Right(remoteContact.toEntity());
      } catch (e) {
        debugPrint('[EmergencyRepo] Remote create failed: $e');
      }
    }

    return Left(NetworkFailure(
      'Create operation requires internet connection',
    ));
  }

  @override
  Future<Either<Failure, EmergencyContact>> updateContact(
    EmergencyContact contact,
  ) async {
    if (connectivity.isConnected) {
      try {
        final model = EmergencyContactModel.fromEntity(contact);
        final remoteContact = await remoteDataSource.updateContact(model);
        return Right(remoteContact.toEntity());
      } catch (e) {
        debugPrint('[EmergencyRepo] Remote update failed: $e');
      }
    }

    return Left(NetworkFailure(
      'Update operation requires internet connection',
    ));
  }

  @override
  Future<Either<Failure, Unit>> deleteContact(String id) async {
    if (connectivity.isConnected) {
      try {
        await remoteDataSource.deleteContact(id);
        return const Right(unit);
      } catch (e) {
        debugPrint('[EmergencyRepo] Remote delete failed: $e');
      }
    }

    return Left(NetworkFailure(
      'Delete operation requires internet connection',
    ));
  }

  String _buildCacheKey({
    String? universityId,
    String? departmentId,
    String? scope,
  }) {
    final parts = <String>[
      if (scope != null) 'scope_$scope',
      if (universityId != null) 'uni_$universityId',
      if (departmentId != null) 'dept_$departmentId',
    ];
    return parts.isEmpty ? 'global' : parts.join('_');
  }
}
