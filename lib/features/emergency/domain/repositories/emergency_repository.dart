import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/emergency_contact.dart';

class PaginatedEmergencyContacts {
  final List<EmergencyContact> contacts;
  final int total;

  PaginatedEmergencyContacts({required this.contacts, required this.total});
}

abstract class EmergencyRepository {
  Future<Either<Failure, PaginatedEmergencyContacts>> getEmergencyContacts({
    String? universityId,
    String? departmentId,
    String? scope,
    String? search,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, EmergencyContact>> createContact(
    EmergencyContact contact,
  );
  Future<Either<Failure, EmergencyContact>> updateContact(
    EmergencyContact contact,
  );
  Future<Either<Failure, Unit>> deleteContact(String id);
}
