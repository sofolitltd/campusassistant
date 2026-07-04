import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/emergency_contact.dart';
import '../repositories/emergency_repository.dart';

part 'get_emergency_contacts.freezed.dart';

@freezed
abstract class GetEmergencyContactsParams with _$GetEmergencyContactsParams {
  const factory GetEmergencyContactsParams({
    String? universityId,
    String? departmentId,
    String? scope,
    String? search,
    int? limit,
    int? offset,
  }) = _GetEmergencyContactsParams;
}

class GetEmergencyContacts
    implements UseCase<PaginatedEmergencyContacts, GetEmergencyContactsParams> {
  final EmergencyRepository repository;

  GetEmergencyContacts(this.repository);

  @override
  Future<Either<Failure, PaginatedEmergencyContacts>> call(
    GetEmergencyContactsParams params,
  ) async {
    return await repository.getEmergencyContacts(
      universityId: params.universityId,
      departmentId: params.departmentId,
      scope: params.scope,
      search: params.search,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class CreateEmergencyContact
    implements UseCase<EmergencyContact, EmergencyContact> {
  final EmergencyRepository repository;

  CreateEmergencyContact(this.repository);

  @override
  Future<Either<Failure, EmergencyContact>> call(
    EmergencyContact contact,
  ) async {
    return await repository.createContact(contact);
  }
}

class UpdateEmergencyContact
    implements UseCase<EmergencyContact, EmergencyContact> {
  final EmergencyRepository repository;

  UpdateEmergencyContact(this.repository);

  @override
  Future<Either<Failure, EmergencyContact>> call(
    EmergencyContact contact,
  ) async {
    return await repository.updateContact(contact);
  }
}

class DeleteEmergencyContact implements UseCase<Unit, String> {
  final EmergencyRepository repository;

  DeleteEmergencyContact(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return await repository.deleteContact(id);
  }
}
