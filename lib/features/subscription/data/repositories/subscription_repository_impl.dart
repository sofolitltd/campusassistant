import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../models/subscription_model.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final ApiClient apiClient;

  SubscriptionRepositoryImpl({required this.apiClient});

  @override
  Future<Either<Failure, List<SubscriptionPlan>>> getPlans({
    required String universityId,
    required String departmentId,
  }) async {
    try {
      final response = await apiClient.get(
        '/subscriptions/plans',
        queryParameters: {
          'university_id': universityId,
          'department_id': departmentId,
        },
      );
      final List<dynamic> data = response.data;
      debugPrint("SUBSCRIPTION PLANS DATA: $data");
      final plans = data
          .map((json) => SubscriptionPlanModel.fromJson(json).toEntity())
          .toList();
      return Right(List<SubscriptionPlan>.from(plans));
    } catch (e, stack) {
      debugPrint("SUBSCRIPTION PARSING ERROR: $e");
      debugPrint("STACK: $stack");
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Subscription?>> getUserSubscription(
    String userId,
  ) async {
    try {
      final response = await apiClient.get('/subscriptions/user/$userId');
      if (response.data == null) {
        return const Right(null);
      }
      final model = SubscriptionModel.fromJson(response.data);
      return Right(model as Subscription);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createSubscription(
    Subscription subscription,
  ) async {
    try {
      final model = SubscriptionModel(
        id: subscription.id,
        userId: subscription.userId,
        plan: subscription.plan,
        startDate: subscription.startDate,
        endDate: subscription.endDate,
      );
      await apiClient.post('/subscriptions', data: model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
