import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/transport.dart';

abstract class TransportRepository {
  Future<Either<Failure, List<Transport>>> getTransports({
    required String universityId,
  });
}
