import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/widgets/section_card.dart';
import '../../data/models/bkash_transaction.dart';
import '../providers/transaction_history_provider.dart';
import '/core/theme/tokens/app_font_size.dart';

class TransactionHistoryPage extends ConsumerWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionHistoryProvider);

    return CustomHeaderLayout(
      title: 'Transaction History',
      showSearchBar: false,
      body: transactionsAsync.when(
        data: (transactions) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(transactionHistoryProvider),
          child: transactions.isEmpty
              ? _buildEmptyState(context)
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    Spacing.lg,
                    Spacing.lg,
                    Spacing.lg,
                    Spacing.lg + MediaQuery.paddingOf(context).bottom,
                  ),
                  itemCount: transactions.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: Spacing.sm + 2),
                  itemBuilder: (context, index) =>
                      _TransactionTile(transaction: transactions[index]),
                ),
        ),
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                Icon(
                  LucideIcons.receiptText,
                  size: 56,
                  color: context.colors.textSubtle,
                ),
                const SizedBox(height: Spacing.md),
                Text(
                  'No transactions yet',
                  style: TextStyle(
                    color: context.colors.textMuted,
                    fontWeight: .w500,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  'Your bKash payments will show up here',
                  style: TextStyle(
                    color: context.colors.textSubtle,
                    fontSize: FontSizeToken.md,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final BkashTransaction transaction;

  const _TransactionTile({required this.transaction});

  /// (foreground, tinted background) from the status roles.
  (Color, Color) _statusColors(AppColors c, String status) {
    return switch (status) {
      'completed' => (c.success, c.successSubtle),
      'failed' => (c.danger, c.dangerSubtle),
      'cancelled' => (c.textMuted, c.surfaceAlt),
      _ => (c.warning, c.warningSubtle),
    };
  }

  String _statusLabel(String status) {
    return switch (status) {
      'completed' => 'Completed',
      'failed' => 'Failed',
      'cancelled' => 'Cancelled',
      _ => 'Pending',
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (statusColor, statusBg) = _statusColors(colors, transaction.status);

    return SectionCard(
      radius: RadiusToken.lg,
      shadow: false,
      padding: const EdgeInsets.all(Spacing.md + 2),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(RadiusToken.md),
            ),
            child: Icon(LucideIcons.receiptText, color: statusColor, size: 20),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  transaction.planTitle,
                  style: TextStyle(fontWeight: .w600, color: colors.text),
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  DateFormat(
                    'MMM dd, yyyy · hh:mm a',
                  ).format(transaction.createdAt),
                  style: TextStyle(
                    fontSize: FontSizeToken.sm,
                    color: colors.textMuted,
                  ),
                ),
                if (transaction.trxId.isNotEmpty) ...[
                  const SizedBox(height: Spacing.xxs),
                  Text(
                    'Trx ID: ${transaction.trxId}',
                    style: TextStyle(
                      fontSize: FontSizeToken.xs,
                      color: colors.textSubtle,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: .end,
            children: [
              Text(
                '৳${transaction.amount}',
                style: TextStyle(
                  fontWeight: .w800,
                  fontSize: FontSizeToken.lg,
                  color: colors.text,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                  vertical: Spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(RadiusToken.full),
                ),
                child: Text(
                  _statusLabel(transaction.status),
                  style: TextStyle(
                    fontSize: FontSizeToken.xs,
                    fontWeight: .w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
