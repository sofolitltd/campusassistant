import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/di.dart';
import '../../data/datasources/reward_remote_data_source.dart';
import '../../data/models/reward_balance.dart';
import '../../data/models/reward_transaction.dart';
import '../../data/repositories/reward_repository.dart';

final rewardRemoteDataSourceProvider = Provider<RewardRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RewardRemoteDataSourceImpl(apiClient: apiClient);
});

final rewardRepositoryProvider = Provider<RewardRepository>((ref) {
  final remoteDataSource = ref.watch(rewardRemoteDataSourceProvider);
  return RewardRepositoryImpl(remoteDataSource: remoteDataSource);
});

final rewardBalanceProvider = FutureProvider<RewardBalance>((ref) async {
  final repo = ref.watch(rewardRepositoryProvider);
  final result = await repo.getBalance();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (balance) => balance,
  );
});

final rewardEarnProvider = FutureProvider<RewardBalance>((ref) async {
  final repo = ref.watch(rewardRepositoryProvider);
  final result = await repo.earn();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (balance) => balance,
  );
});

final rewardTransactionsProvider =
    FutureProvider.family<({List<RewardTransaction> data, int count}), int>((
      ref,
      offset,
    ) async {
      final repo = ref.watch(rewardRepositoryProvider);
      final result = await repo.getTransactions(limit: 20, offset: offset);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (data) => data,
      );
    });

final rewardCostProvider = FutureProvider.family<int, String>((
  ref,
  resourceId,
) async {
  final repo = ref.watch(rewardRepositoryProvider);
  final result = await repo.getCost(resourceId);
  return result.fold((_) => 1, (cost) => cost);
});
