import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/theme/tokens/app_spacing.dart';
import '../providers/reward_providers.dart';
import '../widgets/transaction_tile.dart';

class RewardHistoryPage extends ConsumerWidget {
  const RewardHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(rewardTransactionsProvider);

    return CustomHeaderLayout(
      title: 'Transaction History',
      showSearchBar: false,
      body: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.extentAfter < 400) {
            ref.read(rewardTransactionsProvider.notifier).loadNextPage();
          }
          return false;
        },
        child: transactionsAsync.when(
          data: (state) {
            if (state.transactions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    Icon(
                      LucideIcons.receipt,
                      size: 48,
                      color: context.colors.textSubtle,
                    ),
                    const SizedBox(height: Spacing.sm),
                    Text(
                      'No transactions yet',
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: context.colors.textSubtle),
                    ),
                  ],
                ),
              );
            }
            return ListView(
              padding: const EdgeInsets.all(Spacing.lg),
              children: [
                ...state.transactions.map(
                  (txn) => TransactionTile(transaction: txn),
                ),
                HistoryFooter(
                  loading: state.hasMore,
                  count: state.transactions.length,
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) =>
              Center(child: Text('Failed to load transactions: $err')),
        ),
      ),
    );
  }
}
