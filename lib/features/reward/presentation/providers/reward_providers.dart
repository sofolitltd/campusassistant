import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '../../data/datasources/reward_remote_data_source.dart';
import '../../data/models/reward_balance.dart';
import '../../data/models/reward_transaction.dart';
import '../../data/repositories/reward_repository.dart';
import '/core/providers/cache_for.dart';

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

class RewardTransactionsState {
  final List<RewardTransaction> transactions;
  final int totalCount;
  final bool isLoadingMore;
  final bool hasMore;

  const RewardTransactionsState({
    required this.transactions,
    required this.totalCount,
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  RewardTransactionsState copyWith({
    List<RewardTransaction>? transactions,
    int? totalCount,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return RewardTransactionsState(
      transactions: transactions ?? this.transactions,
      totalCount: totalCount ?? this.totalCount,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// Infinite-scroll coin history: the first page loads on build, the reward
/// page calls [RewardTransactionsNotifier.loadNextPage] near the end.
final rewardTransactionsProvider =
    AsyncNotifierProvider<RewardTransactionsNotifier, RewardTransactionsState>(
      RewardTransactionsNotifier.new,
    );

class RewardTransactionsNotifier
    extends AsyncNotifier<RewardTransactionsState> {
  static const int _limit = 20;

  @override
  Future<RewardTransactionsState> build() async {
    final repo = ref.watch(rewardRepositoryProvider);
    final result = await repo.getTransactions(limit: _limit, offset: 0);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (page) => RewardTransactionsState(
        transactions: page.data,
        totalCount: page.count,
        hasMore: page.count > page.data.length,
      ),
    );
  }

  Future<void> loadNextPage() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncValue.data(current.copyWith(isLoadingMore: true));

    final result = await ref
        .read(rewardRepositoryProvider)
        .getTransactions(limit: _limit, offset: current.transactions.length);
    state = AsyncValue.data(
      result.fold(
        (_) => current.copyWith(isLoadingMore: false, hasMore: false),
        (page) {
          final transactions = [...current.transactions, ...page.data];
          return current.copyWith(
            transactions: transactions,
            totalCount: page.count,
            isLoadingMore: false,
            // An empty page also ends it, so a shrinking total can't loop.
            hasMore: page.data.isNotEmpty && page.count > transactions.length,
          );
        },
      ),
    );
  }
}

final rewardCostProvider = FutureProvider.autoDispose.family<int, String>((
  ref,
  resourceId,
) async {
  ref.cacheFor(kParamProviderCacheTime);
  final repo = ref.watch(rewardRepositoryProvider);
  final result = await repo.getCost(resourceId);
  return result.fold((_) => 1, (cost) => cost);
});

/// Read-only: whether today's login reward has already been claimed.
/// Never triggers a claim itself — the claim only happens on an explicit
/// button tap via [RewardRepository.claimDailyLogin].
final dailyLoginStatusProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final repo = ref.watch(rewardRepositoryProvider);
  final result = await repo.getDailyLoginStatus();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (status) => status,
  );
});
