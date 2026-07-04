import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/emergency_contact.dart';
import '../../domain/repositories/emergency_repository.dart';
import '../datasources/emergency_remote_data_source.dart';
import '../models/emergency_contact_model.dart';

class EmergencyRepositoryImpl implements EmergencyRepository {
  final EmergencyRemoteDataSource remoteDataSource;

  EmergencyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PaginatedEmergencyContacts>> getEmergencyContacts({
    String? universityId,
    String? departmentId,
    String? scope,
    String? search,
    int? limit,
    int? offset,
  }) async {
    try {
      final model = await remoteDataSource.getEmergencyContacts(
        universityId: universityId,
        departmentId: departmentId,
        scope: scope,
        search: search,
        limit: limit,
        offset: offset,
      );
      
      // Map models to entities within the paginated wrapper
      return Right(PaginatedEmergencyContacts(
        contacts: model.contacts.map((m) => (m).toEntity()).toList(),
        total: model.total,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EmergencyContact>> createContact(
    EmergencyContact contact,
  ) async {
    try {
      final model = EmergencyContactModel.fromEntity(contact);
      final remoteContact = await remoteDataSource.createContact(model);
      return Right(remoteContact.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EmergencyContact>> updateContact(
    EmergencyContact contact,
  ) async {
    try {
      final model = EmergencyContactModel.fromEntity(contact);
      final remoteContact = await remoteDataSource.updateContact(model);
      return Right(remoteContact.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteContact(String id) async {
    try {
      await remoteDataSource.deleteContact(id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
