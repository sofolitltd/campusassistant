import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/subscription.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, List<SubscriptionPlan>>> getPlans({
    required String universityId,
    required String departmentId,
  });

  Future<Either<Failure, Subscription?>> getUserSubscription(String userId);

  Future<Either<Failure, void>> createSubscription(Subscription subscription);
}
