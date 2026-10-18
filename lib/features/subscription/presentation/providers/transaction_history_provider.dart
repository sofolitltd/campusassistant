import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '/core/network/api_client.dart';
import '../../data/models/bkash_transaction.dart';

class TransactionPage {
  final List<BkashTransaction> transactions;
  final int total;

  const TransactionPage({required this.transactions, required this.total});
}

class TransactionHistoryRepository {
  final ApiClient apiClient;

  TransactionHistoryRepository({required this.apiClient});

  Future<TransactionPage> list({
    required int limit,
    required int offset,
  }) async {
    final response = await apiClient.get(
      '/payments/bkash/transactions',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    final data = response.data as Map<String, dynamic>;
    final list = data['transactions'] as List? ?? [];
    return TransactionPage(
      transactions: list
          .map((e) => BkashTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (data['total'] as num?)?.toInt() ?? list.length,
    );
  }
}

final transactionHistoryRepositoryProvider =
    Provider<TransactionHistoryRepository>((ref) {
      return TransactionHistoryRepository(
        apiClient: ref.watch(apiClientProvider),
      );
    });

class TransactionHistoryState {
  final List<BkashTransaction> transactions;
  final int totalCount;
  final bool isLoadingMore;
  final bool hasMore;

  const TransactionHistoryState({
    required this.transactions,
    required this.totalCount,
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  TransactionHistoryState copyWith({
    List<BkashTransaction>? transactions,
    int? totalCount,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return TransactionHistoryState(
      transactions: transactions ?? this.transactions,
      totalCount: totalCount ?? this.totalCount,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// Infinite-scroll history: the first page loads on build, the list calls
/// [TransactionHistoryNotifier.loadNextPage] as it nears the end.
final transactionHistoryProvider =
    AsyncNotifierProvider<TransactionHistoryNotifier, TransactionHistoryState>(
      TransactionHistoryNotifier.new,
    );

class TransactionHistoryNotifier
    extends AsyncNotifier<TransactionHistoryState> {
  static const int _limit = 20;

  @override
  Future<TransactionHistoryState> build() async {
    final page = await ref
        .read(transactionHistoryRepositoryProvider)
        .list(limit: _limit, offset: 0);
    return TransactionHistoryState(
      transactions: page.transactions,
      totalCount: page.total,
      hasMore: page.total > page.transactions.length,
    );
  }

  Future<void> loadNextPage() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncValue.data(current.copyWith(isLoadingMore: true));

    try {
      final page = await ref
          .read(transactionHistoryRepositoryProvider)
          .list(limit: _limit, offset: current.transactions.length);
      final transactions = [...current.transactions, ...page.transactions];
      state = AsyncValue.data(
        current.copyWith(
          transactions: transactions,
          totalCount: page.total,
          isLoadingMore: false,
          // An empty page also ends it, so a shrinking total can't loop.
          hasMore:
              page.transactions.isNotEmpty && page.total > transactions.length,
        ),
      );
    } catch (_) {
      state = AsyncValue.data(
        current.copyWith(isLoadingMore: false, hasMore: false),
      );
    }
  }

  void refresh() => ref.invalidateSelf();
}
