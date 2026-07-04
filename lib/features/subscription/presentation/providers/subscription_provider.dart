import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../data/repositories/subscription_repository_impl.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SubscriptionRepositoryImpl(apiClient: apiClient);
});

final userSubscriptionProvider = FutureProvider.family<Subscription?, String>((
  ref,
  userId,
) async {
  final repo = ref.watch(subscriptionRepositoryProvider);
  final result = await repo.getUserSubscription(userId);
  return result.fold((failure) => null, (subscription) => subscription);
});

final subscriptionPlansProvider =
    FutureProvider.family<
      List<SubscriptionPlan>,
      ({String universityId, String departmentId})
    >((ref, params) async {
      final repo = ref.watch(subscriptionRepositoryProvider);
      final result = await repo.getPlans(
        universityId: params.universityId,
        departmentId: params.departmentId,
      );
      return result.fold((failure) => [], (plans) => plans);
    });
