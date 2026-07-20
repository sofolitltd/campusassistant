import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/transport.dart';
import '../repositories/transport_repository.dart';

part 'get_transports.freezed.dart';

@freezed
abstract class GetTransportsParams with _$GetTransportsParams {
  const factory GetTransportsParams({required String universityId}) =
      _GetTransportsParams;
}

class GetTransports implements UseCase<List<Transport>, GetTransportsParams> {
  final TransportRepository repository;

  GetTransports(this.repository);

  @override
  Future<Either<Failure, List<Transport>>> call(
    GetTransportsParams params,
  ) async {
    return await repository.getTransports(universityId: params.universityId);
  }
}
