import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../data/repositories/subscription_repository_impl.dart';
import '../../../../core/providers/cache_for.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SubscriptionRepositoryImpl(apiClient: apiClient);
});

final userSubscriptionProvider = FutureProvider.autoDispose
    .family<Subscription?, String>((ref, userId) async {
      ref.cacheFor(kParamProviderCacheTime);
      final repo = ref.watch(subscriptionRepositoryProvider);
      final result = await repo.getUserSubscription(userId);
      return result.fold((failure) => null, (subscription) => subscription);
    });

final subscriptionPlansProvider = FutureProvider.autoDispose
    .family<
      List<SubscriptionPlan>,
      ({String universityId, String departmentId})
    >((ref, params) async {
      ref.cacheFor(kParamProviderCacheTime);
      final repo = ref.watch(subscriptionRepositoryProvider);
      final result = await repo.getPlans(
        universityId: params.universityId,
        departmentId: params.departmentId,
      );
      return result.fold((failure) => [], (plans) => plans);
    });
